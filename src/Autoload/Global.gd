# Global.gd
extends Node

signal layer_added(layer_idx)
signal layer_removed(layer_idx)

@onready var control = get_tree().get_current_scene()
@onready var stack = control.find_child("Stack")
@onready var render_vp := control.find_child("RenderVP")

var project := {
	"size": Vector2i(32, 32),
	"layers": [], # Stores layers as images.
	"stats": {
		"total_layers_created": 0
	}
}

var selected_card : Card = null

func _ready() -> void:
	call_deferred("add_layer")

# Add a new layer to the project layers
# Returns true if the layer is succesfully added
func add_layer(layer_name: String = "") -> bool:
	if layer_name.is_empty():
		layer_name = "Layer " + str(Global.project.layers.size())
	
	if project.layers.has(layer_name):
		printerr("Layer named ", layer_name, " already exists.")
		return false
	
	project.layers.append(layer_name)
	layer_added.emit(project.layers.size() - 1)
	stack.process_stack()
	return true


func remove_layer(idx: int) -> void:
	project.layers.remove_at(idx)
	layer_removed.emit(idx)
	stack.process_stack()
