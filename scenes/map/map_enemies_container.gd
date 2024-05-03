extends Control
class_name EnemyContainer

var spawn_points: Dictionary = {}
var enemies_coverage: float = 0.25

func _ready():
	for city in $"../Cities".get_children():
		if city is MapCity:
			for neighbour in city.neighbours:
				var spawn_point: Vector2 = city.position.lerp(neighbour.position, 0.5)
				spawn_points[spawn_point] = null
				
	spawn_enemies()
	
func spawn_enemies():
	var enemies_positions = spawn_points.keys()
	enemies_positions.shuffle()
	var how_many_enemies = int(len(enemies_positions) * enemies_coverage)
	
	for i in range(how_many_enemies):
		var spawn_vector: Vector2 = enemies_positions[i]
		var enemy: MapEnemy = preload("res://scenes/map/enemy.tscn").instantiate()
		enemy.position = spawn_vector
		add_child(enemy)

func _process(delta):
	pass

func _on_enemy_spawner_timeout():
	# Get current list of deployed enemies and check agains possible positions
	var enemies_positions: Array = get_children().map(func(c: MapCity): return c.position)
	var enemies_possible_positions = spawn_points.keys()
	enemies_possible_positions.shuffle()
	var spawn_vector: Vector2
	for p in enemies_possible_positions:
		# picking position which is not already used
		if enemies_positions.has(p):
			continue
		spawn_vector = p
		break
	var random_enemy: MapEnemy = get_children().pick_random()
	random_enemy.destroy()

	var enemy: MapEnemy = preload("res://scenes/map/enemy.tscn").instantiate()
	enemy.position = spawn_vector
	add_child(enemy)
	enemy.spawn()
