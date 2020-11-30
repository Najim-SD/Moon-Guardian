extends AnimatedSprite

export var fades:bool = true
export var fade_time:float = 60
var fadeCounter:float = fade_time

export var moves:bool = true
export var move_dir:Vector2 = Vector2.UP.normalized()
export var move_dir_offset:float = 15
export var move_speed:float = 100

export var rotates:bool = true

var direction
var rot
var velocity

func _ready():
	rot = randi() % 360
	pass

func _physics_process(delta):
	
	
	if fades:
		fadeCounter -= 1
		modulate.a = fadeCounter/fade_time
		if fadeCounter <= 0:
			destroy()
	pass

func destroy():
	queue_free()
	pass


