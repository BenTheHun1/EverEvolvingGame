extends Node2D

var pts = 0
var stage = 0
var debug = false
var green = 0

var xp = 0
var lvl = 1

var delete_stage = 0
onready var logg = get_node("HUD/log/log_output")

var total_robos = 0
var total_friends = 0

const HELPER_PRICE_MULTIPLIER = 1.1
const EXPAND_SPEED = 40

const starting_price_robos = 100
var current_price_robos = starting_price_robos
const starting_price_friends = 300
var current_price_friends = starting_price_friends

var gsec_robos = 0
var gsec_friends = 0
var gsec = 0

var clicks = 1

var arrow = load("res://graphic/system/cur2.png")
var arrow_double = load("res://graphic/system/cur2-double.png")
var sm_arrow = load("res://graphic/system/cur.png")
var sm_arrow_double = load("res://graphic/system/cur-double.png")
var used_arrow = arrow
var used_arrow_double = arrow_double

var tama_state = "egg"
var tama_egg_move_step = "up"

var moving = false
var typing = false
var cur_btn = 1
const MAX_BTN = 2
var cur_tab = null

# Called when the node enters the scene tree for the first time.
func _ready():
	load_cursor()
	$HUD/upgrade.visible = false
	$click.visible = false
	$HUD/total_pts.visible = false
	$HUD/log.visible = false
	$HUD/upgrade_bg.visible = false
	$HUD/up_cost.visible = false
	$HUD/log/text_input.visible = false
	$pause/pause.visible = false
	$pause/pause/Overlay/Options.visible = false
	$HUD/shop.visible = false
	$HUD/tama.visible = false
	$HUD/skill.visible = false
	$HUD/exp.visible = false
	$HUD/left.visible = false
	$HUD/right.visible = false
	$HUD/wallet.visible = false
	$HUD/wallet/red_pts.add_color_override("font_color", Color("#ff0000"))
	$HUD/wallet/green_pts.add_color_override("font_color", Color("#11a500")) 
	#$pause/pause/Overlay/Options/full_toggle.pressed = OS.window_fullscreen
	_on_load_button_up()

func load_cursor():
	if stage >= 5:
		Input.set_custom_mouse_cursor(used_arrow_double)
	else:
		Input.set_custom_mouse_cursor(used_arrow)

func _process(_delta):
	$HUD/wallet/red_pts.text = String(stepify(pts, 1))
	$HUD/wallet/green_pts.text = String(stepify(green, 1))
	$HUD/debug.visible = debug
	$HUD/upgrade_bg/helper_1/total.text = "Total: " + String(total_robos)
	$HUD/upgrade_bg/helper_2/total2.text = "Total: " + String(total_friends)
	$HUD/upgrade_bg/helper_1/price.text = "Price: " + String(current_price_robos)
	$HUD/upgrade_bg/helper_2/price2.text = "Price: " + String(current_price_friends)
	$HUD/upgrade_bg/helper_1/gsec.text = "G/sec: " + String(gsec_robos)
	$HUD/upgrade_bg/helper_2/gsec2.text = "G/sec: " + String(gsec_friends)
	
#	if tama_state == "egg":
#		if stepify($HUD/tama.offset.y, 1) == -5:
#			tama_egg_move_step = "down"
#		elif stepify($HUD/tama.offset.y, 1) == 0:
#			tama_egg_move_step = "up"
#		if tama_egg_move_step == "up":
#			$HUD/tama.offset.y -= 0.1
#		else:
#			$HUD/tama.offset.y += 0.1
		
	
	$HUD/exp.value = xp
	$HUD/exp/xp.text = String(stepify(xp, 1))
	$HUD/exp/lvl.text = String(lvl)
	
	if xp >= $HUD/exp.max_value:
		lvl += 1
		xp -= $HUD/exp.max_value
		$HUD/exp.max_value = stepify($HUD/exp.max_value * HELPER_PRICE_MULTIPLIER, 1)
	
	if cur_btn == 1:
		pts += stepify(float(gsec) / 60, 0.01)
		$HUD/total_pts.text = String(stepify(pts, 1))
		$HUD/total_pts.add_color_override("font_color", Color("#ff0000"))
	elif cur_btn == 2:
		green += stepify(float(gsec) / 60, 0.01)
		$HUD/total_pts.text = String(stepify(green, 1))
		$HUD/total_pts.add_color_override("font_color", Color("#11a500"))
	check_upgrade()

func check_upgrade():
	if stage == 0:
		$HUD/upgrade.visible = true
	elif pts >= 10 and stage == 1:
		$HUD/upgrade.visible = true
		$HUD/up_cost.visible = true
	elif pts >= 25 and stage == 2:
		$HUD/upgrade.visible = true
		$HUD/up_cost.visible = true
		$HUD/up_cost.text = "Cost: 25"
	elif pts >= 100 and stage == 3:
		$HUD/upgrade.visible = true
		$HUD/up_cost.visible = true
		$HUD/up_cost.text = "Cost: 100"
	elif pts >= 100 and stage == 4:
		$HUD/upgrade.visible = true
		$HUD/up_cost.visible = true
		$HUD/up_cost.text = "Cost: 100"
	elif pts >= 500 and stage == 5:
		$HUD/upgrade.visible = true
		$HUD/up_cost.visible = true
		$HUD/up_cost.text = "Cost: 500"
	elif pts >= 500 and stage == 6:
		$HUD/upgrade.visible = true
		$HUD/up_cost.visible = true
		$HUD/up_cost.text = "Cost: 500"
	elif pts >= 1000 and stage == 7:
		$HUD/upgrade.visible = true
		$HUD/up_cost.visible = true
		$HUD/up_cost.text = "Cost: 1000"
	elif pts >= 2000 and stage == 8:
		$HUD/upgrade.visible = true
		$HUD/up_cost.visible = true
		$HUD/up_cost.text = "Cost: 2000"
	else:
		$HUD/upgrade.visible = false
		$HUD/up_cost.visible = false

func upgrade():
	if stage == 1:
		$click.visible = true
		output("[UPGRADE] Unlocked BUTTON feature. Click the BUTTON to increase your G.\n")
	if stage == 2:
		$HUD/total_pts.visible = true
		output("[UPGRADE] Unlocked DISPLAY feature. Current G value will be displayed above the BUTTON.\n")
	if stage == 3:
		$HUD/log.visible = true
		_on_expand_button_up("log")
		output("[UPGRADE] Unlocked LOG feature. Important messages will be displayed here.\n")
	if stage == 4:
		$HUD/upgrade_bg.visible = true
		_on_expand_button_up("helpers")
		output("[UPGRADE] Unlocked HELPERS feature. Pay HELPERS G to have them press the BUTTON, increasing your G automagically.\n")
	if stage == 5:
		load_cursor()
		clicks += 1
		output("[UPGRADE] Unlocked DOUBLE CURSOR feature. Now each click counts as two clicks.\n")
	if stage == 6:
		$HUD/log/text_input.visible = true
		output("[UPGRADE] Unlocked ADVENTURE feature. Type commands below to perform actions.\n")
	if stage == 7:
		$HUD/tama.visible = true
		$HUD/shop.visible = true
		output("[UPGRADE] Unlocked PET and SHOP features. Take care of its needs, and a reward may be in your future.\n")
	if stage == 8:
		$HUD/exp.visible = true
		$HUD/skill.visible = true
		output("[UPGRADE] Unlocked EXP and SKILL features. Various actions will cause you to gain EXP, which you can spend to upgrade SKILLs.")
	if stage == 9:
		$HUD/right.visible = true
		$HUD/wallet.visible = true
		$HUD/total_pts.add_color_override("font_color", Color("#ff0000")) #11a500
		output("[UPGRADE] Unlocked GREEN BUTTON and WALLET features. Clicking on the green one will increase your Green G. Use the Arrow buttons to swap your red BUTTON out.")

func _on_upgrade_button_up():
	$HUD/upgrade_bg/boop.play()
	if stage == 0:
		stage = 1
	elif stage == 1:
		pts -= 10
		stage = 2
	elif stage == 2:
		pts -= 25
		stage = 3
	elif stage == 3:
		pts -= 100
		stage = 4
	elif stage == 4:
		pts -= 100
		stage = 5
	elif stage == 5:
		pts -= 500
		stage = 6
	elif stage == 6:
		pts -= 500
		stage = 7
	elif stage == 7:
		pts -= 1000
		stage = 8
	elif stage == 8:
		pts -= 2000
		stage = 9
	$HUD/upgrade.visible = false
	upgrade()

func _on_click_button_up(color):
	$blip.play()
	if color == "red":
		pts += clicks
	elif color == "green":
		green += clicks
	if stage >= 8:
		xp += clicks

func _on_close_button_up():
	$HUD/upgrade_bg/boop.play()
	get_tree().quit()

func _on_debug_button_up():
	$HUD/upgrade_bg/boop.play()
	pts += 10000

func _on_save_button_up():
	$HUD/upgrade_bg/boop.play()
	var save_game = File.new()
	save_game.open("user://savegame.save", File.WRITE)
	save_game.store_line(String(stage))
	save_game.store_line(String(pts))
	save_game.store_line(String(total_robos))
	save_game.store_line(String(total_friends))
	save_game.store_line(String($pause/pause/Overlay/Options/full_toggle.pressed))
	save_game.store_line(String($pause/pause/Overlay/Options/sm_cur_toggle.pressed))
	save_game.store_line(String(xp))
	save_game.store_line(String(lvl))
	save_game.store_line(String($HUD/exp.max_value))
	save_game.store_line(String(green))
	save_game.close()

func _on_load_button_up():
	#$HUD/upgrade_bg/boop.play()
	var save_game = File.new()
	if not save_game.file_exists("user://savegame.save"):
		print("No save file found")
		return
	print("Loading save file")
	save_game.open("user://savegame.save", File.READ)
	stage = int(save_game.get_line())
	
	if stage >= 1:
		$click.visible = true
	if stage >= 2:
		$HUD/total_pts.visible = true
	if stage >= 3:
		$HUD/log.visible = true
	if stage >= 4:
		$HUD/upgrade_bg.visible = true
	if stage >= 5:
		load_cursor()
		clicks = 2
	if stage >= 6:
		$HUD/log/text_input.visible = true
	if stage >= 7:
		$HUD/tama.visible = true
		$HUD/shop.visible = true
	if stage >= 8:
		$HUD/exp.visible = true
		$HUD/skill.visible = true
	if stage >= 9:
		$HUD/right.visible = true
		$HUD/wallet.visible = true
		$HUD/total_pts.add_color_override("font_color", Color("#ff0000")) #11a500
	
	
	pts = int(save_game.get_line())
	total_robos = int(save_game.get_line())
	total_friends = int(save_game.get_line())
	
	if save_game.get_line() == "True":
		$pause/pause/Overlay/Options/full_toggle.pressed = true
	else:
		$pause/pause/Overlay/Options/full_toggle.pressed = false
	
	if save_game.get_line() == "True":
		$pause/pause/Overlay/Options/sm_cur_toggle.pressed = true
	else:
		$pause/pause/Overlay/Options/sm_cur_toggle.pressed = false
	
	xp = int(save_game.get_line())
	lvl = int(save_game.get_line())
	$HUD/exp.max_value = int(save_game.get_line())
	green = int(save_game.get_line())
	
	save_game.close()
	
	gsec_robos = total_robos
	var temp = total_robos
	while temp != 0:
		current_price_robos = stepify(current_price_robos * HELPER_PRICE_MULTIPLIER, 1)
		temp -= 1
	
	gsec_friends = total_friends * 5
	temp = total_friends
	while temp != 0:
		current_price_friends = stepify(current_price_friends * HELPER_PRICE_MULTIPLIER, 1)
		temp -= 1
	
	gsec = gsec_friends + gsec_robos


func _on_del_save_button_up():
	$HUD/upgrade_bg/boop.play()
	delete_stage += 1
	if delete_stage < 5:
		$pause/pause/Overlay/Options/del_save.text = "Click " + String(5 - delete_stage) + " Times"
	else:
		delete_stage = 0
		$pause/pause/Overlay/Options/del_save.text = "Delete Save"
		var dir = Directory.new()
		dir.remove("user://savegame.save")
		get_tree().reload_current_scene()

func _on_pay_button_up():
	$HUD/upgrade_bg/boop.play()
	if pts >= current_price_robos:
		pts -= current_price_robos
		total_robos += 1
		current_price_robos = stepify(current_price_robos * HELPER_PRICE_MULTIPLIER, 1)
		gsec_robos += 1
		gsec += 1

func _on_sack_button_up():
	$HUD/upgrade_bg/boop.play()
	if total_robos > 0:
		current_price_robos = stepify(current_price_robos / HELPER_PRICE_MULTIPLIER, 1)
		pts += current_price_robos
		total_robos -= 1
		gsec_robos -= 1
		gsec -= 1

func _on_pay2_button_up():
	$HUD/upgrade_bg/boop.play()
	if pts >= current_price_friends:
		pts -= current_price_friends
		total_friends += 1
		current_price_friends = stepify(current_price_friends * HELPER_PRICE_MULTIPLIER, 1)
		gsec_friends += 5
		gsec += 5

func _on_sack2_button_up():
	$HUD/upgrade_bg/boop.play()
	if total_friends > 0:
		current_price_friends = stepify(current_price_friends / HELPER_PRICE_MULTIPLIER, 1)
		pts += current_price_friends
		total_friends -= 1
		gsec_friends -= 5
		gsec -= 5

func _on_pause_button_up():
	$HUD/upgrade_bg/boop.play()
	$pause/pause.visible = true

func _on_resume_button_up():
	$HUD/upgrade_bg/boop.play()
	$pause/pause.visible = false
	$pause/pause/Overlay/BG/stuckpet.text = "Help! My Pet is Stuck!"


func _on_sm_cur_toggle_toggled(button_pressed):
	if button_pressed == true:
		used_arrow = sm_arrow
		used_arrow_double = sm_arrow_double
	else:
		used_arrow = arrow
		used_arrow_double = arrow_double
	load_cursor()

func _on_debug_toggle_toggled(button_pressed):
	debug = !debug

func _on_full_toggle_toggled(_button_pressed):
	OS.window_fullscreen = !OS.window_fullscreen
	#OS.window_borderless = !OS.window_borderless


func _on_expand_button_up(btn):
	$HUD/upgrade_bg/boop.play()
	var boon
	if btn == "helpers":
		boon = get_node("HUD/upgrade_bg")
	elif btn == "shop":
		boon = get_node("HUD/shop")
	elif btn == "log":
		boon = get_node("HUD/log")
	elif btn == "skill":
		boon = get_node("HUD/skill")
	elif btn == "wallet":
		boon = get_node("HUD/wallet")
	boon.get_node("expand").disabled = true
	if cur_tab == boon:
		tabchange(getside(boon), boon)
		cur_tab = null
	elif cur_tab == null:
		cur_tab = boon
		tabchange(getside(boon), boon)
	else:
		tabchange(getside(cur_tab), cur_tab)
		cur_tab = boon
		tabchange(getside(boon), boon)

func getside(tab):
	var side
	if tab == get_node("HUD/upgrade_bg") or tab == get_node("HUD/shop") or tab == get_node("HUD/wallet"):
		side = "l"
	else:
		side = "r"
	return side

func tabchange(side, boon):
	if side == "l":
		if boon.rect_position.x == 40:
			for _i in range(440 / EXPAND_SPEED):
				boon.rect_position.x -= EXPAND_SPEED
				for _x in range(1):
					yield(get_tree(), "idle_frame")
		else:
			for _i in range(440 / EXPAND_SPEED):
				boon.rect_position.x += EXPAND_SPEED
				for _x in range(1):
					yield(get_tree(), "idle_frame")
	elif side == "r":
		if boon.rect_position.x == 1600:
			for _i in range(440 / EXPAND_SPEED):
				boon.rect_position.x -= EXPAND_SPEED
				for _x in range(1):
					yield(get_tree(), "idle_frame")
		else:
			for _i in range(440 / EXPAND_SPEED):
				boon.rect_position.x += EXPAND_SPEED
				for _x in range(1):
					yield(get_tree(), "idle_frame")
	boon.get_node("expand").disabled = false


func output(out):
	logg.text += out
	var cl = logg.get_line_count()
	logg.cursor_set_line(cl)

func _on_back_button_up():
	$HUD/upgrade_bg/boop.play()
	$pause/pause/Overlay/Options.visible = false

func _on_options_button_up():
	$HUD/upgrade_bg/boop.play()
	$pause/pause/Overlay/Options.visible = true

func _input(e):
	if Input.is_action_just_pressed("ui_left") and moving == false and typing == false:
		pan("l")
	elif Input.is_action_just_pressed("ui_right") and moving == false and typing == false:
		pan("r")

func pan(dir):
	var proceed = false
	var mod_speed = EXPAND_SPEED * 2
	moving = true
	$HUD/upgrade_bg/boop.play()
	if dir == "r" and cur_btn < MAX_BTN:
		cur_btn += 1
		proceed = true
	elif dir == "l" and cur_btn > 1:
		cur_btn -= 1
		proceed = true
	if proceed == true:
		for i in range(1600 / mod_speed):
			if dir == "r":
				$Camera2D.position.x += mod_speed
				$HUD/right.visible = false
				$HUD/left.visible = true
			elif dir == "l":
				$Camera2D.position.x -= mod_speed
				$HUD/right.visible = true
				$HUD/left.visible = false
			for _x in range(1):
						yield(get_tree(), "idle_frame")
	moving = false


func _on_tama_mouse_exited():
	load_cursor()


func _on_stuckpet_button_up():
	$pause/pause/Overlay/BG/stuckpet.text = "Teleported Away"
	$HUD/tama.position = Vector2(64, 832)


func _on_text_input_focus_entered():
	typing = true


func _on_text_input_focus_exited():
	typing = false
