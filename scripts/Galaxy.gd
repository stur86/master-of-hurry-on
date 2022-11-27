extends Node2D

var ssys_base = preload("res://objects/star_system.tscn")

func _ready():
	var start_system = generate_galaxy()
	
	# Initialise the empire
	EmpireManager.reset()
	EmpireManager.start()
	start_system.add_to_empire()
	
	Switchboard.center_camera.emit(start_system.position)
	
func generate_galaxy() -> StarSystem:
	
	var cat = StarCatalog.new()
	var start_sys: StarSystem = null
	
	var hN = int(LevelParameters.sector_N/2)
	var L = LevelParameters.sector_side
	var R = LevelParameters.sector_inner_r*0.5*L
	
	for xi in range(-hN, hN+1):
		for yi in range(-hN, hN+1):
			# Generate a system
			var p0 = Vector2((xi+0.5)*L, (yi+0.5)*L)
			var phi = randf()*2*PI
			var r = R*sqrt(randf())
			var p = p0+Vector2.from_angle(phi)*r
			
			var ssys = ssys_base.instantiate()
			ssys.position = p
			ssys.star_name = cat.star_names.pick_random()

			if (xi == 0) and (yi == 0):
				start_sys = ssys

			ssys.generate(ssys == start_sys)

			add_child(ssys)
	
	return start_sys
