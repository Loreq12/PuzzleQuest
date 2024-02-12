extends StateMachine

class_name BoardStateMachine


func _init_transitions():
	states_allowed_transitions = {
		"GemDefault": ["GemSelected"],
		"GemSelected": ["GemDefault", "GemSelected"],
		"GemTransitioned": [],
		"GemReverted": [],
		"GemDestroyed": []
	}

func change_to_gem_selected_state():
	current_state.Transition.emit(current_state, "GemSelected")

func change_to_default_state():
	current_state.Transition.emit(current_state, "GemDefault")
