extends MarginContainer

onready var date_label: Button = $VBox/HBox/HBox/VBox/Date
onready var time_label: Button = $VBox/HBox/HBox/VBox/Time
onready var day_progress: NinePatchRect = $VBox/HBox/HBox/VBox/DayProgress


func _ready() -> void:
	OS.min_window_size = Vector2( 960, 640 )


func set_time(h: int, m: int) -> void:
	day_progress.set_time( (h * 60) + m )
	time_label.text = "%s:%s" % [
			str( h ).pad_zeros( 2 ),
			str( m ).pad_zeros( 2 )
	]


func set_date(d: int, m: int, y: int) -> void:
	date_label.text = "%s/%s/%s" % [
			str( d ).pad_zeros( 2 ),
			str( m ).pad_zeros( 2 ),
			str( y ).pad_zeros( 4 )
	]
