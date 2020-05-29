extends Spatial


const FOOD_PATH = "res://scenes/simulation/food/Food.tscn"
#signal food_timer_timeout

export(float) var time = 1 setget _set_time

var map_manager: MapManager
var foods: Dictionary = {}

onready var FoodTimer: = $FoodTimer as Timer


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ VIRTUAL
func _ready():
	pass

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PUBLIC
func start() -> void:
	FoodTimer.start()

func spawn_food() -> void:
	var pos = map_manager.get_available_pos()
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
func _set_time(value: float) -> void:
	time = value
	FoodTimer.wait_time = time

func _on_FoodTimer_timeout():
#	emit_signal("food_timer_timeout")
	spawn_food()
	spawn_food()
	remove_food(foods.keys()[0])
