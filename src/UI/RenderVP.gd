extends SubViewport

@onready var current_frame_vp: SubViewport = $Output/CurrentFrameVP
@onready var current_frame_drawer: Node2D = $Output/CurrentFrameVP/CurrentFrameDrawer


func update() -> void:
	current_frame_drawer.queue_redraw()
