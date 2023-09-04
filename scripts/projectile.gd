extends Area2D

@export var speed = 500

func _process(delta):
	var direction = Vector2.RIGHT.rotated(rotation)
	global_position += speed * direction * delta

func destroy():
	queue_free()
	
func _on_body_entered(body):
	destroy()
