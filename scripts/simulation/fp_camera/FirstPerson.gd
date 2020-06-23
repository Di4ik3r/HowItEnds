extends KinematicBody


signal bot_raycasted(bot)

const RAY_LENGTH = 100

var speed = 12
var acceleration = 20
var gravity = 0.09
var jump = 10


var mouse_sensitivity = 0.06


var direction = Vector3()
var velocity = Vector3()
var fall = Vector3() 

var mouse_visible: bool = false
var follow_bot: Bot = null

onready var head = $Head
onready var camera = $Head/FpsGameCamera
onready var Ray = $Head/RayCast


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

	
func _input(event):
	if !follow_bot and event is InputEventMouseMotion and not mouse_visible:
		rotate_y(deg2rad(-event.relative.x * mouse_sensitivity)) 
		head.rotate_x(deg2rad(-event.relative.y * mouse_sensitivity)) 
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
#	if event is InputEventMouseButton:
	
	if Input.is_mouse_button_pressed(2):
		mouse_visible = !mouse_visible
		match mouse_visible:
			true:
				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			false:
				Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	if Input.is_mouse_button_pressed(1):
		if Ray.is_colliding():
			var obj = Ray.get_collider()
			if obj:
				obj = obj.get_parent()
				if obj is Bot:
					select_bot(obj)
	
	if Input.is_action_pressed("ui_cancel"):
		delink_bot()


func _physics_process(delta):
	if follow_bot:
		translation = follow_bot.translation
		translation.x -= 3
		translation.y += 2
		translation.z -= 3
		
		var look_pos = Vector3(translation.x + 3, translation.y - 2, translation.z + 3.5)
		look_at(follow_bot.translation, Vector3.UP)
		
		
		return
	
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


func delink_bot() -> void:
	follow_bot = null
	var look_pos = Vector3(translation.x + 1, translation.y, translation.z + 1)
	look_at(look_pos, Vector3.UP)


func select_bot(bot: Bot) -> void:
	head.rotation = Vector3.ZERO
	follow_bot = bot
	follow_bot.connect("died", self, "delink_bot")
	emit_signal("bot_raycasted", bot)

