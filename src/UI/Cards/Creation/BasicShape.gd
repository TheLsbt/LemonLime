extends Card

enum SHAPES {
	Circle, Rectangle
}

var shape : SHAPES = 0
var color := Color.BLACK
var offset := Vector2i(0, 0)
var dimensions := Vector2i(16, 16)

func _init() -> void:
	unique_name = "CreateBasicShape"

func _ready() -> void:
	set_title(unique_name.capitalize())

func _on_shape_types_item_selected(idx: int) -> void:
	shape = idx
	changed.emit()

func _on_color_picker_btn_color_changed(new_color: Color) -> void:
	color = new_color
	changed.emit()

func _on_dimension_value_changed(new_value: int, is_x: bool) -> void:
	if is_x:
		dimensions.x = new_value
	else:
		dimensions.y = new_value
	changed.emit()

func _on_offset_value_changed(new_value: int, is_x: bool) -> void:
	if is_x:
		offset.x = new_value
	else:
		offset.y = new_value
	changed.emit()

func run(image: Image) -> void:
	var size := image.get_size()
	var vp := RenderingServer.viewport_create()
	var canvas := RenderingServer.canvas_create()
	

	RenderingServer.viewport_attach_canvas(vp, canvas)
	RenderingServer.viewport_set_size(vp, size.x, size.y)
	RenderingServer.viewport_set_disable_3d(vp, true)
	RenderingServer.viewport_set_active(vp, true)
	RenderingServer.viewport_set_transparent_background(vp, true)
	
	# Draw a shape using the RenderingServer.
	var item := RenderingServer.canvas_item_create()
	RenderingServer.canvas_item_set_parent(item, canvas)
	RenderingServer.viewport_set_canvas_transform(vp, canvas, Transform2D())
	
	
	# Apply the input first because we will be drawing over it.
	var texture_rid := RenderingServer.texture_2d_create(image)
	RenderingServer.canvas_item_add_texture_rect(item, Rect2(Vector2.ZERO, size), texture_rid)
	
	# Drawing of shapes
	match shape:
		0:
			_rs_add_draw_circle(item, offset, dimensions, color)
		1:
			RenderingServer.canvas_item_add_rect(item, Rect2i(offset / 2, dimensions * 2), color)
			
	
	RenderingServer.viewport_set_update_mode(vp, RenderingServer.VIEWPORT_UPDATE_ONCE)
	RenderingServer.force_draw(true)
	var vp_texture = Image.new()
	vp_texture = RenderingServer.texture_2d_get(
		RenderingServer.viewport_get_texture(vp)
	)
	
	
	RenderingServer.free_rid(vp)
	RenderingServer.free_rid(canvas)
	RenderingServer.free_rid(item)
	RenderingServer.free_rid(texture_rid)
	
	vp_texture.convert(Image.FORMAT_RGBA8)
	
	if !vp_texture.is_empty():
		image.copy_from(vp_texture)
	

func _rs_add_draw_circle(item: RID, position: Vector2i, dimensions: Vector2i, color: Color) -> void:
	var nb_points:= 32
	var points := PackedVector2Array()
	
	for i in range(nb_points + 1):
		var angle = deg_to_rad(0 +  i * (360) / nb_points - 90)
		points.append(Vector2(position) + Vector2(cos(angle), sin(angle)) * Vector2(dimensions))
	
	RenderingServer.canvas_item_add_polygon(item, points, PackedColorArray([color]))

