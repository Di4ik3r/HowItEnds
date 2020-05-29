extends Spatial


const FOOD_PATH = "res://scenes/simulation/food/Food.tscn"
#signal food_timer_timeout

export(float) var time = 1 setget _set_time
export(bool) var spawning = true setget _set_spawning

var map_manager: MapManager
var foods: Dictionary = {}

onready var FoodTimer: = $FoodTimer as Timer


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ VIRTUAL
func _ready():
	_set_time(time)
	_set_time(spawning)

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PUBLIC
func start() -> void:
	for i in range(0, 30):
		spawn_food()
#	FoodTimer.start()

func spawn_food() -> void:
	var pos = map_manager.get_available_pos()
	if pos == Vector3.INF:
		return
	map_manager.place_food(pos)
	var food = load(FOOD_PATH).instance()
	food.translation = pos
	foods[Vector3(pos.x, 0, pos.z)] = food
	
	self.add_child(food)

func remove_food(pos: Vector3) -> void:
	map_manager.remove_food(pos)
	
	var food = foods[Vector3(pos.x, 0, pos.z)]
	foods.erase(Vector3(pos.x, 0, pos.z))
	self.remove_child(food)
	food.queue_free()

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRIVATE
func _set_spawning(value: bool) -> void:
	spawning = false
	match spawning:
		true:
			FoodTimer.start()
		false:
			FoodTimer.stop()


func _set_time(value: float) -> void:
	time = value
	FoodTimer.wait_time = time


func _on_FoodTimer_timeout():
#	emit_signal("food_timer_timeout")
	spawn_food()
