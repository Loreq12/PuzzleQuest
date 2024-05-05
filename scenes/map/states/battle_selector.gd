extends State

@export var battle_panel: Panel

func Enter():
	battle_panel.visible = true

func Exit():
	battle_panel.visible = false
