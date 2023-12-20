extends Node2D

class_name GemContainer

enum GEM_DIRECTION {LEFT, RIGHT, TOP, BOTTOM}

var BOARD_SIZE = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#var random_seed: int = randi()
	var random_seed: int = 2642849264
	print(str("Seed: ", random_seed))
	seed(random_seed)
	
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE):
			var gem = preload("res://scenes/gem.tscn").instantiate()
			gem.setup_gem_color()
			gem.setup_gem_position_on_board(x, y)
			
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
			
			gem.connect("gem_selected", _handle_gem_selection)
			add_child(gem)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
	
func check_for_matches():
	var gem1: Gem
	var gem2: Gem
	var gem3: Gem
	for y in range(BOARD_SIZE):
		for x in range(BOARD_SIZE - 2):
			gem1 = get_gem_on_position(x, y)
			gem2 = get_gem_on_position(x + 1, y)
			gem3 = get_gem_on_position(x + 2, y)
			if gem1.gem_type == gem2.gem_type and gem2.gem_type == gem3.gem_type:
				for i in range(3):
					print(get_gem_on_position(x + i, y))

	for y in range(BOARD_SIZE - 2):
		for x in range(BOARD_SIZE):
			gem1 = get_gem_on_position(x, y)
			gem2 = get_gem_on_position(x, y + 1)
			gem3 = get_gem_on_position(x, y + 2)
			if gem1.gem_type == gem2.gem_type and gem2.gem_type == gem3.gem_type:
				for i in range(3):
					print(get_gem_on_position(x, y + i))

# EVENTS
func _handle_gem_selection(gem: Gem):
	var result = get_children().filter(func(g): return g.selected)
	if len(result) > 1:
		print("There is more")
		for target in result.filter(func(g): return g != gem):
			if gems_are_neighbors(gem, target):
				var source_x = gem.board_x
				var source_y = gem.board_y
				var target_x = target.board_x
				var target_y = target.board_y
				gem.setup_gem_position_on_board(target_x, target_y)
				target.setup_gem_position_on_board(source_x, source_y)
				check_for_matches()
			else:
				target.selected = false
	else:
		print("One or nothing")
	
