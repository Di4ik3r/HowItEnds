extends Spatial


#signal food_timer_timeout

export(float) var time = 1 setget _set_time

var map_pos: Array

onready var FoodTimer: = $FoodTimer as Timer


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ VIRTUAL
func _ready():
	pass

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PUBLIC
func start() -> void:
	FoodTimer.start()

func spawn_food() -> void:
	pass

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRIVATE
func _set_time(value: float) -> void:
	time = value
	FoodTimer.wait_time = time

func _on_FoodTimer_timeout():
#	emit_signal("food_timer_timeout")
	pass
