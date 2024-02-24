@tool
extends Node
class_name MapGraph

var nodes: Dictionary = {}

func _ready():
	print("kkrwa")
	for child in get_children():
		if child is MapGraphNode:
			nodes[child.name.to_lower()] = child
			
	print(find_path($Bartonia, $Bartonia4))

func find_path(start_node: MapGraphNode, end_node: MapGraphNode) -> Array[MapGraphNode]:
	var visited = []
	var queue = []
	queue.append([start_node])

	while queue.size():
		var path = queue.pop_front()
		var current_node = path[-1]

		if not visited.has(current_node):
			var node: MapGraphNode = nodes.get(current_node.name.to_lower())
			var neighbors: Array
			if node:
				neighbors = node.neighbours
			else:
				neighbors = []

			for neighbor in neighbors:
				var new_path = path.duplicate()
				new_path.append(neighbor)
				queue.append(new_path)
				if neighbor == end_node:
					return new_path
			visited.append(current_node)
	return []
