extends Node2D

class_name Gem

# SIGNALS
signal gem_selected(Gem)
signal gem_finished_transition
signal gem_destroyed(Vector2)

# DEF
enum GEM_TYPE_E {RED, BLUE, YELLOW, GREEN}

# EXPORTS
@export var gem_type : GEM_TYPE_E
@export var board_x: int
@export var board_y: int
@export var selected: bool

# GLOBALS
var position_changed: bool = false
var marked_to_be_deleted: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	position = _calculate_gem_position_on_scene()
	$Particle.connect("finished", _destroy)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if position_changed:
		var target: Vector2 = _calculate_gem_position_on_scene()
		var tween := create_tween()
		tween.tween_property(self, "position", target, .4).set_trans(Tween.TRANS_QUART)
		tween.connect("finished", _transition_after_select_is_finished)
		position_changed = false
		selected = false
	if selected:
		$AnimationPlayer.play("selected gem")
	else:
		$AnimationPlayer.stop()
	$MagicCircle.visible = selected

func _to_string():
	return str("[GEM: x-> ", board_x, ", y-> ", board_y, ", color-> ", gem_type, "]")

#######

func setup_gem_color():
	gem_type = GEM_TYPE_E.values()[randi() % GEM_TYPE_E.size()]
	_adjust_gem_color()

func setup_gem_position_on_board(x: int, y: int, init: bool = false):
	board_x = x
	board_y = y
	if not init:
		position_changed = true

func destroy():
	$Sprite2D.visible = false
	$Particle.emitting = true
	marked_to_be_deleted = true
	
func disable_interation():
	$Collider.set_pickable(false)

func enable_interation():
	$Collider.set_pickable(true)

func _calculate_gem_position_on_scene():
	# Position on board + offset from sprite center + margin
	var x = board_x * $Sprite2D.get_rect().size.x + ($Sprite2D.get_rect().size.x / 2) + board_x + ($Sprite2D.get_rect().size.x / 2 * board_x)
	var y = board_y * $Sprite2D.get_rect().size.y + ($Sprite2D.get_rect().size.y / 2) + board_y + ($Sprite2D.get_rect().size.y / 2 * board_y)
	
	return Vector2(x, y)
	
func _destroy():
	emit_signal("gem_destroyed", Vector2(board_x, board_y))
	queue_free()

func _adjust_gem_color():
	if gem_type == GEM_TYPE_E.RED:
		$Sprite2D.modulate = Color(1, 0, 0)
		$Particle.color = Color(1, 0, 0)
	elif gem_type == GEM_TYPE_E.BLUE:
		$Sprite2D.modulate = Color(0, 0, 1)
		$Particle.color = Color(0, 0, 1)
	elif gem_type == GEM_TYPE_E.GREEN:
		$Sprite2D.modulate = Color(0, 1, 0)
		$Particle.color = Color(0, 1, 0)
	elif gem_type == GEM_TYPE_E.YELLOW:
		$Sprite2D.modulate = Color(1, 1, 0)
		$Particle.color = Color(1, 1, 0)

# EVENTS
func _transition_after_select_is_finished():
	emit_signal("gem_finished_transition")

func _input_event_handle(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		#if event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			#$Particle.emitting = true
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if $AnimationPlayer.is_playing():
				selected = false
			else:
				selected = true
				emit_signal("gem_selected", self)
