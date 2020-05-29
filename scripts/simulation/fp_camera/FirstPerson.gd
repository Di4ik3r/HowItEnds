extends KinematicBody



var speed = 12
var acceleration = 20
var gravity = 0.09
var jump = 10


var mouse_sensitivity = 0.06


var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 


onready var head = $Head


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) 
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) 
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))


func _physics_process(delta):
	direction = Vector3()

	move_and_slide(fall, Vector3.UP)

	if Input.is_action_pressed("move_forward"):
		direction -= transform.basis.z			
	elif Input.is_action_pressed("move_backward"):
		direction += transform.basis.z

	if Input.is_action_pressed("move_left"):
		direction -= transform.basis.x			
	elif Input.is_action_pressed("move_right"):
		direction += transform.basis.x
			
	if Input.is_action_pressed("jump"):
		direction += transform.basis.y			
	elif Input.is_action_pressed("glide"):
		direction -= transform.basis.y

	direction = direction.normalized()

	velocity = velocity.linear_interpolate(direction * speed, acceleration * delta) 

	velocity = move_and_slide(velocity, Vector3.UP)
