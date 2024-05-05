extends State

@export var enemy_spawner: Timer

func Enter():
	enemy_spawner.paused = false
	
func Exit():
	enemy_spawner.paused = true
