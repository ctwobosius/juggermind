extends Node2D

var prev_positions := PackedVector2Array()
var prev_players := []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child: DraggableSprite2D in get_children():
		child.connect("grabbed", record_prev_position.bind(child))

func record_prev_position(child: DraggableSprite2D) -> void:
	prev_positions.append(child.position)
	prev_players.append(child)



func _on_undo_pressed() -> void:
	var prev_pos_idx := prev_positions.size() - 1
	if prev_pos_idx < 0:
		return
	var prev_pos := prev_positions[prev_pos_idx]
	var prev_player : DraggableSprite2D = prev_players.pop_back()
	prev_positions.remove_at(prev_pos_idx)
	var tween := create_tween()
	tween.tween_property(prev_player, "position", prev_pos, 0.375).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
