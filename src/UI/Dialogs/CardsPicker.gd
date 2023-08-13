extends Window

const BASE = preload("res://src/UI/Cards/Card.tscn")

@onready var items: ItemList = $VBoxContainer/Items

var scripts = {
	"Create Basic Shape": preload("res://src/UI/Cards/Creation/BasicShape.tscn"),
	"Load File": preload("res://src/UI/Cards/Creation/LoadFile.tscn"),
	"AdjustBCS (Not Working)": preload("res://src/UI/Cards/Adjustments/AdjustBCS.tscn"),
	"Layer Create": preload("res://src/UI/Cards/LayerOp/LayerCreate.tscn"),
	"Layer Switch": preload("res://src/UI/Cards/LayerOp/LayerSwitch.tscn"),
	"Layer Copy": preload("res://src/UI/Cards/LayerOp/LayerCopy.tscn"),
	"Layer Erase": preload("res://src/UI/Cards/LayerOp/LayerErase.tscn"),
}


func _ready() -> void:
	about_to_popup.connect(_load_list)
	_load_list()


func _load_list() -> void:
	items.clear()
	for key in scripts.keys():
		items.add_item(key)

func _on_close_requested() -> void:
	hide()

func _on_items_item_activated(idx: int) -> void:
	Global.stack.add_card(scripts.values()[idx].instantiate())


