extends Area2D

var ownerId = 0
var launched = false

func _ready():
	ownerId = get_parent().playerId
	pass


func _on_Missile_body_entered(body):
	print("Missile entered " + body.name)
	if launched:
		pass
	elif "Laser" in body.name:
		get_parent().takeDamage(5)
		print("Damage from Missile")
	pass
