# Property.gd
extends VBoxContainer

"""
completed:
	float:
		min-, max-, step-, lesser-, greater-, exp-, suffix, prefix, disabled-
todo:
	bool:
		identifier, disabled
	int:
		min-, max-, step-, lesser-, greater-, exp-, suffix, prefix, disabled-, is_enum-, enums-
	string:
		placeholder-, is_enum, enums, disabled
	color:
		no_alpha-
	vector2:
		step
	vector2i:
		step
	

"""

signal property_edited(property, value, field, changing)

@onready var property_name_label: Label = $Title/PropertyName

var _editing_property : StringName
var _editing_object : CardItem


func emit_changed(
		property: StringName, value: Variant, field: StringName = &""
	) -> void:
	property_edited.emit(property, value, field)

## Called when the ui should be updated
func update_property() -> void:
	property_name_label.text = _editing_property.capitalize()
	_update_property()

# Virtual
func _update_property() -> void:
	pass

# Virtual
func _parse_setting(_settings: Dictionary) -> void:
	pass
