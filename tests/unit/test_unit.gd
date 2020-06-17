extends "res://addons/gut/test.gd"


var sim_stats = SimStats.new()
var bot = Bot.new()


func test_sim_stats() -> void:
	assert_eq(sim_stats.save_test(), OK)
	assert_eq(sim_stats.read_test(), OK)
