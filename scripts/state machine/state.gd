extends Node
class_name State

func Enter():
	pass
	
func Exit():
	pass 

func _to_string():
	return str("[State: name->", self.name.to_lower(), "]")
