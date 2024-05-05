extends StateMachine
class_name MapStateMachine


func _init_transitions():
	states_allowed_transitions = {
		"MapDefaultState": ["MapCityTransition", "MapCityContextMenu"],
		"MapCityTransition": ["MapDefaultState", "MapBattleSelector"],
		"MapCitySelected": ["MapDefaultState"],
		"MapCityContextMenu": ["MapDefaultState"],
		"MapBattleSelector": ["MapCityTransition"],
	}

func change_to_battle_selector():
	transition_to("MapBattleSelector")

func change_to_default_state():
	transition_to("MapDefaultState")

func change_to_city_selected():
	transition_to("MapCitySelected")

func change_to_show_city_context_menu():
	transition_to("MapCityContextMenu")

func change_to_city_transition():
	await transition_to("MapCityTransition")
