tool
extends NinePatchRect

var update := false


func _ready() -> void:
	assert(OK == connect("resized", self, "on_resize"))
	pass # Replace with function body.


func on_resize() -> void:
	get_child(0).get_child(0).material.set_shader_param("size", rect_size)

