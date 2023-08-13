# Inspector.gd
extends MarginContainer

signal card_edited(object)

@onready var container : VBoxContainer = $Rows/Scroll/Container
@onready var scroll: ScrollContainer = $Rows/Scroll
@onready var empty: Label = $Rows/Empty

var editing : CardItem = null


func parse(object: CardItem) -> void:
	_clear()
	
	editing = object
	if object == null:
		scroll.visible = false
		empty.visible = true
	else:
		scroll.visible = true
		empty.visible = false
		
		var properties : Array[Dictionary] = object.get_properties()
		for p in properties:
			var property : StringName = p.property
			var type : int = p.type
			var settings : Dictionary = p.get("settings", {})
			
			var force_inspector_update = settings.get("force_inspector_update", false)
			
			var ui = _get_property_ui(type)
			
			if ui == null:
				continue
			
			ui._editing_property = property
			ui._editing_object = object
				
			container.add_child(ui)
			
			if settings.size() > 0:
				ui._parse_settings(settings)
			ui.update_property()
			ui.property_edited.connect(_on_property_edited.bind(force_inspector_update))
	
	card_edited.emit(editing)


func _get_property_ui(type : int) -> Control:
	match type:
		TYPE_FLOAT:
			return preload("res://Src/UI/Inspector/Properties/FloatProperty.tscn").instantiate()
		TYPE_INT:
			return preload("res://Src/UI/Inspector/Properties/IntProperty.tscn").instantiate()
		TYPE_COLOR:
			return preload("res://Src/UI/Inspector/Properties/ColorProperty.tscn").instantiate()
		TYPE_STRING:
			return preload("res://src/UI/Inspector/Properties/StringProperty.tscn").instantiate()
		TYPE_BOOL:
			return preload("res://src/UI/Inspector/Properties/BoolProperty.tscn").instantiate()
#		TYPE_VECTOR2:
#			return preload("res://Src/UI/Inspector/Properties/PropertyVector2.tscn").instantiate()
	return null


# (From Signal)
func _on_property_edited(property: StringName, value: Variant, field: StringName, changing: bool) -> void:
	editing.set_property(property, value)
	
	if changing:
		parse(editing)


func _clear() -> void:
	for i in container.get_children():
		i.queue_free()
