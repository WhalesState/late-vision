tool
extends Node2D

export(bool) var rotate_light = false setget set_rotate_light
export(int, 0, 100, 10) var distance = 40
export(float, 1.0, 4.0, 0.1) var speed = 2.0
export(float, 0.5, 4.0, 0.5) var light_scale = 2.0 setget set_light_scale

var time := 0.0


func _ready() -> void:
	$Light2D.position = Vector2.ZERO
	set_physics_process(rotate_light)


func _physics_process(delta: float) -> void:
	run_light(delta)


func run_light(_delta: float) -> void:
	if not $Light2D:
		return
	time += _delta
	if time >= (PI * distance):
		time = 0.0
	$Light2D.position = Vector2(sin(time * speed) * distance, cos(time * speed) * distance)


func set_rotate_light(_rotate: bool) -> void:
	rotate_light = _rotate
	set_physics_process(rotate_light)
	if not _rotate:
		$Light2D.position = Vector2.ZERO


func set_light_scale(_scale: float) -> void:
	if not $Light2D:
		return
	light_scale = _scale
	$Light2D.texture_scale = light_scale
