extends Node2D

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
				var left_neighbor: Gem = $Gems.get_neighbor_gem(gem, GemContainer.GEM_DIRECTION.LEFT)
				if left_neighbor and left_neighbor.gem_type == gem.gem_type:
					left_neighbor = $Gems.get_neighbor_gem(left_neighbor, GemContainer.GEM_DIRECTION.LEFT)
					if left_neighbor and left_neighbor.gem_type == gem.gem_type:
						gem.setup_gem_color()
						continue
	
				var top_neighbor: Gem = $Gems.get_neighbor_gem(gem, GemContainer.GEM_DIRECTION.TOP)
				if top_neighbor and top_neighbor.gem_type == gem.gem_type:
					top_neighbor = $Gems.get_neighbor_gem(top_neighbor, GemContainer.GEM_DIRECTION.TOP)
					if top_neighbor and top_neighbor.gem_type == gem.gem_type:
						gem.setup_gem_color()
						continue
			
				break
			
			$Gems.add_child(gem)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
