extends Panel

@onready var state_machine: MapStateMachine = $"../MapStateMachine"

func _on_cancel_pressed():
	await state_machine.change_to_city_transition()
	state_machine.change_to_default_state()

func _on_battle_pressed():
	var next_level_resource = preload("res://scenes/board/board.tscn")
	var next_level = next_level_resource.instantiate()
	get_tree().get_root().add_child(next_level)
	
