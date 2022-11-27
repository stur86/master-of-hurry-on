extends Node

signal tick
signal new_empire_system
signal game_over

var empire_systems: Array = []
var empire_fleet_size: int = 0
var empire_fleet_capacity: int = 0
var empire_growth_rate: int = 0

var start_year: int = 2200
var end_year: int = 2400
var year: int = start_year
var year_rate: float = (end_year-start_year)/20.0 # Years per second
var time: float = 0.0

func _physics_process(delta):
	
	time += delta
	if time > 1.0/year_rate:
		time -= 1.0/year_rate
		_tick()

func reset():
	empire_systems = []
	empire_fleet_size = 0
	empire_fleet_capacity = 0
	empire_growth_rate = 0
	year = start_year
	time = 0.0
	
func start():
	set_physics_process(true)
	
func stop():
	set_physics_process(false)
	
func _tick():
	
	empire_fleet_size = min(empire_fleet_size + empire_growth_rate, empire_fleet_capacity)
	year += 1
	
	tick.emit()
	
	if year >= end_year:
		stop()
		game_over.emit()
		get_tree().change_scene_to_file("res://scenes/endgame_screen.tscn")
	
func suffer_casualties(n: int) -> bool:
	empire_fleet_size -= n
	if empire_fleet_size < 0:
		empire_fleet_size = 0
		return false

	return true
	
func conquer_system(s: StarSystem):
	print("Adding system to empire: ", s.star_name)
	
	empire_systems.append(s)
	empire_fleet_capacity += floori(s.fleet_capacity)
	empire_growth_rate += s.growth
	
	new_empire_system.emit(s)
