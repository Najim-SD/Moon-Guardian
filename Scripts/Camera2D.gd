extends Camera2D


export var targets = ["Player1"]


func _ready():
	
	pass # Replace with function body.


func _process(delta):
	var pos:Vector2 = get_parent().find_node(targets[0]).position
	var maxX = pos.x
	var minX = pos.x
	for t in targets:
		pos.x += get_parent().find_node(t).position.x
		pos.x /= 2
		pos.y += get_parent().find_node(t).position.y
		pos.y /= 2
		
		if get_parent().find_node(t).position.x > maxX : maxX = get_parent().find_node(t).position.x
		if get_parent().find_node(t).position.x < minX : minX = get_parent().find_node(t).position.x
	position = pos
	var pad = 500
	var wid = maxX - minX + pad
	if wid > 1280 * zoom.x or (wid < 1280 * zoom.x and wid > 1280):
		zoom.x = wid / 1280
		zoom.y = zoom.x
	pass









