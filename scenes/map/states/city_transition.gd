extends State
class_name MapCityTransition

@export var cities: CityContainer

func Enter():
	get_tree().call_group("interaction_on_travel", "disable_interation")
	await cities.transition_player_to_city()
	get_tree().call_group("interaction_on_travel", "enable_interation")
