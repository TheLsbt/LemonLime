class_name Card
extends PanelContainer

signal changed()

@onready var title_label: Label = $Margins/VBoxContainer/TitleLabel

var stack = null

var unique_name := "default_card"
var title := "":
	set = set_title

# Sets the display title for this card
func set_title(new_title: String) -> void:
	title = new_title
	title_label.text = title

func run(_image: Image):
	pass
