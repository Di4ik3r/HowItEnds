extends Spatial


const FOOD_PATH = "res://scenes/simulation/food/Food.tscn"
#signal food_timer_timeout

export(float) var time = 1 setget _set_time
export(bool) var spawning = true setget _set_spawning

var map_manager: MapManager
var foods: Dictionary = {}

onready var FoodTimer: = $FoodTimer as Timer setget _set_food_timer


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ VIRTUAL
func _ready():
	pass

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PUBLIC

func start_spawn() -> void:
	var amount = map_manager.map_export.a_side * map_manager.map_export.b_side
	amount *= 0.03
	start(amount)


func start(amount: int) -> void:
	for i in range(0, amount):
		spawn_food()
#	FoodTimer.start()


func spawn_food() -> void:
	var pos = map_manager.get_available_pos()
	if pos == Vector3.INF:
#		map_manager.export_map_to_csv()
#		breakpoint
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


func clear_food() -> void:
	for key in foods:
		map_manager.remove_food(key)
		var food = foods[key]
		self.remove_child(food)
		food.queue_free()

	foods.clear()
	pass


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRIVATE
func _set_spawning(value: bool) -> void:
	if !FoodTimer:
		return
	
	spawning = value
	match spawning:
		true:
			FoodTimer.start(0.12)
		false:
			FoodTimer.stop()


func _set_time(value: float) -> void:
	time = value
	if FoodTimer:
		FoodTimer.wait_time = time


func _on_FoodTimer_timeout():
#	emit_signal("food_timer_timeout")
	if spawning:
		spawn_food()


func _set_food_timer(value) -> void:
	FoodTimer = value
	print(FoodTimer, value)
	_set_time(time)
	_set_time(spawning)
