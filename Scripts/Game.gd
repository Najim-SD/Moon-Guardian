extends Node2D

export var maxWaves = 10
var currentWave = 0

var spaceshipScene = preload("res://Scenes/Spaceship.tscn")
var enemies = []

func _ready():
	startWave()
	pass

func _process(delta):
	var done = true
	for e in enemies:
		if e != null:
			done = false
			break
	if done:
		startWave()
	pass

func startWave():
	enemies.clear()
	currentWave += 1
	for i in range(currentWave):
		var eShip = spaceshipScene.instance()
		eShip.global_position.x = randi() % 50 - 24 + $spawn.position.x
		eShip.global_position.y = randi() % 50 - 24 + $spawn.position.y
		call_deferred("add_child", eShip)
		eShip.playerId = i+1
		eShip.team = "enemy"
		eShip.playerName = "Alien"
		eShip.controlDevice = 3
		eShip.maxHealth = 50
		eShip.health = 50
		eShip.isBot = true
		var ls = ["Spaceship", "Moonship"]
		eShip.target = find_node(ls[randi()%2])
		eShip.chaseType = randi()%2 + 1
		enemies.append(eShip)
		pass
	pass
