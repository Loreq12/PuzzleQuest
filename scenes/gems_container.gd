extends Node2D

class_name GemContainer

enum GEM_DIRECTION {LEFT, RIGHT, TOP, BOTTOM}

var BOARD_SIZE = 8

var revert_gems = []
var destroyed = {}

func _prepare_gem(v: Vector2):
	var gem = preload("res://scenes/gem.tscn").instantiate()
	gem.setup_gem_color()
	gem.setup_gem_position_on_board(v.x, v.y, true)
	gem.connect("gem_finished_transition", _handle_gem_transition_finished)
	gem.connect("gem_selected", _handle_gem_selection)
	gem.connect("gem_destroyed", _handle_gem_destroyed)
	
	return gem

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#var random_seed: int = randi()
	var random_seed: int = 2642849264
	print(str("Seed: ", random_seed))
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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
	#var qq = get_children().filter(func(g): return g.board_x == 6)
	#print("tst")

func generate_gem_to_fill_board(board_x: int, board_y: int):
	var gem = _prepare_gem(Vector2(board_x, -1))
	add_child(gem)
	gem.setup_gem_position_on_board(board_x, board_y)

func get_neighbor_gem(gem: Gem, direction: GEM_DIRECTION):
	var target: Array
	
	if direction == GEM_DIRECTION.LEFT:
		target = get_children().filter(func(g): return g.board_x == gem.board_x - 1 and g.board_y == gem.board_y)
	elif direction == GEM_DIRECTION.RIGHT:
		target = get_children().filter(func(g): return g.board_x == gem.board_x + 1 and g.board_y == gem.board_y)
	elif direction == GEM_DIRECTION.TOP:
		target = get_children().filter(func(g): return g.board_y == gem.board_y - 1 and g.board_x == gem.board_x)
	elif direction == GEM_DIRECTION.BOTTOM:
		target = get_children().filter(func(g): return g.board_y == gem.board_y + 1 and g.board_x == gem.board_x)
		
	if target:
		return target[0]
	else:
		return null
		
func get_gem_on_position(x: int, y: int):
	return get_children().filter(func(g): return g.board_x == x and g.board_y == y)[0]

func gems_are_neighbors(gem_1: Gem, gem_2: Gem):
	return (gem_1.board_x == gem_2.board_x and abs(gem_1.board_y - gem_2.board_y) == 1) or (gem_1.board_y == gem_2.board_y and abs(gem_1.board_x - gem_2.board_x) == 1)

func swap_gems_position(gem_1: Gem, gem_2: Gem):
	var source_x = gem_1.board_x
	var source_y = gem_1.board_y
	var target_x = gem_2.board_x
	var target_y = gem_2.board_y
	gem_1.setup_gem_position_on_board(target_x, target_y)
	gem_2.setup_gem_position_on_board(source_x, source_y)

func is_board_filled():
	var children = get_children()
	var cond1 = children.filter(func(g): return g.marked_to_be_deleted).is_empty()
	var cond2 = len(children) == BOARD_SIZE ** 2
	return cond1 and cond2

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
	
	return to_be_destroyed.values()

# EVENTS
func _handle_gem_destroyed(v: Vector2):
	if not destroyed.is_empty():
		destroyed.erase(v)
		if destroyed.is_empty():
			# All gems have finished transition/destruction
			var gem_count_in_column = []
			for column in range(BOARD_SIZE):
				var gems_in_column = get_children().filter(func(g): return g.board_x == column and not g.marked_to_be_deleted)
				gems_in_column.sort_custom(func(a, b): return a.board_y > b.board_y)
				gem_count_in_column.append(gems_in_column.size())
				if len(gems_in_column) == BOARD_SIZE:
					continue
				for gem_idx in range(gems_in_column.size()):
					if gems_in_column.size() - 1 == gem_idx:
						break
					var current_gem: Gem = gems_in_column[gem_idx]
					if gem_idx == 0 and current_gem.board_y != BOARD_SIZE - 1:
						current_gem.setup_gem_position_on_board(current_gem.board_x, BOARD_SIZE - 1)
					var next_gem: Gem = gems_in_column[gem_idx + 1]
					if current_gem.board_y - next_gem.board_y > 1:
						next_gem.setup_gem_position_on_board(current_gem.board_x, current_gem.board_y - 1)
			for idx in range(gem_count_in_column.size()):
				if gem_count_in_column[idx] == BOARD_SIZE:
					continue
				for i in range(BOARD_SIZE - gem_count_in_column[idx] - 1, -1, -1):
					generate_gem_to_fill_board(idx, i)

func _handle_gem_transition_finished():
	if revert_gems:
		swap_gems_position(revert_gems[0], revert_gems[1])
		revert_gems = []
	else:
		if not is_board_filled():
			return
		var matches = check_for_matches()
		for gem_to_destroy in matches:
			destroyed[Vector2(gem_to_destroy.board_x, gem_to_destroy.board_y)] = gem_to_destroy
			gem_to_destroy.destroy()
		
func _handle_gem_selection(gem: Gem):
	var result = get_children().filter(func(g): return g.selected)
	if len(result) > 1:
		for target in result.filter(func(g): return g != gem):
			if gems_are_neighbors(gem, target):
				swap_gems_position(gem, target)
				var gems_to_destroy = check_for_matches()
				if not gems_to_destroy:
					revert_gems.append(gem)
					revert_gems.append(target)
			else:
				target.selected = false
