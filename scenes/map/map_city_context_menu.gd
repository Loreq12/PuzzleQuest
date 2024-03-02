extends ItemList
class_name MapCityContextMenu

@onready var state_machine: MapStateMachine = $"../../MapStateMachine"

var citadel_icon = preload("res://scenes/map/city_context_menu/Citadel.png")
var mission_icon = preload("res://scenes/map/city_context_menu/Missions.png")
var tavern_icon = preload("res://scenes/map/city_context_menu/Tavern.png")
var shop_icon = preload("res://scenes/map/city_context_menu/Shop.png")
var equipment_icon = preload("res://scenes/map/city_context_menu/Equipment.png")
var quit_icon = preload("res://scenes/map/city_context_menu/Quit.png")
		
func redraw_menu(city: MapCity):
	clear()
	
	if city.your_citadel:
		add_item("Your citadel", citadel_icon)
	if city.missions:
		add_item("Missions", mission_icon)
	if city.tavern:
		add_item("Tavern", tavern_icon)
	if city.shop:
		add_item("Shop", shop_icon)
	if city.equipment:
		add_item("Equipment", equipment_icon)
	add_item("Quit", quit_icon)
	
	position = Vector2i(city.position.x - size.x / 2, city.position.y - size.y / 2)

func _on_item_selected(index):
	var icon = get_item_icon(index)
	if icon == quit_icon:
		state_machine.change_to_default_state()
