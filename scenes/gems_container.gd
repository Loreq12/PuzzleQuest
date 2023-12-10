extends Node2D

class_name GemContainer

enum GEM_DIRECTION {LEFT, RIGHT, TOP, BOTTOM}

var BOARD_WIDTH = 8
var BOARD_HEIGHT = 8

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	#var random_seed: int = randi()
	var random_seed: int = 2642849264
	print(str("Seed: ", random_seed))
	seed(random_seed)
	
	for y in range(BOARD_HEIGHT):
		for x in range(BOARD_WIDTH):
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

# EVENTS
func _handle_gem_selection(gem: Gem):
	var result = get_children().filter(func(g): return g.selected)
	if len(result) > 1:
		print("There is more")
		for target in result.filter(func(g): return g != gem):
			target.selected = false
			print(target)
	else:
		print("One or nothing")
	
