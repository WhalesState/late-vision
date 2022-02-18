tool
extends NinePatchRect

export(int, 1, 1440, 1) var time = 1

onready var progress_material : ShaderMaterial = get_child(0).get_child(0).material


func _ready() -> void:
	assert(OK == connect("resized", self, "on_resize"))


func on_resize() -> void:
	progress_material.set_shader_param("size", rect_size - Vector2(12, 12))


func set_time(_time: float) -> void:
	time = _time
	progress_material.set_shader_param("time", clamp(time, 0, 1440))
