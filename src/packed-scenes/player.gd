extends KinematicBody2D

enum {
	#? Animations.
	IDLE = 0,
	RUN,
	#? Directions.
	DOWN = 0,
	LEFT,
	UP,
	RIGHT,
	#? Children Order.
	CAMERA = 0,
	COLLISION = 0,
	CAM_POS,
	ANIM_PLAYER,
	SPR_PLAYER,
}

const Anim := ["idle", "run"]

export(float, 10.0, 150.0, 5.0) var max_speed = 60.0
export(float, 0.05, 0.5, 0.05) var acceleration = 0.05
export(float, 0.1, 0.5, 0.05) var deacceleration = 0.15

var speed := 0.0
var cur_speed := 0.0
var axis := Vector2.ZERO
var velocity := Vector2.ZERO
var direction := Vector2.DOWN

onready var collision: CollisionShape2D = get_child(COLLISION) #$Collision
onready var cam_pos: Position2D = get_child(CAM_POS) #$CamPos
onready var cam: Camera2D = cam_pos.get_child(CAMERA) #$CamPos/Camera
onready var anim_pl: AnimationPlayer = get_child(ANIM_PLAYER) #$AnimPlayer
onready var spr_player: Sprite = get_child(SPR_PLAYER) #$SprPlayer

func _ready() -> void:
	cam_pos.set_as_toplevel(true)
	cam_pos.position = position
	cam.smoothing_enabled = true
	direction = Vector2.DOWN
	change_animation(IDLE)


func _physics_process(delta: float) -> void:
	if axis:
		var dir := axis.normalized()
		if speed < max_speed:
			speed += max_speed * acceleration
			speed = min(max_speed, speed)
		velocity = move_and_slide(dir * speed)
		cur_speed = max(abs(velocity.x), abs(velocity.y))
		cam_pos.position = cam_pos.position.linear_interpolate(position + (dir * 100.0), delta)
		if not cur_speed:
			change_animation(IDLE)
	else:
		if cam_pos.position != position:
			cam_pos.position = position
		if velocity:
			velocity -= (velocity * deacceleration)
			velocity.x = velocity.x if abs(velocity.x) > 0.1 else 0.0 
			velocity.y = velocity.y if abs(velocity.y) > 0.1 else 0.0
			velocity = move_and_slide(velocity)
			speed = max(abs(velocity.x), abs(velocity.y))
			cur_speed = speed
			anim_pl.playback_speed = max((speed / max_speed) , 0.1)
			return
		change_animation(IDLE)
		velocity = Vector2.ZERO
		speed = 0.0
		cur_speed = 0.0



func change_animation(_anim: int) -> void:
	var dir := ""
	if direction.x != 0.0:
		dir = "right" if direction.x > 0.0 else "left"
	else:
		dir = "front" if direction.y > 0.0 else "back"
	var anim := "%s-%s" % [Anim[_anim], dir]
	match _anim:
		RUN:
			anim_pl.playback_speed = 0.8
		IDLE:
			anim_pl.playback_speed = 0.7
	anim_pl.play(anim)


func _unhandled_input(event: InputEvent) -> void:
	if not event.is_action_type() or event.is_echo():
		return
	if event is InputEventMouseButton:
		return
	if not (
			event.is_action("right") or event.is_action("left") 
			or event.is_action("down") or event.is_action("up")
	):
		return
	axis.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	axis.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	if axis:
		direction = Vector2(axis.x if not axis.y else 0.0, axis.y)
		change_animation(RUN)
	get_tree().set_input_as_handled()
