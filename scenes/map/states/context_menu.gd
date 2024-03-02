extends State

@export var cities: CityContainer
@export var map: TextureRect

func Enter():
	get_tree().call_group("interaction_on_travel", "disable_interation")
	map.show_context_menu(cities.current_city)

func Exit():
	map.hide_context_menu(cities.current_city)
	get_tree().call_group("interaction_on_travel", "enable_interation")
