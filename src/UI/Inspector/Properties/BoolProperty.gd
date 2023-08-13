# IntProperty.gd
extends "res://src/UI/Inspector/Properties/Property.gd"


@onready var checkbox: CheckBox = $CheckBox

func _ready() -> void:
	checkbox.toggled.connect(_on_checkbox_toggled)

func _on_checkbox_toggled(toggled: bool) -> void:
	emit_changed(_editing_property, toggled)


func _update_property() -> void:
	checkbox.button_pressed = _editing_object.get_property(_editing_property)


func _parse_settings(settings: Dictionary) -> void:
	checkbox.text = settings.get("text", "On")
	
