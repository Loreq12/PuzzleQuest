extends State
class_name GemDestroyed

func Enter():
	get_tree().call_group("gem_destroy", "destroy")
