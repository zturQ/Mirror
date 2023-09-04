extends Area2D


@onready var sprite := $Sprite as Sprite2D

var global = preload("res://scripts/global.gd")
var projectile = preload("res://prefabs/projectile.tscn")

var cooldown = false

func _ready():
	pass

func _process(delta):
	if Global.perspectivebool == false:
		sprite.visible = true
		var mousepos = Vector2(get_global_mouse_position() - global_position).normalized()
		self.rotation = mousepos.angle()
		if Input.is_action_just_pressed("change"):
			call_projectile()
	else:
		sprite.visible = false
	
func call_projectile():
	var instprojectile = projectile.instantiate()
	get_tree().current_scene.add_child(instprojectile)
	instprojectile.global_position = self.global_position
	
	var projectile_rotation = Vector2(get_global_mouse_position() - global_position).angle()
	instprojectile.rotation = projectile_rotation
	await get_tree().create_timer(0.3).timeout
	cooldown = false
