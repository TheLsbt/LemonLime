class_name ShaderEffect
extends RefCounted

signal done

func generate(img: Image, shader: Shader, params: Dictionary, size: Vector2i) -> void:
	shader = shader.duplicate()
	shader.code = shader.code.replace("unshaded", "unshaded, blend_premul_alpha")
	var viewport := RenderingServer.viewport_create()
	var canvas := RenderingServer.canvas_create()
	RenderingServer.viewport_attach_canvas(viewport, canvas)
	RenderingServer.viewport_set_size(viewport, size.x, size.y)
	RenderingServer.viewport_set_disable_3d(viewport, true)
	RenderingServer.viewport_set_active(viewport, true)
	RenderingServer.viewport_set_transparent_background(viewport, true)
	RenderingServer.viewport_set_default_canvas_item_texture_filter(viewport,
		RenderingServer.CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	)
	var item := RenderingServer.canvas_item_create()
	RenderingServer.viewport_set_canvas_transform(viewport, canvas, Transform2D())
	RenderingServer.canvas_item_set_parent(item, canvas)
	var texture := RenderingServer.texture_2d_create(img)
	RenderingServer.canvas_item_add_texture_rect(
		item, Rect2(Vector2.ZERO, size), texture
	)
	
	var mat_rid := RenderingServer.material_create()
	RenderingServer.material_set_shader(mat_rid, shader.get_rid())
	RenderingServer.canvas_item_set_material(item, mat_rid)
	for key in params:
		var param = params[key]
		if param is Texture2D:
			RenderingServer.material_set_param(mat_rid, key, [param])
		else:
			RenderingServer.material_set_param(mat_rid, key, param)
	
	RenderingServer.viewport_set_update_mode(viewport, RenderingServer.VIEWPORT_UPDATE_ONCE)
	RenderingServer.force_draw(false)
	var viewport_texture := RenderingServer.texture_2d_get(
		RenderingServer.viewport_get_texture(viewport)
	)
	RenderingServer.free_rid(viewport)
	RenderingServer.free_rid(canvas)
	RenderingServer.free_rid(item)
	RenderingServer.free_rid(mat_rid)
	RenderingServer.free_rid(texture)
	viewport_texture.convert(Image.FORMAT_RGBA8)
	img.copy_from(viewport_texture)
	done.emit()
	
	
