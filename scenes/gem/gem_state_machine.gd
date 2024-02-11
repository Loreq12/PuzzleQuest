extends StateMachine
class_name GemStateMachine

func _init_transitions():
	states_allowed_transitions = {
		"GemSelected": ["GemDeselected"],
		"GemDeselected": ["GemSelected"]
	}

func toggle() -> void:
	if current_state.name == "GemSelected":
		current_state.Transition.emit(current_state, "GemDeselected")
	elif current_state.name == "GemDeselected":
		current_state.Transition.emit(current_state, "GemSelected")
