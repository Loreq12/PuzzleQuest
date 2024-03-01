extends State
class_name MapCityContextMenu

@export var cities: CityContainer

func Enter():
	cities.current_city.show_context_menu()

func Exit():
	cities.current_city.hide_context_menu()	
