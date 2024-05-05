extends Sprite2D

@onready var cities_map: CityContainer = $"../Cities"


func _ready():
	position = cities_map.current_city.position
