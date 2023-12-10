extends Node2D

class_name Gem

var tween: Tween

# SIGNALS
signal gem_selected(gem)

# DEF
enum GEM_TYPE_E {RED, BLUE, YELLOW, GREEN}

# EXPORTS
@export var gem_type : GEM_TYPE_E
@export var board_x: int
@export var board_y: int

# Called when the node enters the scene tree for the first time.
func _ready():
	tween = create_tween()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position = _calculate_gem_position_on_scene()

func _to_string():
	return str("[GEM: x-> ", board_x, ", y-> ", board_y, ", color-> ", gem_type, "]")

#######

func setup_gem_color():
	gem_type = GEM_TYPE_E.values()[randi() % GEM_TYPE_E.size()]
	_adjust_gem_color()


func setup_gem_position_on_board(x: int, y: int):
	board_x = x
	board_y = y


func _calculate_gem_position_on_scene():
	# Position on board + offset from sprite center + margin
	var x = board_x * $Sprite2D.get_rect().size.x + ($Sprite2D.get_rect().size.x / 2) + board_x + ($Sprite2D.get_rect().size.x / 2 * board_x)
	var y = board_y * $Sprite2D.get_rect().size.y + ($Sprite2D.get_rect().size.y / 2) + board_y + ($Sprite2D.get_rect().size.y / 2 * board_y)
	
	return Vector2(x, y)
	

func _adjust_gem_color():
	if gem_type == GEM_TYPE_E.RED:
		$Sprite2D.modulate = Color(1, 0, 0)
	elif gem_type == GEM_TYPE_E.BLUE:
		pass
	elif gem_type == GEM_TYPE_E.GREEN:
		$Sprite2D.modulate = Color(0, 1, 0)
	elif gem_type == GEM_TYPE_E.YELLOW:
		$Sprite2D.modulate = Color(1, 1, 0)


# EVENTS
func _input_event_handle(viewport, event, shape_idx):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if $AnimationPlayer.is_playing():
				$MagicCircle.visible = false
				$AnimationPlayer.stop()
			else:
				$MagicCircle.visible = true
				$AnimationPlayer.play("selected gem")
