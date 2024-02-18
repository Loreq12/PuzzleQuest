extends Control

class_name Gem

# SIGNALS
signal s_gem_selected(gem: Gem)
signal gem_finished_transition(gem: Gem)
signal gem_destroyed(board_position: Vector2)

# DEF
enum GEM_TYPE_E {RED, BLUE, YELLOW, GREEN}

# EXPORTS
@export var gem_type : GEM_TYPE_E
@export var board_position: Vector2i:
	get:
		return Vector2i(board_x, board_y)
	set(value):
		board_x = value.x
		board_y = value.y
##########################
@export var animation_player: AnimationPlayer
@export var gem_sprite: Sprite2D
@export var selection_sprite: Sprite2D
@export var particles: CPUParticles2D

# GLOBALS
var board_x: int
var board_y: int
var position_changed: bool = false
var marked_to_be_deleted: bool = false

func _to_string():
	return "[GEM %s: x->%d, y->%d, color->%s]" % [get_instance_id(), board_x, board_y, GEM_TYPE_E.keys()[gem_type]]

#######

func setup_gem_color():
	gem_type = GEM_TYPE_E.values()[randi() % GEM_TYPE_E.size()]
	_adjust_gem_color()

func destroy():
	marked_to_be_deleted = true
	$Sprite2D.visible = false
	$Particle.emitting = true
	#$Particle.connect("finished", queue_free)

func disable_interation():
	$Collider.set_pickable(false)

func enable_interation():
	$Collider.set_pickable(true)

func calculate_gem_position_on_scene(padding: Vector2) -> Vector2:
	# Position on board + offset from sprite center + offset from container border
	var sprite_size: Vector2 = get_rect().size
	var x = board_x * sprite_size.x
	var y = -200
	if board_y >= 0:
		y = board_y * sprite_size.y
	
	return Vector2(x, y) + padding

func _adjust_gem_color():
	if gem_type == GEM_TYPE_E.RED:
		$Sprite2D.texture = load("res://scenes/board/gem/sprites/red.png")
		$Particle.color = Color(1, 0, 0)
	elif gem_type == GEM_TYPE_E.BLUE:
		$Sprite2D.texture = load("res://scenes/board/gem/sprites/blue.png")
		$Particle.color = Color(0, 0, 1)
	elif gem_type == GEM_TYPE_E.GREEN:
		$Sprite2D.texture = load("res://scenes/board/gem/sprites/green.png")
		$Particle.color = Color(0, 1, 0)
	elif gem_type == GEM_TYPE_E.YELLOW:
		$Sprite2D.texture = load("res://scenes/board/gem/sprites/yellow.png")
		$Particle.color = Color(1, 1, 0)

# EVENTS
func _input_event_handle(_viewport, event, _shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			emit_signal("s_gem_selected", self)
