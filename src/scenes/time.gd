extends Timer

enum {
	SPRING,
	SUMMER,
	AUTUMN,
	WINTER,
	RANDOM = 0,
	CUSTOM,
	MINUTE = 0,
	HOUR,
	DAY = 0,
	MONTH,
	YEAR
}

const months := PoolIntArray([31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31])

var time := PoolByteArray([0, 0])
var date := PoolIntArray([1, 1, 1])
var season := SPRING

onready var ui: MarginContainer = $"../CanvasLayer/UI"


func _ready() -> void:
	assert(OK == connect("timeout", self, "_on_timer_timeout"))


func _on_timer_timeout() -> void:
	time[MINUTE] += 1
	if time[MINUTE] > 59:
		time[MINUTE] = 0
		time[HOUR] += 1
		if time[HOUR] > 23:	
			time[HOUR] = 0
			date[DAY] += 1
			if date[DAY] > months[date[1] - 1]:
				if (date[YEAR] % 4) + 2 == 0:
					date[MONTH] = 2
					date[DAY] += 1
				else:
					date[DAY] = 1
					date[MONTH] += 1
				if date[MONTH] > 12:
					date[MONTH] = 1
					date[YEAR] += 1
				if date[MONTH] % 3 == 0:
					season = int(date[MONTH] / 3.0)
					print(season)
			ui.set_date(date[0], date[1], date[2])
	ui.set_time(time[HOUR], time[MINUTE])


func resume_time() -> void:
	start()


func seek_time() -> void:
	pass


func pause_time() -> void:
	paused = true
	
