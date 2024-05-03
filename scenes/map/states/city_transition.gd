extends State
class_name MapCityTransition

@export var cities: CityContainer
@export var enemy_spawner: Timer

func Enter():
	get_tree().call_group("interaction_on_travel", "disable_interation")
	enemy_spawner.paused = true
	await cities.transition_player_to_city()
	enemy_spawner.paused = false
	get_tree().call_group("interaction_on_travel", "enable_interation")
