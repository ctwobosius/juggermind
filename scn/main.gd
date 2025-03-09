extends Control

@onready var players: Node2D = $Players
@onready var player_spawn_bottom: HBoxContainer = $Layout/DiagramGUI/Diagram/PlayerSpawnBottom
@onready var player_spawn_top: HBoxContainer = $Layout/DiagramGUI/Diagram/PlayerSpawnTop
const PLAYER := preload("res://scn/player.tscn")

func _ready() -> void:
	await get_tree().process_frame
	spawn_players_in(player_spawn_bottom)
	spawn_players_in(player_spawn_top)

func spawn_players_in(container: HBoxContainer) -> void:
	for maybe_control: Control in container.get_children():
		if maybe_control is not VSeparator:
			var player := PLAYER.instantiate()
			player.change_color(container.modulate)
			player.global_position = maybe_control.global_position + maybe_control.size / 2
			players.add_player(player)
