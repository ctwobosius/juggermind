extends TextureRect

const FIELD_RECTANGLE = preload("res://img/field-rectangle.svg")
const FIELD_OCTAGON = preload("res://img/field-octagon.svg")
var is_rectangle_field := true

func toggle_field() -> void:
	is_rectangle_field = !is_rectangle_field
	if is_rectangle_field:
		texture = FIELD_RECTANGLE
	else:
		texture = FIELD_OCTAGON
