extends CardItem

var expression := ""

func _init() -> void:
	unique_name = "IfCondition"
	icon = preload("res://assets/BasicShape.png")
	can_indent = true

func _ready() -> void:
	tree_item.set_icon(0, icon)

func can_process_flow() -> bool:
	
	if expression.is_empty():
		add_warning("The Expression is empty please enter a expression")
		return false
		
	var input_names : PackedStringArray = []
	var inputs := []
	for i in root.variables.keys():
		input_names.append(i)
		inputs.append(root.variables[i])
		
	var e = Expression.new()
	var error = e.parse(expression, input_names)
	if error != OK:
		add_error("Expression Error: " + e.get_error_text())
		return false
	var result = e.execute(inputs, root)
	if not e.has_execute_failed():
		if typeof(result) == TYPE_BOOL:
			return bool(result)
		else:
			add_error("The expression does not end in a 'bool'. Try wrapping \
			your expression in 'bool()'.")
			
	else:
		add_error("Expression failed to execute.")

	return false




func get_properties() -> Array[Dictionary]:
	return [
	{
		"property": "expression",
		"type": TYPE_STRING,
		"settings": {
			"placehold": "1 + 1 = 3",
			"is_multiline": true,
			"parse_expressions": true,
	}},
	]

