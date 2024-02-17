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
var padding: Vector2 = Vector2.ZERO

@onready var state_machine: BoardStateMachine = $"../../StateMachine"

func _prepare_gem(v: Vector2i):
	var gem = preload("res://scenes/board/gem/gem.tscn").instantiate()
	gem.board_position = v
	gem.setup_gem_color()
	gem.add_to_group("interaction")
	gem.connect("s_gem_selected", _handle_gem_selected)
	
	return gem

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#var random_seed: int = randi()
	var random_seed: int = 2642849264
	print("Seed: %d" % random_seed)
	seed(random_seed)
	
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
	for g in neighbors:
		g.add_to_group("gem_neighbors")
		
func get_gem_on_position(x: int, y: int):
	return get_children().filter(func(g): return g.board_x == x and g.board_y == y)[0]

func cleanup_filling():
	for g in get_tree().get_nodes_in_group("board_filling"):
		g.remove_from_group("board_filling")

func fill_board_after_gems_destroyed():
	var gem_count_in_column = []
	var tween := create_tween()
	tween.set_parallel(true)
	tween.set_trans(Tween.TRANS_QUART)

	for column in range(BOARD_SIZE):
		var gems_in_column = get_children().filter(func(g): return g.board_x == column and not g.marked_to_be_deleted)
		gems_in_column.sort_custom(func(a, b): return a.board_y > b.board_y)
		gem_count_in_column.append(gems_in_column.size())
		if gems_in_column.size() == BOARD_SIZE:
			continue
		for gem_idx in range(gems_in_column.size()):
			if gems_in_column.size() - 1 == gem_idx:
				break
			var current_gem: Gem = gems_in_column[gem_idx]
			if gem_idx == 0 and current_gem.board_y != BOARD_SIZE - 1:
				current_gem.add_to_group("board_filling")
				current_gem.board_position = Vector2i(current_gem.board_x, BOARD_SIZE - 1)
				var new_position = current_gem.calculate_gem_position_on_scene(padding)
				tween.tween_property(current_gem, "position", new_position, .5)
			var next_gem: Gem = gems_in_column[gem_idx + 1]
			if current_gem.board_y - next_gem.board_y > 1:
				next_gem.add_to_group("board_filling")
				next_gem.board_position = Vector2i(current_gem.board_x, current_gem.board_y - 1)
				var new_position = next_gem.calculate_gem_position_on_scene(padding)
				tween.tween_property(next_gem, "position", new_position, .5)
	
	for idx in range(gem_count_in_column.size()):
		if gem_count_in_column[idx] == BOARD_SIZE:
			continue
		for i in range(BOARD_SIZE - gem_count_in_column[idx] - 1, -1, -1):
			var gem: Gem = _prepare_gem(Vector2i(idx, -1))
			gem.add_to_group("board_filling")
			gem.position = gem.calculate_gem_position_on_scene(padding)
			add_child(gem)
			gem.board_position = Vector2i(idx, i)
			var new_position = gem.calculate_gem_position_on_scene(padding)
			tween.tween_property(gem, "position", new_position, .5)
	
	await tween.finished
	cleanup_filling()

func check_for_matches():
	var gem1: Gem
	var gem2: Gem
	var gem3: Gem
	var _destroy: Gem
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE - 2):
			gem1 = get_gem_on_position(x, y)
			gem2 = get_gem_on_position(x + 1, y)
			gem3 = get_gem_on_position(x + 2, y)
			if gem1.gem_type == gem2.gem_type and gem2.gem_type == gem3.gem_type:
				for i in range(3):
					_destroy = get_gem_on_position(x + i, y)
					_destroy.add_to_group("gem_destroy")

	for y in range(BOARD_SIZE - 2):
		for x in range(BOARD_SIZE):
			gem1 = get_gem_on_position(x, y)
			gem2 = get_gem_on_position(x, y + 1)
			gem3 = get_gem_on_position(x, y + 2)
			if gem1.gem_type == gem2.gem_type and gem2.gem_type == gem3.gem_type:
				for i in range(3):
					_destroy = get_gem_on_position(x, y + i)
					_destroy.add_to_group("gem_destroy")

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
				gem.add_to_group("gem_selected")
				# You clicked on neighbour
				await state_machine.change_to_gem_transition_state()
				if not get_tree().get_nodes_in_group("gem_destroy"):
					await state_machine.change_to_gem_revert_state()
					state_machine.change_to_default_state()
					return
				while true:
					if get_tree().get_nodes_in_group("gem_destroy"):
						await state_machine.change_to_gem_destroy_state()
						await state_machine.change_to_board_filling_state()
					else:
						state_machine.change_to_default_state()
						return
			else:
				# You clicked ouside of neighbourhood
				state_machine.change_to_default_state()
				gem.add_to_group("gem_selected")
				add_neighbors_to_group(gem)
				state_machine.change_to_gem_selected_state()

func _notification(what):
	if what == NOTIFICATION_SORT_CHILDREN:
		var gem: Gem = get_child(0)
		var space_needed = (gem.get_rect().size * BOARD_SIZE)
		var space_left = get_rect().size - space_needed
		padding = space_left / 2
		for c in get_children():
			if c.is_in_group("board_filling"):
				continue
			var gem_position: Vector2 = c.calculate_gem_position_on_scene(padding)
			c.position = gem_position
