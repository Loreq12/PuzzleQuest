@tool
extends Node
class_name MapGraphNode

@export var neighbours: Array[MapGraphNode] = []
@export var position: Vector2i
@export var visible: bool
