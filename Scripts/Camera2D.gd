extends Camera2D


export var targets = ["Player1"]


func _ready():
	
	pass # Replace with function body.


func _process(delta):
	var pos:Vector2 = get_parent().find_node(targets[0]).position
	var maxX = pos.x
	var minX = pos.x
	var maxY = pos.y
	var minY = pos.y
	for t in targets:
		pos.x += get_parent().find_node(t).position.x
		pos.x /= 2
		pos.y += get_parent().find_node(t).position.y
		pos.y /= 2
		
		if get_parent().find_node(t).position.x > maxX : maxX = get_parent().find_node(t).position.x
		if get_parent().find_node(t).position.x < minX : minX = get_parent().find_node(t).position.x
		if get_parent().find_node(t).position.y > maxY : maxY = get_parent().find_node(t).position.y
		if get_parent().find_node(t).position.y < minY : minY = get_parent().find_node(t).position.y
	position = pos
	var hPad = 500
	var vPad = 300
	var wid = maxX - minX + hPad
	var height = maxY - minY + vPad
	var factor1 = zoom.x; var factor2 = zoom.y
	
	factor1 = wid / 1280
	factor2 = height / 720
	var f = max(factor1, factor2)
	if f < 1 : f = 1
	
	zoom.x = f
	zoom.y = f
	pass









