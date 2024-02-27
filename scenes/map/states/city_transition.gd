extends State
class_name MapCityTransition

@export var cities: CityContainer

func Enter():
	cities.transition_player_to_city()
