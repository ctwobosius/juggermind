class_name PlayerOptions
extends Panel

@onready var options: VBoxContainer = $Options

signal change_type

func _ready() -> void:
	for type in Player.TYPE_TO_TEXTURE:
		var button = Button.new()
		var type_name: StringName = (Player.Type.keys()[type]).capitalize()
		button.text = type_name
		button.name = type_name
		button.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		button.connect("pressed", select_type.bind(type))
		options.add_child(button)
	for child: Button in options.get_children():
		child.modulate.a = 0

func select_type(type: Player.Type) -> void:
	emit_signal("change_type", type)
	disappear()

func disappear() -> void:
	set_physics_process(false)
	var delay := 0.0
	for child: Button in options.get_children():
		var tween := create_tween()
		tween.tween_property(child, "modulate:a", 0, 0.25).set_delay(delay)
		tween.tween_callback(child.hide)
		delay += 0.03
	await get_tree().create_timer(delay * 2).timeout
	hide()

func appear() -> void:
	show()
	var delay := 0.0
	for child: Button in options.get_children():
		child.modulate.a = 0
		child.show()
		create_tween().tween_property(child, "modulate:a", 1, 0.125).set_delay(delay)
		delay += 0.03
	set_physics_process(true)

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("mouse"):
		disappear()
	elif Input.is_action_pressed("mouse"):
		global_position = get_global_mouse_position()
