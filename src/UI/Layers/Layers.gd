extends MarginContainer

const DeleteIcon = preload("res://assets/Common/UI/DeleteLayerName.png")
const CopyIcon = preload("res://assets/Common/UI/CopyLayerName.png")

enum BUTTON_IDS  {DELETE, COPY_NAME}

@onready var layer_name_edit: LineEdit = $Container/LayerCreator/LayerNameEdit
@onready var layer_add_btn: Button = $Container/LayerCreator/AddBtn
@onready var layer_tree: Tree = $Container/LayerTree

func _ready() -> void:
	layer_name_edit.text_submitted.connect(_on_layer_name_edit_submitted)
	layer_add_btn.button_down.connect(_on_add_btn_button_down)
	
	Global.layer_added.connect(_on_layer_added)
	Global.layer_removed.connect(_on_layer_removed)
	
	layer_tree.button_clicked.connect(_on_layer_tree_button_clicked)
	
	layer_tree.set_hide_root(true)

func create_layer() -> bool:
	return Global.add_layer(layer_name_edit.text)

func _update_tree() -> void:
	layer_tree.clear()
	var root := layer_tree.create_item()
	for l in Global.project.layers:
		var item := root.create_child()
		item.set_text(0, l.capitalize())
		item.set_metadata(0, l)
		item.add_button(0, CopyIcon, BUTTON_IDS.COPY_NAME)
		item.add_button(0, DeleteIcon, BUTTON_IDS.DELETE)

# From Signal
func _on_layer_added(_layer_idx: int) -> void:
	_update_tree()

# From Signal
func _on_layer_removed(layer_idx: int) -> void:
	layer_tree.get_root().get_child(layer_idx).free()

# From Signal
func _on_add_btn_button_down() -> void:
	if create_layer():
		layer_name_edit.clear()

# From Signal
func _on_layer_name_edit_submitted(text: String) -> void:
	if create_layer():
		layer_name_edit.clear()

func _on_layer_tree_button_clicked(item: TreeItem, col: int, id: int, mouse_btn_idx: int) -> void:
	match id:
		BUTTON_IDS.COPY_NAME:
			DisplayServer.clipboard_set(item.get_metadata(0))
		BUTTON_IDS.DELETE:
			Global.remove_layer(item.get_index())
