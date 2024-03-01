extends ItemList

@onready var city: MapCity = $".."

func _ready():
	redraw_menu()
		
func redraw_menu():
	clear()
	if city.your_citadel:
		add_item("Your citadel", load("res://scenes/map/city_context_menu/Citadel.png"))
	if city.missions:
		add_item("Missions", load("res://scenes/map/city_context_menu/Missions.png"))
	if city.tavern:
		add_item("Tavern", load("res://scenes/map/city_context_menu/Tavern.png"))
	if city.shop:
		add_item("Shop", load("res://scenes/map/city_context_menu/Shop.png"))
	if city.equipment:
		add_item("Equipment", load("res://scenes/map/city_context_menu/Equipment.png"))
	add_item("Quit", load("res://scenes/map/city_context_menu/Quit.png"))
