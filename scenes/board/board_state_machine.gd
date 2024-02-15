extends StateMachine

class_name BoardStateMachine


func _init_transitions():
	states_allowed_transitions = {
		"GemDefault": ["GemSelected"],
		"GemSelected": ["GemDefault", "GemSelected", "GemTransitioned"],
		"GemTransitioned": ["GemDestroyed", "GemReverted"],
		"GemReverted": ["GemDefault"],
		"GemDestroyed": ["GemDefault", "BoardFilling"],
		"BoardFilling": [],
	}

func change_to_gem_selected_state():
	current_state.Transition.emit(current_state, "GemSelected")

func change_to_default_state():
	current_state.Transition.emit(current_state, "GemDefault")

func change_to_gem_transition_state():
	current_state.Transition.emit(current_state, "GemTransitioned")

func change_to_gem_destroy_state():
	current_state.Transition.emit(current_state, "GemDestroyed")
	
func change_to_gem_revert_state():
	current_state.Transition.emit(current_state, "GemReverted")

func change_to_board_filling_state():
	current_state.Transition.emit(current_state, "BoardFilling")
