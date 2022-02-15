extends Node2D

enum {
	RANDOM,
	CUSTOM,
	CREATOR
}

var game_type := RANDOM
var age := 0

onready var timer: Timer = $Timer
# onready var ui: MarginContainer = $CanvasLayer/UI


func _ready() -> void:
	assert(OK == start_game(RANDOM))


func start_game(_type: int) -> int:
	timer.start()
	return OK


