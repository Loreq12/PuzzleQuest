extends State
class_name GemDefault

# for now nothing is required as this is base state
func Enter():
	for gem in get_tree().get_nodes_in_group("gem_neighbors"):
		gem.remove_from_group("gem_neighbors")
