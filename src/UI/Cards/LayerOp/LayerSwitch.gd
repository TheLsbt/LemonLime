extends Card

@onready var layers_option_btn: OptionButton = $Margins/VBoxContainer/LayersOptionBtn

var to = 0

func _init() -> void:
	unique_name = "LayerSwitch"

func _ready() -> void:
	set_title(unique_name.capitalize())
	set_available_layers_list()
	
	layers_option_btn.get_popup().about_to_popup.connect(_on_layer_option_btn_about_to_popup)

func set_available_layers_list():
	layers_option_btn.clear()
	for i in stack.field.layers.keys():
		layers_option_btn.add_item(i)

func _on_layer_option_btn_about_to_popup() -> void:
	set_available_layers_list()
	layers_option_btn.select(to)


func layers_option_btn_item_selected(idx: int) -> void:
	to = idx
	changed.emit()


func run(image: Image):
	stack.field.layer = to
