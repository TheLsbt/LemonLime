# IntProperty.gd
extends "res://src/UI/Inspector/Properties/Property.gd"


@onready var spinbox: SpinBox = $SpinBox
@onready var enums_options: OptionButton = $Enums

var is_enum := false
var enums : Array = []

func _ready() -> void:
	spinbox.value_changed.connect(_on_spinbox_value_changed)
	enums_options.item_selected.connect(_on_enums_item_selected)

func _on_spinbox_value_changed(new_value: float) -> void:
	emit_changed(_editing_property, new_value)

func _on_enums_item_selected(idx: int) -> void:
	emit_changed(_editing_property, idx)

func _update_property() -> void:
	var value = _editing_object.get_property(_editing_property)
	if is_enum:
		enums_options.clear()
		for e in enums.size():
			enums_options.add_item(str(enums[e]))
			if e == value:
				enums_options.select(e)
		enums_options.visible = true
		spinbox.visible = false
	else:
		spinbox.set_value(value)
		enums_options.visible = false
		spinbox.visible = true


func _parse_settings(settings: Dictionary) -> void:
	spinbox.min_value = settings.get("min", 0)
	spinbox.max_value = settings.get("max", 100)
	spinbox.step = round(settings.get("step", 1))
	spinbox.exp_edit = settings.get("exp", false)
	spinbox.allow_greater = settings.get("allow_greater", false)
	spinbox.allow_lesser = settings.get("allow_lesser", false)
	spinbox.editable = !settings.get("disabled", false)
	is_enum = settings.get("is_enum", false)
	if is_enum:
		enums = settings.get("enums")
	
	
