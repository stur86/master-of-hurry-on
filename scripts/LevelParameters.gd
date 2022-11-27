extends Node

var sector_side: int = 100
var sector_N: int = 30
var sector_inner_r: float = 0.8

var base_size = 5
var start_size_bonus = 3
var min_size_factor = 5.0
var max_size_factor = 20.0

var min_growth = 2
var max_growth = 5

var hard_radius = 1.5
var hard_size_max_bonus = 20
var hard_growth_max_malus = 3

var attrition_closest_factor = 1.5
var attrition_furthest_factor = 0.8

func fleet_size_formula(r: float) -> int:
	
	var mins = ceili(min_size_factor*r)
	var maxs = ceili(max_size_factor*r)
	maxs = max(maxs, mins+1)
	
	if r > hard_radius:
		var bonus = randi_range(0, hard_size_max_bonus)
		mins += bonus
		maxs += bonus
	
	return randi_range(mins, maxs)

func growth_formula(r: float) -> int:
	
	var ming = min_growth
	var maxg = max_growth
	
	if r > hard_radius:
		var malus = randi_range(0, hard_growth_max_malus)
		ming = max(ming-malus, 0)
		maxg = max(maxg-malus, 1)
	
	return randi_range(ming, maxg)
