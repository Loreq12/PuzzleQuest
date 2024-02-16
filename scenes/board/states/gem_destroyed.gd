extends State
class_name GemDestroyed

func Enter():
	get_tree().call_group("gem_destroy", "destroy")
	var gem: Gem = get_tree().get_first_node_in_group("gem_destroy")
	await gem.particles.finished
	get_tree().call_group("gem_destroy", "queue_free")
