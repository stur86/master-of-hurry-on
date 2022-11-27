extends ParallaxLayer

@export var bkg_area: Rect2 = Rect2(-2000, -2000, 4000, 4000)
@export_color_no_alpha var bkg_color: Color = Color.BLACK
@export var star_density = 1.0/10000

var star_sprite = preload("res://sprites/tiny_star.png")
var stars = []

# Called when the node enters the scene tree for the first time.
func _ready():
	# Compute the stars
	var star_n = bkg_area.get_area()*star_density
	
	for i in range(star_n):
		stars.append(bkg_area.position + bkg_area.size*Vector2(randf(), randf()))

func _draw():
	draw_rect(bkg_area, bkg_color)
	
	for s in stars:
		draw_texture(star_sprite, s)
