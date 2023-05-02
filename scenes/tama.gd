extends KinematicBody2D

# Pickable needs to be selected from the inspector

var can_grab = false
var grabbed_offset = Vector2()
var tama_mode = false

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		can_grab = event.pressed
		grabbed_offset = position - get_global_mouse_position()

func _process(_delta):
	if Input.is_mouse_button_pressed(BUTTON_LEFT) and can_grab:
		position = get_global_mouse_position() + grabbed_offset
		Input.set_custom_mouse_cursor(load("graphic/tamagotchi/sprite_1.png"))
	elif tama_mode:
		Input.set_custom_mouse_cursor(load("graphic/tamagotchi/sprite_0.png"))


func _on_tama_mouse_entered():
	tama_mode = true
	


func _on_tama_mouse_exited():
	tama_mode = false
