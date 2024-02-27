extends StateMachine
class_name BoardStateMachine


func _init_transitions():
	states_allowed_transitions = {
		"GemDefault": ["GemSelected"],
		"GemSelected": ["GemDefault", "GemSelected", "GemTransitioned"],
		"GemTransitioned": ["GemDestroyed", "GemReverted"],
		"GemReverted": ["GemDefault"],
		"GemDestroyed": ["BoardFilling"],
		"BoardFilling": ["GemDestroyed", "GemDefault"],
	}

func change_to_gem_selected_state():
	transition_to("GemSelected")

func change_to_default_state():
	transition_to("GemDefault")

func change_to_gem_transition_state():
	await transition_to("GemTransitioned")

func change_to_gem_destroy_state():
	await transition_to("GemDestroyed")
	
func change_to_gem_revert_state():
	await transition_to("GemReverted")

func change_to_board_filling_state():
	await transition_to("BoardFilling")
