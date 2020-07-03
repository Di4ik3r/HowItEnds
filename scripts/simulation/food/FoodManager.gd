extends Spatial



signal food_size_changed(food_amount)

const FOOD_PATH = "res://scenes/simulation/food/Food.tscn"
#signal food_timer_timeout

export(float) var time = 1 setget _set_time
export(bool) var spawning = true setget _set_spawning
export(int) var amount = 1 
export(float, 0.0001, 0.7) var amount_multiplier = 0.3

var map_manager: MapManager
var foods: Dictionary = {}

onready var FoodTimer: = $FoodTimer as Timer setget _set_food_timer


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ VIRTUAL
func _ready():
	pass

# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PUBLIC

func start_spawn() -> void:
#	var amount = map_manager.map_export.a_side * map_manager.map_export.b_side
#	amount *= 0.06
	start(amount * amount_multiplier)


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
	
#	print(foods.size())
	emit_signal("food_size_changed", foods.size())

	self.add_child(food)

func remove_food(pos: Vector3) -> void:
	map_manager.remove_food(pos)
	
	var food = foods[Vector3(pos.x, 0, pos.z)]
	foods.erase(Vector3(pos.x, 0, pos.z))
	self.remove_child(food)
	food.queue_free()
	
	emit_signal("food_size_changed", foods.size())


func clear_food() -> void:
	for key in foods:
		map_manager.remove_food(key)
		var food = foods[key]
		self.remove_child(food)
		food.queue_free()

	foods.clear()
	emit_signal("food_size_changed", foods.size())
	pass


# ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ PRIVATE
func _set_spawning(value: bool) -> void:
	if !FoodTimer:
		return
	
	spawning = value
	match spawning:
		true:
			FoodTimer.start(time)
		false:
			FoodTimer.stop()


func _set_time(value: float) -> void:
	time = value
	if FoodTimer:
		FoodTimer.wait_time = time


func _on_FoodTimer_timeout():
#	emit_signal("food_timer_timeout")
	if spawning:
		if foods.size() <= amount * amount_multiplier:
			spawn_food()


func _set_food_timer(value) -> void:
	FoodTimer = value
	print(FoodTimer, value)
	_set_time(time)
	_set_time(spawning)
