extends Spatial


onready var animation = $AnimationPlayer

func _ready():
	pass


func play_move() -> void:
	animation.play("AnimationJump")


func play_eat() -> void:
	animation.play("ArmatureEat")
