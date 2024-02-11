extends State
class_name GemTransitioned

@export var gem: Gem
@export var target_transition: Vector2

func Enter():
	print("In the middle of transition")
	var tween := create_tween()
	tween.tween_property(gem, "position", target_transition, .4).set_trans(Tween.TRANS_QUART)
	#tween.connect("finished", _transition_after_select_is_finished)
	#position_changed = false
