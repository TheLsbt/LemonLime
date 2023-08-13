extends CardItem

const shader = preload("res://src/Shaders/Invert.gdshader")

var red:= false
var green:= false
var blue:= false
var alpha:= false

func _init() -> void:
	unique_name = "InvertShaderEffect"
	title = "Invert"
	icon = preload("res://assets/Cards/ShaderEffects/Outline.png")


func _ready() -> void:
	tree_item.set_icon(0, icon)


func _data_process(input: Image) -> Image:
	var shader_effect := ShaderEffect.new()
	shader_effect.generate(input, shader, {
		"red": red, "green": green, "blue": blue, "alpha": alpha
	}, Global.project.size)
	return input
	

func get_properties() -> Array[Dictionary]:
	return [
	{
	"property": "red",
	"type": TYPE_BOOL,
	"settings": {
		"text": "Invert Red Channel",
	}},
	{
	"property": "green",
	"type": TYPE_BOOL,
	"settings": {
		"text": "Invert Green Channel",
	}},
	{
	"property": "blue",
	"type": TYPE_BOOL,
	"settings": {
		"text": "Invert Blue Channel",
	}},
	{
	"property": "alpha",
	"type": TYPE_BOOL,
	"settings": {
		"text": "Invert Alpha Channel",
	}},
	]
