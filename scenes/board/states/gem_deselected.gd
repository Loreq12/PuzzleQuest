extends State
class_name GemDefault

func Enter():
	get_tree().call_group("interaction", "enable_interation")
	var gems: Array = get_tree().get_nodes_in_group("gem_selected")
	for gem in gems:
		gem.selection_sprite.visible = false
		gem.animation_player.stop()
		gem.remove_from_group("gem_selected")
	for g in get_tree().get_nodes_in_group("gem_neighbors"):
		g.remove_from_group("gem_neighbors")
