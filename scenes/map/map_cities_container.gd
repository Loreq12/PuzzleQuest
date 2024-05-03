extends Control
class_name CityContainer

@export var current_city: MapCity
@onready var state_machine: MapStateMachine = $"../../MapStateMachine"
@onready var enemies_container: EnemyContainer = $"../Enemies"
var selected_city: MapCity = null
var city_graph := AStar2D.new()


func _ready():
	for child in get_children():
		if child is MapCity:
			city_graph.add_point(child.get_index(), child.position)
	for child in get_children():
		for neighbour in child.neighbours:
			city_graph.connect_points(child.get_index(), neighbour.get_index())

func _draw():
	var selected_path_width: int = 3
	var path: Array = []
	if selected_city:
		path = city_graph.get_point_path(current_city.get_index(), selected_city.get_index())
	for city in get_children():
		for neighbour in city.neighbours:
			if path:
				if path.has(city.position) and path.has(neighbour.position):
					selected_path_width = 6
				else:
					selected_path_width = 3
			else:
					selected_path_width = 3

			draw_line(city.position, neighbour.position, Color.BLACK, selected_path_width)

func transition_player_to_city() -> void:
	var tween := create_tween()
	tween.set_parallel(false)
	tween.set_trans(Tween.TRANS_LINEAR)

	var path = city_graph.get_point_path(current_city.get_index(), selected_city.get_index())
	var cities = city_graph.get_id_path(current_city.get_index(), selected_city.get_index())
	# Skip first one as we're already in a first city
	for i in range(1, path.size()):
		var enemy: MapEnemy = enemies_container.get_enemy_between_cities(get_child(cities[i - 1]), get_child(cities[i]))
		if enemy:
			tween.tween_property($"../Player", "position", enemy.position, 1.5)
			break
		else:
			tween.tween_property($"../Player", "position", path[i], 1.5)
		tween.tween_callback(func (): current_city = get_child(cities[i]))
	await tween.finished

func cities_are_neighbours(source: MapCity, target: MapCity) -> bool:
	var path: Array = city_graph.get_point_path(source.get_index(), target.get_index())
	return not path.is_empty()
	
func _on_city_highlight(city: MapCity):
	if city == current_city:
		return
	
	selected_city = city
	queue_redraw()

func _on_city_left():
	selected_city = null
	queue_redraw()

func _on_city_selected(city: MapCity):
	if city == current_city:
		state_machine.change_to_show_city_context_menu()
	else:
		await state_machine.change_to_city_transition()
		state_machine.change_to_default_state()
