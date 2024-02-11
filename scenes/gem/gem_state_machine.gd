extends StateMachine
class_name GemStateMachine


func _init_transitions():
	states_allowed_transitions = {
		"GemDeselected": ["GemSelected"],
		"GemSelected": ["GemDeselected", "GemTransitioned"],
		"GemTransitioned": ["GemReverted", "GemDestroyed"],
		"GemReverted": ["GemDeselected"],
		"GemDestroyed": []
	}

func toggle() -> void:
	if current_state.name == "GemSelected":
		current_state.Transition.emit(current_state, "GemDeselected")
	elif current_state.name == "GemDeselected":
		current_state.Transition.emit(current_state, "GemSelected")

func transition(source: Vector2, target: Vector2) -> void:
	$GemTransitioned.target_transition = target
	$GemReverted.target_transition = source
	current_state.Transition.emit(current_state, "GemTransitioned")

func revert() -> void:
	current_state.Transition.emit(current_state, "GemReverted")
	
func destroy() -> void:
	current_state.Transition.emit(current_state, "GemDestroyed")
