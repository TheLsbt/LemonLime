class_name Stack
extends MarginContainer

@onready var cards_container : VBoxContainer = $Container/ScrollContainer/CardsContainer


# TODO : Merge layers
# FromLayer onto ToLayer 

var field = {
		"layer": 0,
		"layers": {},
	}

func _ready() -> void:
	pass

func _on_add_card_btn_pressed() -> void:
	Global.control.dialogs.open_dialog("CardsPicker", true)


func add_card(card: Card) -> void:
	var selected : Card = Global.selected_card
	
	card.stack = self
	
	# If selected add the card under that one
	if selected:
		cards_container.add_child(card)
		cards_container.move_child(card, selected.get_index() + 1)
	else:
		cards_container.add_child(card)
	
	card.changed.connect(_on_card_changed)
	
	process_stack()


func process_stack() -> void:
#	_reset_data()
	# Create layer image resources
	field["layers"].clear()
	for i in Global.project.layers:
		create_layer(i)
	
	var start = Time.get_ticks_msec()
	
	for card in cards_container.get_children():
		if field["layers"].size() < 1:
			printerr("Cannot being rendering because no layers exist.")
			continue
		card.run(field.layers.values()[field.layer])
	
	Global.render_vp.call_deferred("update")
	
	print("Rendering Took ", str(Time.get_ticks_msec() - start), " milliseconds.")


func has_layer(layer_name: String) -> bool:
	return field["layers"].keys().has(layer_name)

func create_layer(layer_name: String) -> void:
	# Passing a name that already exists allows you to override the value
	# Use has_layer to check if the layer exists
	var size = Global.project.size
	field["layers"][layer_name] = Image.create(size.x, size.y, false, Image.FORMAT_RGBA8)


func _on_card_changed() -> void:
	process_stack()

