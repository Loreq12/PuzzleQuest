extends Node
## Base state machine responsible for state transition and ensuring transition to correct state
class_name StateMachine

## Initial state must be selected, otherwise raises an error
@export var initial_state: State

## Holds current state
var current_state: State
## Precise type: [code]Dictionary[string: State][/code][br]
## Holds names of the nodes and corresponding State attached to them
var states: Dictionary = {}

## Precise type: [code]Dictionary[string, Array[string]][/code][br]
## Holds state names and correspoinding allowed state names which can be transitioned to.
## If unknown transition is performed error is raised.
## [method _ready] checkes correctness of the data and each time transtions takes place in [method on_state_transition].[br][br]
## [b]Note:[/b] This variable is not case sensitive (values will be mapped to lowercase).
var states_allowed_transitions: Dictionary = {}

func _init_transitions():
	pass

func _check_if_state_transition_matches_defined_states():
	for state_name in states.keys():
		var corresponding_state_name = states_allowed_transitions.get(state_name)
		assert(corresponding_state_name != null, "ERROR: State \'%s\' was not defined in `states_allowed_transitions`" % state_name)
		assert(corresponding_state_name is Array, "ERROR: State \'%s\' did not defined allowed states to transition to" % state_name)

func _map_states_to_lower_case():
	for state_name in states_allowed_transitions.keys():
		var new_state_name = state_name.to_lower()
		states_allowed_transitions[new_state_name] = states_allowed_transitions[state_name]
		states_allowed_transitions[new_state_name] = states_allowed_transitions[new_state_name].map(func(target: String): return target.to_lower())
		states_allowed_transitions.erase(state_name)

## Overrides [method Node._ready]. Does the following:[br][br]
## - Initializes [member states] with children states defined inside tree[br]
## - Converts [member states_allowed_transitions] all state names to be lowercase[br]
## - Checks if all states in [member states] were defined in [member states_allowed_transitions][br]
## - Checks if [member initial_state] was defined
## - Triggers [method State.Enter]
func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transition.connect(on_state_transition)
	
	_init_transitions()
	_map_states_to_lower_case()
	_check_if_state_transition_matches_defined_states()
			
	assert(initial_state, "ERROR: Initial state was not set")
	
	initial_state.Enter()
	current_state = initial_state

func on_state_transition(state: State, new_state_name: String):
	if state != current_state:
		return
	
	var new_state = states.get(new_state_name.to_lower())
	assert(new_state, "ERROR: State: \'%s\' is not registered" % new_state_name)
	
	var allowed_transitions_list: Array = states_allowed_transitions.get(state.name.to_lower(), [])
	assert(new_state_name.to_lower() in allowed_transitions_list, "ERROR: Unsupported state transition. %s attempts to transition to %s but only %s is allowed" % [state, new_state, allowed_transitions_list])
	
	if current_state:
		current_state.Exit()
		
	new_state.Enter()
	
	current_state = new_state
