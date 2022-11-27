extends Area2D
class_name  StarSystem

# Properties
var star_name: String = "STAR"
var fleet_capacity: int = 0
var growth: int = 0
var img: Texture2D
var is_empire: bool = false

var closest_empire: StarSystem = null
var furthest_empire: StarSystem = null
var attrition_cost: int = 0

# Possible textures
const textures = [
	preload("res://sprites/star_1.png"),
	preload("res://sprites/star_2.png"),
	preload("res://sprites/star_3.png"),
	preload("res://sprites/star_4.png")
]

func _ready():
	EmpireManager.new_empire_system.connect(
		Callable(self, "recalc_attrition")
	)
	# Set up the scale of the conquest area
	var r = LevelParameters.sector_side
	$ConquestArea.scale = Vector2(
		r, r
	)/24.0
	
func generate(initial: bool = false):
	img = textures[randi_range(0, len(textures)-1)]
	$Sprite.texture = img
	
	var r = position.length()/LevelParameters.sector_side
	fleet_capacity = LevelParameters.fleet_size_formula(r)

	if initial:
		fleet_capacity += LevelParameters.start_size_bonus
	
	growth = LevelParameters.growth_formula(r)

func add_to_empire():
	is_empire = true
	$ConquestArea.visible = true
	EmpireManager.conquer_system(self)
	$SFX.play()


func recalc_attrition(s: StarSystem):
	
	if is_empire:
		# Nothing to be done
		attrition_cost = 0
		return
	
	var new_r = s.position.distance_to(position)
	var ce = closest_empire
	var fe = furthest_empire
	
	if (ce == null or ce.position.distance_to(position) > new_r):
		closest_empire = s
	
	if (fe == null or fe.position.distance_to(position) < new_r):
		furthest_empire = s
	
	var cr = closest_empire.position.distance_to(position)/LevelParameters.sector_side
	var fr = furthest_empire.position.distance_to(position)/LevelParameters.sector_side
	
	attrition_cost = (int(cr*LevelParameters.attrition_closest_factor) + 
		int(fr*LevelParameters.attrition_furthest_factor))

func calc_total_invasion_cost() -> Dictionary:
	
	var A = EmpireManager.empire_fleet_size
	var B = fleet_capacity
	
	var attr_cost = min(attrition_cost, A)
	var A_eff = A-attr_cost
	
	#print("Starting armies: A = ", A, " B = ", B)
	#print("Attrition cost = ", attrition_cost)
	#print("Effective operatives A_eff = ", A_eff)
	
	if B > A_eff:
		return {
			"attrition": attr_cost,
			"battle": A_eff,
			"total": A
		} # Total annihilation
	
	var A_surv = floori(A_eff*sqrt(1.0-pow(B*1.0/A_eff, 2.0))) # Survivors
	var battle_cost = A_eff - A_surv 
	
	#print("Surviving fleet: A = ", A_surv)
	#print("Total cost: ", A - A_surv)
	#print()
	
	return {
		"attrition": attr_cost,
		"battle": battle_cost,
		"total": attrition_cost+battle_cost
	}

func attempt_conquest():
	
	if is_empire:
		return
	
	var cost = calc_total_invasion_cost()
	
	if (cost["total"] >= EmpireManager.empire_fleet_size):
		get_tree().change_scene_to_file("res://scenes/endgame_screen.tscn")
	else:
		EmpireManager.suffer_casualties(cost["total"])
		add_to_empire()
	
func _on_mouse_entered():
	Switchboard.display_system.emit(self)


func _on_mouse_exited():
	Switchboard.display_system.emit(null)


func _on_input_event(viewport, event, shape_idx):
	
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_LEFT and 
			event.is_pressed()):
			attempt_conquest()
