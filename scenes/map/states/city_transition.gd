extends State
class_name MapCityTransition

@export var cities: CityContainer

func Enter():
	get_tree().call_group("city_on_map", "disable_interation")
	await cities.transition_player_to_city()
	get_tree().call_group("city_on_map", "enable_interation")
