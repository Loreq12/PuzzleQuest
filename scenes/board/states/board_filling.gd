extends State
class_name BoardFilling

@export var board: GemContainer

func Enter():
	await board.fill_board_after_gems_destroyed()
	board.check_for_matches()
