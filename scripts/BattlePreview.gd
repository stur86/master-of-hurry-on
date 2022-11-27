extends Panel

@export_color_no_alpha var victory_color: Color
@export_color_no_alpha var defeat_color: Color

const v_icon = preload("res://sprites/victory_icon.png")
const d_icon = preload("res://sprites/defeat_icon.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	Switchboard.display_system.connect(
		Callable(self, "display_system")
	)

func display_system(sys: StarSystem):
		
	if sys == null or sys.is_empire:
		visible = false
	else:
		visible = true
		$SystemName.text = sys.star_name
		$SystemIcon.texture = sys.img
		$Power/Label.text = "%d (+%d)" % [sys.fleet_capacity, sys.growth]
		
		var cost = sys.calc_total_invasion_cost()
		
		$BattleCost/Label.text = "%d+%d" % [cost["attrition"], cost["battle"]]
		
		if (cost["total"] >= EmpireManager.empire_fleet_size):
			$Outcome/TextureRect.texture = d_icon
			$Outcome.text = "Defeat"
			$Outcome.self_modulate = defeat_color
		else:
			$Outcome/TextureRect.texture = v_icon
			$Outcome.text = "Victory"
			$Outcome.self_modulate = victory_color
		
		
