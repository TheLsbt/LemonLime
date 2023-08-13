class_name CardItem
extends RefCounted

signal edited()
signal errors_changed()
signal warnings_changed()
signal icon_changed()
signal title_changed()

var root = null
var parent = null

var unique_name : StringName = ""
var title : String = "":
	set(new_title):
		title = new_title
		title_changed.emit()

var icon : Texture2D = null:
	set(new_icon):
		icon = new_icon
		icon_changed.emit()

var errors : PackedStringArray = []
var warnings : PackedStringArray = []

var skip := false
var indent := 0
var can_indent := false
var indented : Array[CardItem]
var tree_item : TreeItem = null


func _ready() -> void:
	pass

func add_card(card: CardItem) -> void:
	indented.append(card)

func pre_process() -> void:
	_pre_process()

# Override
func _pre_process() -> void:
	pass


func pre_ui_process() -> void:
	while tree_item.get_button_count(0) > 0:
		tree_item.erase_button(0, 0)
#
#	for b in tree_item.get_button_count(0):
	
	errors.clear()
	errors_changed.emit()
	warnings.clear()
	warnings_changed.emit()
	_pre_ui_process()


func _pre_ui_process() -> void:
	pass


func post_ui_process() -> void:
	if tree_item:
		root.create_buttons(self)
		
	_post_ui_process()

func _post_ui_process() -> void:
	pass


func data_process(input: Image) -> Image:
	return _data_process(input)

# Override
func _data_process(input: Image) -> Image:
	return input

func process() -> void:
	_process()

# Override
func _process() -> void:
	pass

func post_process() -> void:
	_post_process()

# Override
func _post_process() -> void:
	pass

# Override
func can_process_flow() -> bool:
	return true

## If this function returns true the stack calls process_cards on this CardItem
func should_override_stack() -> bool:
	return false

## Override this method to process all the cards locally
func process_cards(_cards: Array, mode:= Stack.PROCESS_MODE.FULL) -> void:
	pass


func toggle_skip(toggled: bool) -> void:
	skip = toggled


# Override
func finalize() -> void:
	pass

func add_error(string: String) -> void:
	errors.append(string)
	errors_changed.emit()

func add_warning(string: String) -> void:
	warnings.append(string)
	warnings_changed.emit()

func get_properties() -> Array[Dictionary]:
	return []

func get_property(property: StringName) -> Variant:
	return get(property)

func set_property(property: StringName, value: Variant) -> void:
	set(property, value)
	edited.emit()
