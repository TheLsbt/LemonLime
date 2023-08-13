# FloatProperty.gd
extends "res://src/UI/Inspector/Properties/Property.gd"


@onready var spinbox: SpinBox = $SpinBox


func _ready() -> void:
	spinbox.value_changed.connect(_on_spinbox_value_changed)

func _on_spinbox_value_changed(new_value: float) -> void:
	emit_changed(_editing_property, new_value)

func _update_property() -> void:
	spinbox.set_value(_editing_object.get_property(_editing_property))


func _parse_settings(settings: Dictionary) -> void:
	spinbox.min_value = settings.get("min", 0)
	spinbox.max_value = settings.get("max", 100)
	spinbox.step = settings.get("step", 0.01)
	spinbox.exp_edit = settings.get("exp", false)
	spinbox.allow_greater = settings.get("allow_greater", false)
	spinbox.allow_lesser = settings.get("allow_lesser", false)
	spinbox.editable = !settings.get("disabled", false)
	
