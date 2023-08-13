extends CardItem

var iterations := 0
var variable := ""


func _init() -> void:
	unique_name = "FixedLoop"
	title = "Fixed Loop"
	icon = preload("res://assets/Cards/FlowControl/For.png")
	can_indent = true

func _ready() -> void:
	tree_item.set_icon(0, icon)

func can_process_flow() -> bool:
	if variable.is_empty():
		add_error(
			"Enter a variable name."
		)
		return false
	if !root.variables.has(variable):
		add_error(
			"The variable '" + variable + "' already exists please select a new variable name."
		)
		return false
	if iterations == 0:
		add_warning(
			"The iterations must be greater than zero else the Fized Loop acts as a conditional."
		)
	return true

func should_override_stack() -> bool:
	return true

func process_cards(cards: Array, mode:= Stack.PROCESS_MODE.FULL) -> void:
	if indented.size() < 1:
		return
	for i in iterations:
		if root.variables.has(variable):
			root.variables[variable] = i
			root.process_cards(cards, mode)

func _pre_process() -> void:
	if !variable.is_empty():
		root.variables[variable] = 0

func finalize() -> void:
	root.variables.erase(variable)
	
func _str_validator(string: String) -> bool:
	if string.contains(" "):
		return false
	if string.contains("."):
		return false
	return true

func get_properties() -> Array[Dictionary]:
	return [
	{
		"property": "variable",
		"type": TYPE_STRING,
		"settings": {
			"placehold": "i",
			"validator": _str_validator
	}},
	{
		"property": "iterations",
		"type": TYPE_INT,
		"settings": {
			"min": 0,
			"step": 1,
			"allow_greater": true,
		}
	}
	]

