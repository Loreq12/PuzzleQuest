extends State
class_name GemSelected

func Enter():
	var gem: Gem = get_tree().get_first_node_in_group("gem_selected")
	assert(gem, "ERROR: No gems found in \'selected\' group despite beeing in %s state" % name)
	gem.selection_sprite.visible = true
	gem.animation_player.play("selected gem")
