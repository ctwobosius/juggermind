extends TextureRect




func _gui_input(event: InputEvent) -> void:
	
	if event is InputEventScreenDrag:
		position += event.screen_relative
		print( event.screen_relative)
