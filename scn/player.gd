class_name Player
extends DraggableSprite2D

func move_back_to(pos: Vector2) -> void:
	var tween := create_tween()
	tween.tween_property(self, "global_position", pos, 0.375).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

var init_pos: Vector2
func record_initial_position() -> void:
	init_pos = global_position
func reset_to_initial_position() -> void:
	move_back_to(init_pos)
