extends CharacterBody2D



const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 500

@onready var animation = $Animation
@onready var tile_map = $"../TileMap"

var perspectivebool = true #true = plataformer, false = topdown.

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta):
	
	if perspectivebool:
		plataformer(delta)
	else: 
		top_down(delta)
		
	if Input.is_action_just_pressed("change"):
		perspectivebool = not perspectivebool
	
	
func top_down(delta):
	var direction = Vector2()
	direction.x = int(Input.get_axis("ui_left", "ui_right"))
	direction.y = int(Input.get_axis("ui_up", "ui_down"))
	
	print(direction)
	
	position += direction * SPEED * delta
	
	if direction:
		animation.play("default")
	else:
		animation.play("idle")
	
	
func plataformer(delta):
		# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.play("default")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")

	move_and_slide()
	
func dash(direction: Vector2):
	var dash_velocity = direction.normalized() * DASH_SPEED
