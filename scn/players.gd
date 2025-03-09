extends Node2D
@onready var options: PlayerOptions = $Options

var undo_positions := PackedVector2Array()
var undo_players := []
var redo_players := []
var redo_positions := PackedVector2Array()

var last_undone_player : Player
var last_undone_pos : Vector2

var selected_player: Player

signal no_undo_left
signal no_redo_left
signal undo_valid
signal redo_valid

func add_player(player: Player) -> void:
	player.connect("grabbed", record_prev_position.bind(player))
	player.connect("held", open_change_type.bind(player))
	player.record_initial_position()
	add_child(player)

func record_prev_position(player: Player) -> void:
	undo_positions.append(player.global_position)
	undo_players.append(player)
	clear_redos()

func clear_redos() -> void:
	redo_positions.clear()
	redo_players.clear()

func clear_undos() -> void:
	undo_positions.clear()
	undo_players.clear()

func undo_or_redo_from_array(players: Array, player_positions: PackedVector2Array) -> bool:
	var prev_pos_idx := player_positions.size() - 1
	if prev_pos_idx < 0:
		return false
	var prev_pos := player_positions[prev_pos_idx]
	var prev_player : Player = players.pop_back()
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
	for maybe_player: Node in get_children():
		if maybe_player is Player:
			maybe_player.reset_to_initial_position()
	clear_redos()
	clear_undos()


func _on_options_change_type(type: Player.Type) -> void:
	if is_instance_valid(selected_player):
		selected_player.change_type(type)

func open_change_type(player: Player):
	selected_player = player
	options.global_position = get_global_mouse_position()
	options.appear()
