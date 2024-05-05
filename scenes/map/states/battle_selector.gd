extends State

@onready var battle_panel: Panel = $"../../Panel"


func Enter():
	battle_panel.visible = true

func Exit():
	battle_panel.visible = false
