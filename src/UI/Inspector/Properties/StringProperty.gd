# ColorProperty.gd
extends "res://src/UI/Inspector/Properties/Property.gd"


@onready var line_edit: LineEdit = $Editors/Inputs/LineEdit
@onready var open_dialogue_btn: Button = $Editors/Inputs/OpenFileDialogue
@onready var multiline: TextEdit = $Editors/Inputs/Multiline
@onready var expression: Label = $Editors/Expression

var allow_file_picking := false
var filters := {}
var dialogue : FileDialog = null
var validator: Callable
var previous_text : String = ""
var is_multiline := false
var parse_expresions := false


func _ready() -> void:
	line_edit.text_submitted.connect(_on_line_edit_changed)
	multiline.text_changed.connect(_on_multiline_text_changed)
	open_dialogue_btn.button_down.connect(_on_open_dialogue_btn_down)

func _on_line_edit_changed(new_text: String) -> void:
	if validator.call(new_text):
		emit_changed(_editing_property, new_text)
		previous_text = new_text
	else:
		line_edit.text = previous_text
	
	if parse_expresions:
		begin_expression_parse()


func _on_multiline_text_changed() -> void:
	var text = multiline.text
	if validator.call(text):
		emit_changed(_editing_property, text)
		previous_text = text
	else:
		line_edit.text = previous_text
	
	if parse_expresions:
		begin_expression_parse()


func begin_expression_parse() -> void:
	var root = _editing_object.root
	
	var input_names : PackedStringArray = []
	var inputs := []
	for i in root.variables.keys():
		input_names.append(i)
		inputs.append(root.variables[i])
		
	var e = Expression.new()
	var error = e.parse(previous_text, input_names)
	if error != OK:
		expression.text = e.get_error_text()
		return
	else:
		var result = e.execute(inputs, root, true)
		expression.text = str(result)


func _on_open_dialogue_btn_down() -> void:
	dialogue = FileDialog.new()
	dialogue.show_hidden_files = true
	dialogue.access = FileDialog.ACCESS_FILESYSTEM
	dialogue.file_mode = FileDialog.FILE_MODE_OPEN_FILE
	dialogue.file_selected.connect(_on_dialogue_file_selected)
	for i in filters.keys():
		dialogue.add_filter(filters[i], i)
	add_child(dialogue)
	dialogue.popup_centered()

func _on_dialogue_file_selected(file: String) -> void:
	line_edit.set_text(file)
	multiline.set_text(file)
	previous_text = file
	emit_changed(_editing_property, file)
	dialogue.file_selected.disconnect(_on_dialogue_file_selected)
	dialogue.queue_free()
	dialogue = null
	

func _update_property() -> void:
	line_edit.set_text(_editing_object.get_property(_editing_property))
	multiline.set_text(_editing_object.get_property(_editing_property))
	previous_text = _editing_object.get_property(_editing_property)
	open_dialogue_btn.visible = allow_file_picking
	
	multiline.visible = is_multiline
	line_edit.visible = !is_multiline
	
	expression.visible = parse_expresions
	
	begin_expression_parse()
	

func _parse_settings(settings: Dictionary) -> void:
	line_edit.placeholder_text = settings.get("placeholder", "")
	allow_file_picking = settings.get("allow_file_picking", false)
	filters = settings.get("filters", {})
	validator = settings.get("validator", func(string: String): return true)
	is_multiline = settings.get("is_multiline", false)
	parse_expresions = settings.get("parse_expressions", false)
