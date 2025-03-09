#@tool
class_name Player
extends DraggableSprite2D
var init_pos: Vector2
var prev_pos: Vector2
@onready var hold_timer: Timer = $HoldTimer

signal held

enum Type {QWIK, STAFF, QTIP, LONGSWORD, DUAL_SHORTS, SHIELD, CHAIN}
static var TYPE_TO_TEXTURE := {
	Type.QWIK : preload("res://img/tile_0099.png"),
	Type.STAFF : preload("res://img/tile_0096.png"),
	Type.QTIP : preload("res://img/tile_0097.png"),
	Type.LONGSWORD : preload("res://img/tile_0087.png"),
	Type.DUAL_SHORTS : preload("res://img/tile_0110.png"),
	Type.SHIELD : preload("res://img/tile_0111.png"),
	Type.CHAIN : preload("res://img/tile_0099.png"),
}

func move_back_to(pos: Vector2) -> void:
	var tween := create_tween()
	tween.tween_property(self, "global_position", pos, 0.375).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)

func record_initial_position() -> void:
	init_pos = global_position
func reset_to_initial_position() -> void:
	move_back_to(init_pos)

func change_type(type: Type):
	texture = TYPE_TO_TEXTURE[type]
	initial_scale = Vector2.ONE * 4
	scale = initial_scale
	$Light.texture_scale = 0.25


func _on_grabbed() -> void:
	hold_timer.start()
	prev_pos = position


func _on_hold_timer_timeout() -> void:
	if position.distance_squared_to(prev_pos) < 16:
		emit_signal("held")


func _on_released() -> void:
	hold_timer.stop()

func change_color(c: Color) -> void:
	$Light.color = c
	modulate = c * 1.25
