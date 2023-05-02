extends TextureRect


var x = true
var mode = "dec"
# Called when the node enters the scene tree for the first time.
func _process(delta):
	if mode == "dec":
		rect_scale.y -= .001
	else:
		rect_scale.y += .001
	if rect_scale.y == 1:
		mode = "dec"
	elif stepify(rect_scale.y, 0.001) == -1:
		mode = "inc"
	#print(rect_scale.y)
