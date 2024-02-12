extends StateMachine

class_name BoardStateMachine


func _init_transitions():
	states_allowed_transitions = {
		"GemDeselected": ["GemSelected"],
		"GemSelected": ["GemDeselected"],
		"GemTransitioned": [],
		"GemReverted": [],
		"GemDestroyed": []
	}

func change_state_to_gem_selected():
	current_state.Transition.emit(current_state, "GemSelected")

func change_state_to_gem_deselected():
	current_state.Transition.emit(current_state, "GemDeselected")
