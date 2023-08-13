# ColorProperty.gd
extends "res://src/UI/Inspector/Properties/Property.gd"


@onready var picker_btn: ColorPickerButton = $ColorPickerButton


func _ready() -> void:
	picker_btn.color_changed.connect(_on_picker_color_changed)

func _on_picker_color_changed(new_color: Color) -> void:
	emit_changed(_editing_property, new_color)

func _update_property() -> void:
	picker_btn.set_pick_color(_editing_object.get_property(_editing_property))


func _parse_settings(settings: Dictionary) -> void:
	picker_btn.edit_alpha = !settings.get("no_alpha", false)

