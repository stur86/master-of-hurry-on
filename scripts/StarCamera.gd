extends Camera2D


@export var scroll_speed: float = 10.0
var scroll_dir: Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready():
	Switchboard.start_scrolling.connect(
		Callable(self, "set_scrolling")
	)
	Switchboard.center_camera.connect(
		Callable(self, "center_at")
	)
	set_physics_process(true)
	
func _physics_process(delta):
	position += scroll_dir*scroll_speed*delta

func set_scrolling(v: Vector2):
	scroll_dir = v
	
func center_at(p: Vector2):
	position = p
