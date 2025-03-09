extends TextureRect

func _make_custom_tooltip(text: String) -> Control:
	var tooltip: Control = preload("res://scn/player_options.tscn").instantiate()
	return tooltip
