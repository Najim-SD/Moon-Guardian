extends RigidBody2D

export var team = "player"
export var health:float = 1000
export var maxHealth:float = 1000

var cam = null
var ship = null

var hitSound = preload("res://Sounds/Hit.wav")
var laserSound = preload("res://Sounds/Laser_Shoot.wav")
var explosionSound = preload("res://Sounds/Explosion.wav")

func _ready():
	cam = get_parent().find_node("MultiCam")
	ship = get_parent().find_node("Spaceship")
	$UI/ProgressBar.min_value = 0
	$UI/ProgressBar.max_value = maxHealth
	$UI/ProgressBar.value = health
	pass

func _physics_process(delta):
	$UI/ProgressBar.value = health
	pass

func lockON(lock:bool):
	$UI/Lock.visible = lock
	pass


func takeDamage(dmg:int):
	if health <= 0: return
	health -= dmg
	cam.shakeCam(12, Vector2(-4,4))
	$AudioStreamPlayer2D.stream = hitSound
	$AudioStreamPlayer2D.volume_db = -20
	$AudioStreamPlayer2D.pitch_scale = rand_range(0.60,1)
	$AudioStreamPlayer2D.play()
	checkDeath()
	pass

func checkDeath():
	if health <= 0:
		for t in cam.targets:
			if t == name:
				cam.targets.erase(t)
				break
		kill()
	pass

func kill():
	cam.shakeCam(60, Vector2(-10,10))
	var audio = get_parent().find_node("LevelAudioPlayer")
	audio.stream = explosionSound
	audio.volume_db = -20
	audio.pitch_scale = rand_range(0.60,1)
	audio.play()
	cam.playFX("WhiteScreenFX")
	queue_free()
	pass


