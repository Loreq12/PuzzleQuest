extends Container

class_name GemContainer

enum GEM_DIRECTION {
	LEFT = 1,
	RIGHT = 2,
	TOP = 4,
	BOTTOM = 8,
	ALL = LEFT | RIGHT | TOP | BOTTOM
}

var BOARD_SIZE = 8

var revert_gems = []
var destroyed = {}

@onready var state_machine: BoardStateMachine = $"../../StateMachine"

func _prepare_gem(v: Vector2):
	var gem = preload("res://scenes/gem/gem.tscn").instantiate()
	gem.setup_gem_color()
	gem.setup_gem_position_on_board(v)
	gem.add_to_group("interaction")
	gem.connect("s_gem_selected", _handle_gem_selected)
	#gem.connect("gem_finished_transition", _handle_gem_transition_finished)
	#gem.connect("gem_destroyed", _handle_gem_destroyed)
	
	return gem

func _disable_interaction():
	for gem in get_children():
		gem.disable_interation()

func _enable_interaction():
	for gem in get_children():
		gem.enable_interation()
	
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#var random_seed: int = randi()
	var random_seed: int = 2642849264
	print(str("Seed: ", random_seed))
	seed(random_seed)

	var enemy_panel: VBoxContainer = get_node("../EnemyPanel")
	var player_panel: VBoxContainer = get_node("../PlayerPanel")
	var viewport_size = Vector2(get_viewport().size)
	var container_size: Vector2 = viewport_size - enemy_panel.size - player_panel.size
	
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			var gem = _prepare_gem(Vector2(x, y))
			
			while true:
				var left_neighbor: Gem = get_neighbor_gem(gem, GemContainer.GEM_DIRECTION.LEFT)
				if left_neighbor and left_neighbor.gem_type == gem.gem_type:
					left_neighbor = get_neighbor_gem(left_neighbor, GemContainer.GEM_DIRECTION.LEFT)
					if left_neighbor and left_neighbor.gem_type == gem.gem_type:
						gem.setup_gem_color()
						continue
	
				var top_neighbor: Gem = get_neighbor_gem(gem, GemContainer.GEM_DIRECTION.TOP)
				if top_neighbor and top_neighbor.gem_type == gem.gem_type:
					top_neighbor = get_neighbor_gem(top_neighbor, GemContainer.GEM_DIRECTION.TOP)
					if top_neighbor and top_neighbor.gem_type == gem.gem_type:
						gem.setup_gem_color()
						continue
			
				break
			
			add_child(gem)

func generate_gem_to_fill_board(v: Vector2i):
	var gem: Gem = _prepare_gem(Vector2i(v.x, -1))
	add_child(gem)
	gem.setup_gem_position_on_board(v)

func get_neighbor_gem(gem: Gem, direction: GEM_DIRECTION):
	var neighbor = get_neighbors_gem(gem, direction)
	if neighbor:
		return neighbor[0]
	return null

func get_neighbors_gem(gem: Gem, direction: GEM_DIRECTION) -> Array:
	var target: Array = []
	var all_children = get_children()
	
	if direction & GEM_DIRECTION.LEFT:
		target += all_children.filter(func(g): return g.board_x == gem.board_x - 1 and g.board_y == gem.board_y)
	if direction & GEM_DIRECTION.RIGHT:
		target += all_children.filter(func(g): return g.board_x == gem.board_x + 1 and g.board_y == gem.board_y)
	if direction & GEM_DIRECTION.TOP:
		target += all_children.filter(func(g): return g.board_y == gem.board_y - 1 and g.board_x == gem.board_x)
	if direction & GEM_DIRECTION.BOTTOM:
		target += all_children.filter(func(g): return g.board_y == gem.board_y + 1 and g.board_x == gem.board_x)
		
	return target
		
func add_neighbors_to_group(gem: Gem):
	var neighbors = get_neighbors_gem(gem, GEM_DIRECTION.ALL)
	#for g in get_tree().get_nodes_in_group("gem_neighbors"):
		#g.remove_from_group("gem_neighbors")
	for g in neighbors:
		g.add_to_group("gem_neighbors")
		
func get_gem_on_position(x: int, y: int):
	return get_children().filter(func(g): return g.board_x == x and g.board_y == y)[0]

func gems_are_neighbors(gem_1: Gem, gem_2: Gem):
	return (gem_1.board_x == gem_2.board_x and abs(gem_1.board_y - gem_2.board_y) == 1) or (gem_1.board_y == gem_2.board_y and abs(gem_1.board_x - gem_2.board_x) == 1)

func swap_gems_position(gem_1: Gem, gem_2: Gem):
	var source: Vector2 = Vector2(gem_1.board_x, gem_1.board_y)
	var target: Vector2 = Vector2(gem_2.board_x, gem_2.board_y)
	gem_1.setup_gem_position_on_board(target)
	gem_2.setup_gem_position_on_board(source)

#func is_board_filled():
	#var children = get_children()
	#var cond1 = children.filter(func(g): return g.marked_to_be_deleted).is_empty()
	#var cond2 = len(children) == BOARD_SIZE ** 2
	#return cond1 and cond2

func check_for_matches():
	var gem1: Gem
	var gem2: Gem
	var gem3: Gem
	var _destroy: Gem
	var to_be_destroyed: Dictionary = {}
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE - 2):
			gem1 = get_gem_on_position(x, y)
			gem2 = get_gem_on_position(x + 1, y)
			gem3 = get_gem_on_position(x + 2, y)
			if gem1.gem_type == gem2.gem_type and gem2.gem_type == gem3.gem_type:
				for i in range(3):
					_destroy = get_gem_on_position(x + i, y)
					to_be_destroyed[str(_destroy)] = _destroy

	for y in range(BOARD_SIZE - 2):
		for x in range(BOARD_SIZE):
			gem1 = get_gem_on_position(x, y)
			gem2 = get_gem_on_position(x, y + 1)
			gem3 = get_gem_on_position(x, y + 2)
			if gem1.gem_type == gem2.gem_type and gem2.gem_type == gem3.gem_type:
				for i in range(3):
					_destroy = get_gem_on_position(x, y + i)
					to_be_destroyed[str(_destroy)] = _destroy
	
	#if to_be_destroyed.is_empty():
		#print("nothing to destroy")
	return to_be_destroyed.values()

# EVENTS
func _handle_gem_selected(gem: Gem):
	if gem.is_in_group("gem_selected"):
		# Twice clicked on same gem
		state_machine.change_to_default_state()
	else:
		var gems_selected = get_tree().get_nodes_in_group("gem_selected")
		if gems_selected.size() == 0:
			# Default state. No gems selected
			gem.add_to_group("gem_selected")
			add_neighbors_to_group(gem)
			state_machine.change_to_gem_selected_state()
		elif gems_selected.size() == 1:
			# There is already one gem selected
			if gem.is_in_group("gem_neighbors"):
				# You clicked on neighbour
				print("MOVING GEMS")
			state_machine.change_to_default_state()
			gem.add_to_group("gem_selected")
			add_neighbors_to_group(gem)
			state_machine.change_to_gem_selected_state()
#func _handle_gem_destroyed(v: Vector2):
	#if not destroyed.is_empty():
		#destroyed.erase(v)
		#if destroyed.is_empty():
			## All gems have finished transition/destruction
			#var gem_count_in_column = []
			#for column in range(BOARD_SIZE):
				#var gems_in_column = get_children().filter(func(g): return g.board_x == column and not g.marked_to_be_deleted)
				#gems_in_column.sort_custom(func(a, b): return a.board_y > b.board_y)
				#gem_count_in_column.append(gems_in_column.size())
				#if len(gems_in_column) == BOARD_SIZE:
					#continue
				#for gem_idx in range(gems_in_column.size()):
					#if gems_in_column.size() - 1 == gem_idx:
						#break
					#var current_gem: Gem = gems_in_column[gem_idx]
					#if gem_idx == 0 and current_gem.board_y != BOARD_SIZE - 1:
						#current_gem.setup_gem_position_on_board(Vector2(current_gem.board_x, BOARD_SIZE - 1), container_padding)
					#var next_gem: Gem = gems_in_column[gem_idx + 1]
					#if current_gem.board_y - next_gem.board_y > 1:
						#next_gem.setup_gem_position_on_board(Vector2(current_gem.board_x, current_gem.board_y - 1), container_padding)
			#for idx in range(gem_count_in_column.size()):
				#if gem_count_in_column[idx] == BOARD_SIZE:
					#continue
				#for i in range(BOARD_SIZE - gem_count_in_column[idx] - 1, -1, -1):
					#generate_gem_to_fill_board(Vector2(idx, i))
#
#func _handle_gem_transition_finished(_gem: Gem):
	#if revert_gems:
		#swap_gems_position(revert_gems[0], revert_gems[1])
		#revert_gems = []
	#else:
		## This "else" is triggered each time gem transitions.
		## Should be only one when all have finished
		#if not is_board_filled():
			#return
		#var matches = check_for_matches()
		#if matches.is_empty():
			#print("no matches")
			#_enable_interaction()
			#return
		#for gem_to_destroy in matches:
			#destroyed[Vector2(gem_to_destroy.board_x, gem_to_destroy.board_y)] = gem_to_destroy
			#gem_to_destroy.destroy()
		#
#func _handle_gem_selection(gem: Gem):
	#var result = get_children().filter(func(g): return g.selected)
	## Stont bugi wyszli!
	#if len(result) > 1:
		#_disable_interaction()
		#for target in result:
			#if target != gem:
				#if gems_are_neighbors(gem, target):
					#swap_gems_position(gem, target)
					#var gems_to_destroy = check_for_matches()
					#if not gems_to_destroy:
						#revert_gems.append(gem)
						#revert_gems.append(target)
				#else:
					#target.selected = false
					#_enable_interaction()
			#else:
				#target.selected = true

#func _unhandled_input(event):
	#if event is InputEventKey:
		#if event.pressed and event.keycode == KEY_Q:
			#print(get_tree().get_nodes_in_group("interaction"))

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		var gem: Gem = get_child(0)
		var space_needed = (gem.get_rect().size * BOARD_SIZE)
		var space_left = get_rect().size - space_needed
		var padding = space_left / 2
		for c in get_children():
			c.calculate_gem_position_on_scene(padding)
