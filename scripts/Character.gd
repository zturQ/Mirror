extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const DASH_SPEED = 1000

@onready var animation = $Animation
@onready var tile_map = $"../TileMap"
@onready var scene = get_tree().get_current_scene().name
 
var cooldown = false
#global.perspectivebool: true = plataformer, false = topdown.

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	pass

func _physics_process(delta):
	
	if "lol" in scene:
		Global.perspectivebool = true
	else:
		Global.perspectivebool = false
	
	if Global.perspectivebool:
		plataformer(delta)
	else: 
		top_down(delta)
	
	
func top_down(delta):
	var direction = Vector2()
	direction.x = int(Input.get_axis("ui_left", "ui_right"))
	direction.y = int(Input.get_axis("ui_up", "ui_down"))
	
	if direction.y or direction.x:
		animation.play("default")
	else:
		animation.play("idle")
	
	if direction.x == 1:
		animation.flip_h = false
	elif direction.x == -1 :
		animation.flip_h = true
	
	move_and_collide(direction * SPEED * delta)
	
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
		
	if direction == 1:
		animation.flip_h = false
	elif direction == -1 :
		animation.flip_h = true
		
	if Input.is_action_just_pressed("change") and cooldown:
		dash(Vector2(direction, 0))
		cooldown = false
		
	move_and_slide()
	
func dash(direction: Vector2):
	var dash_velocity = direction.normalized() * DASH_SPEED
	move_and_collide(dash_velocity * get_physics_process_delta_time())
	
	await get_tree().create_timer(0.4).timeout
	cooldown = true
	
