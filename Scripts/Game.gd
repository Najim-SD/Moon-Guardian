extends Node2D

export var maxWaves = 10
var currentWave = 0
var fadeMax:float = 60 * 5
var fadeCounter:float = fadeMax

var spaceshipScene = preload("res://Scenes/Spaceship.tscn")
var enemies = []

var ship = null
var moon = null

func _ready():
	startWave()
	ship = find_node("Spaceship")
	moon = find_node("Moonship")
	pass

func _process(delta):
	fadeCounter = max(fadeCounter -1, 0)
	$CanvasLayer/Label.modulate.a = fadeCounter/fadeMax
	if ship == null or moon == null:
		if ship != null and ship.health > 0: ship.kill()
		$CanvasLayer/Label.text = "You Survived " + str(currentWave) + " Waves!"
		$CanvasLayer/Label.modulate.a = 1
		$CanvasLayer/Label.visible = true
		$CanvasLayer/start.visible = true
		return
	var done = true
	for e in enemies:
		if e != null:
			done = false
			break
	if done:
		startWave()
	pass

func showMSG():
	$CanvasLayer/Label.visible = true
	$CanvasLayer/Label.text = "Wave : " + str(currentWave + 1)
	fadeCounter = fadeMax
	pass

func startWave():
	showMSG()
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
		eShip.maxSpeed = 250.0
		eShip.fireRate = 60 * 0.3
		eShip.isBot = true
		eShip.modulate.r = 0.90
		eShip.modulate.g = 1
		eShip.modulate.b = 0.85
		var ls = ["Spaceship", "Moonship"]
		eShip.target = find_node(ls[randi()%2])
		eShip.chaseType = randi()%2 + 1
		enemies.append(eShip)
		pass
	pass


func _on_start_button_up():
	get_tree().change_scene("res://Scenes/Game.tscn")
	pass # Replace with function body.
