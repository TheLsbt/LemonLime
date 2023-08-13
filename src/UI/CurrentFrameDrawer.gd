extends Node2D


func _draw() -> void:
	var layers : Array = Global.stack.field.layers.values()
	for image in layers:
		var rect = Rect2(Vector2.ZERO, Global.project.size)
		var texture_rect = Rect2(Vector2.ZERO, Vector2(image.get_size()))
		var texture = RenderingServer.texture_2d_create(image)
		RenderingServer.canvas_item_add_texture_rect_region(get_canvas_item(), rect, texture, texture_rect)
#		draw_texture(texture, , Color.WHITE)
