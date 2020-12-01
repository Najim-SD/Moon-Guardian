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
		call_deferred("add_child", eShip)
		eShip.playerId = i+1
		eShip.team = "enemy"
		eShip.playerName = "Alien"
		eShip.controlDevice = 3
		enemies.append(eShip)
		pass
	pass
