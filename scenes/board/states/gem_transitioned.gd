extends State
class_name GemTransitioned

@export var board: GemContainer

func Enter():
	get_tree().call_group("interaction", "disable_interation")
	var gems: Array = get_tree().get_nodes_in_group("gem_selected")
	assert(gems.size() == 2, "ERROR: Transition can occur only between 2 gems")
	
	var gem_1: Gem = gems[0]
	var gem_2: Gem = gems[1]
	gem_1.selection_sprite.visible = false
	gem_1.animation_player.stop()
	gem_2.selection_sprite.visible = false
	gem_2.animation_player.stop()
	
	var temp_board_position: Vector2i = gem_1.board_position
	gem_1.board_position = gem_2.board_position
	gem_2.board_position = temp_board_position
	
	var tween := create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUART)
	tween.tween_property(gem_1, "position", gem_2.position, .4)
	tween.tween_property(gem_2, "position", gem_1.position, .4)
	tween.connect("finished", board.check_for_matches)
