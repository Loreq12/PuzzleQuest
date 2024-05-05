extends Panel

@onready var state_machine: MapStateMachine = $"../MapStateMachine"


func _on_cancel_pressed():
	await state_machine.change_to_city_transition()
	state_machine.change_to_default_state()
