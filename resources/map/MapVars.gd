extends Resource


signal noise_seed_changed
signal forest_comparison_changed
signal forest_percent_changed
signal forest_period_changed

signal refresh_ui(values)

const CUBE_SIZE = 1

const HEIGHT_ADDITION: float = 2.8
const BLOCK_HEIGHT_MULTIPLIER: float = 3.0
const NOISE_MULTIPLIER: float = 6.0

const SAND_COMPARISON: float = 0.2
const MOUNTAIN_COMPARISON: float = 2.0

const COLOR_GRASS_INTERPOLATION: Color = Color(0.2, 0.6, 0)
const COLOR_GRASS: Color = Color(0.5, 0.8, 0)
const COLOR_SAND_INTERPOLATE: Color = Color.black
const COLOR_SAND: Color = Color(0.6, 0.4, 0)
const COLOR_WATER_INTERPOLATION: Color = Color(0, 0.5, 1)
const COLOR_WATER: Color = Color.blue
const COLOR_MOUNTAIN_INTERPOLATION: Color = Color.white
const COLOR_MOUNTAIN: Color = Color(0.69, 0.69, 0.69)

const WATER_HEIGHT: float = -0.2
const WATER_COMPARISON: float = -0.4

export(int, 1, 100) var a_side: int = 50 setget _set_a
export(int, 1, 100) var b_side: int = 20 setget _set_b
export(int) var noise_seed: int = 0 setget _set_noise_seed
export(float, 0, 8, 0.001) var forest_comparison: float = 4.0 setget _set_forest_comparison
export(float, 0, 1, 0.01) var forest_percent: float = 0.3 setget _set_forest_percent
export(int, 1, 12, 1) var forest_period: int = 2 setget _set_forest_period
export(bool) var generate_mountain: bool = true setget _set_generate_mountain

var noise: = OpenSimplexNoise.new() as OpenSimplexNoise
var noise_tree: = OpenSimplexNoise.new() as OpenSimplexNoise

func _init() -> void:
	_trees_noise_configuration()
	_terrain_noise_configuration()

func _set_a(value: int) -> void:
	a_side = value
#	_update_Terrain()
func _set_b(value: int) -> void:
	b_side = value
#	_update_Terrain()
func _set_noise_seed(value: int) -> void:
	noise_seed = value
	noise.seed = value
	noise_tree.seed = value
#	emit_signal("noise_seed_changed", value)
#	_update_Terrain()
func _set_forest_comparison(value: float) -> void:
	forest_comparison = value
#	emit_signal("forest_comparison_changed", value)
#	_update_Terrain()
func _set_forest_percent(value: float) -> void:
	forest_percent = value
#	emit_signal("forest_percent_changed", value)
#	_update_Terrain()
func _set_forest_period(value: int) -> void:
	forest_period = value
	_trees_noise_configuration()
#	emit_signal("forest_period_changed", value)
#	_update_Terrain()
func _set_generate_mountain(value: bool) -> void:
	generate_mountain = value
#	_update_Terrain()
func _trees_noise_configuration() -> void:
	noise_tree.seed = noise_seed if noise_seed else 0
	noise_tree.octaves = 2
	noise_tree.period = forest_period
	noise_tree.persistence = 0
	noise_tree.lacunarity = 2
func _terrain_noise_configuration() -> void:
	noise.seed = noise_seed if noise_seed else 0
	noise.octaves = 2
	noise.period = 32
	noise.persistence = 0.25
	noise.lacunarity = 2

func randomize() -> void:
	randomize()
	var noise_seed = randi() % 999999 - 999999
	var forest_comparison = rand_range(0, 8)
	var forest_percent = randf()
	var forest_period = randi() % 12 + 1
	
	_set_noise_seed(noise_seed)
	_set_forest_comparison(forest_comparison)
	_set_forest_percent(forest_percent)
	_set_forest_period(forest_period)
	
	var values = {
		"noise_seed": noise_seed,
		"forest_comparison": forest_comparison,
		"forest_percent": forest_percent,
		"forest_period": forest_period,
	}
	emit_signal("refresh_ui", values)



# doesnt work - DO NOT USE
func refresh() -> void:
	var values = {
		"a_side": a_side,
		"b_side": b_side,
		"noise_seed": noise_seed,
		"forest_comparison": forest_comparison,
		"forest_percent": forest_percent,
		"forest_period": forest_period,
	}
	emit_signal("refresh_ui", values)
