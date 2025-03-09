extends Node2D

var undo_positions := PackedVector2Array()
var undo_players := []
var initial_positions := PackedVector2Array()
var redo_players := []
var redo_positions := PackedVector2Array()

var last_undone_player : DraggableSprite2D
var last_undone_pos : Vector2

signal no_undo_left
signal no_redo_left
signal undo_valid
signal redo_valid

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child: DraggableSprite2D in get_children():
		child.connect("grabbed", record_prev_position.bind(child))
		initial_positions.append(child.global_position)

func record_prev_position(child: DraggableSprite2D) -> void:
	undo_positions.append(child.global_position)
	undo_players.append(child)
	redo_positions.clear()

func undo_or_redo_from_array(players: Array, player_positions: PackedVector2Array) -> bool:
	var prev_pos_idx := player_positions.size() - 1
	if prev_pos_idx < 0:
		return false
	var prev_pos := player_positions[prev_pos_idx]
	var prev_player : DraggableSprite2D = players.pop_back()
	player_positions.remove_at(prev_pos_idx)
	last_undone_player = prev_player
	last_undone_pos = prev_player.global_position
	prev_player.move_back_to(prev_pos)
	return true

func _on_undo_pressed() -> void:
	if !undo_or_redo_from_array(undo_players, undo_positions):
		emit_signal("no_undo_left")
	else:
		redo_players.append(last_undone_player)
		redo_positions.append(last_undone_pos)

func _on_redo_pressed() -> void:
	if !undo_or_redo_from_array(redo_players, redo_positions):
		emit_signal("no_redo_left")
	else:
		undo_players.append(last_undone_player)
		undo_positions.append(last_undone_pos)



func _on_reset_pressed() -> void:
	pass # Replace with function body.
