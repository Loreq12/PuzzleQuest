extends State
class_name BoardFilling

@export var board: GemContainer

func Enter():
	board.fill_board_after_gems_destroyed()
