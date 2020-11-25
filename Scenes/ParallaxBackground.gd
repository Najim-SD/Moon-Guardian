extends ParallaxBackground


func _ready():
	pass
	
func _process(delta):
	var scale = get_viewport().get_canvas_transform().get_scale()
	var rect = get_viewport_rect()
	var cam = get_node("/root/Stage/Character/Player/MainCamera")
	var transform = cam.get_camera_screen_center() + rect.size / scale / 2 - rect.size / 2
	
	for p_node in get_children():
		var transform_pos = -transform * (p_node.get_motion_scale() - Vector2(1, 1))
		p_node.set_pos(transform_pos)
