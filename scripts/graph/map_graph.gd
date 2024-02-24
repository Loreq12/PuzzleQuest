@tool
extends Node
class_name MapGraph

var nodes: Dictionary = {}

func _ready():
	for child in get_children():
		if child is MapGraphNode:
			nodes[child.name.to_lower()] = child
			
func find_path(start_node: MapGraphNode, end_node: MapGraphNode) -> Array[MapGraphNode]:
	if not end_node.visible:
		return []

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

func get_edges():
	var result: Dictionary = {}
	for node in nodes.values():
		if not node.visible:
			continue
		result[node] = []
		for neighbour in node.neighbours:
			if result.has(neighbour):
				continue
			if neighbour.visible:
				result[node].append(neighbour)
		if not result[node]:
			result.erase(node)
				
	return result
