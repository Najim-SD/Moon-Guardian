extends RigidBody2D

export var team = "player"
export var health:float = 100
export var maxHealth:float = 100

var cam = null
var ship = null

func _ready():
	cam = get_parent().find_node("MultiCam")
	ship = get_parent().find_node("Spaceship")
	pass

func _physics_process(delta):
	
	pass




