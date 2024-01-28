class_name Main
extends Node

@export var player: Player
@export var front_canvas: FrontCanvas
@export var camera: Camera2D
@export var ui: Control
@export var respawn_timer: Timer
@export var up_trigger: Area2D
@export var up_trigger_2: Area2D
@export var down_trigger: Area2D
@export var down_trigger_2: Area2D
@export var down_trigger_3: Area2D
@export var bridge_trigger: Area2D
@export var checkpoint: Array[Area2D]
@export var fake_bridge: RigidBody2D
@export var start_audio: AudioStreamPlayer
@export var walk_audio: AudioStreamPlayer
@export var jump_audio: AudioStreamPlayer
@export var death_audio: Array[AudioStreamPlayer]
@export var bird_audio: AudioStreamPlayer
@export var rats_audio: AudioStreamPlayer
@export var speaker_fall_audio: AudioStreamPlayer
@export var speaker_hit_audio: AudioStreamPlayer
@export var bad_end_area: Area2D
@export var is_checkpoint: Array[bool] = [false, false]

var first_time: bool = true
var is_bad_end: bool = false
var is_ending_shows: bool = false
var is_camera_move: bool = false
var jumpscare: Array[Node2D]
var rat_march: Array[RatMarch]
var bird_trigger: Area2D
var rat_trigger: Area2D
var sound_fall_trigger: Area2D
var player_preload = preload("res://scenes/player.tscn")
var fake_bridge_preload = preload("res://scenes/fake_bridge.tscn")
var bird_trigger_preload = preload("res://scenes/bird_trigger.tscn")
var bird_preload = preload("res://scenes/bird.tscn")
var rat_trigger_preload = preload("res://scenes/rat_trigger.tscn")
var sound_fall_preload = preload("res://scenes/sound_fall_trigger.tscn")
var speaker_preload = preload("res://scenes/speaker.tscn")

var jumpscare_preload = [
	preload("res://scenes/jumpscare_01.tscn"),
]
var rat_march_preload = [
	preload("res://scenes/rat_march/rat_2.tscn"),
	preload("res://scenes/rat_march/rat_3.tscn"),
	preload("res://scenes/rat_march/rat_4.tscn"),
	preload("res://scenes/rat_march/rat_5.tscn"),
	preload("res://scenes/rat_march/rat_6.tscn"),
	preload("res://scenes/rat_march/rat_7.tscn"),
	preload("res://scenes/rat_march/rat_8.tscn"),
	preload("res://scenes/rat_march/rat_9.tscn"),
]


# Called when the node enters the scene tree for the first time.
func _ready():
	respawn_timer.timeout.connect(_summon_player)
	up_trigger.moved_outside.connect(_on_player_change_level)
	up_trigger_2.moved_outside.connect(_on_player_change_level)
	down_trigger.moved_outside.connect(_on_player_change_level)
	down_trigger_2.moved_outside.connect(_on_player_change_level)
	down_trigger_3.moved_outside.connect(_on_player_change_level)
	checkpoint[0].checkpoint_entered.connect(_on_checkpoint_reached)
	checkpoint[1].checkpoint_entered.connect(_on_checkpoint_reached)
	bridge_trigger.body_entered.connect(_on_bridge_detect_player)
	bad_end_area.body_entered.connect(_on_bad_end_arrive)
	bad_end_area.body_exited.connect(_on_bad_end_exit)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		camera.global_position = player.global_position + Vector2(-350, 0)
	elif is_camera_move:
		camera.global_position += Vector2(300 * delta, 0)
	if Input.is_action_just_pressed("action"):
		if first_time:
			first_time = false
			_summon_player()
			front_canvas.delete_start()
			start_audio.play()
		if is_bad_end && player != null:
			_on_bad_end_enter()
		if is_ending_shows:
			get_tree().reload_current_scene()


func _summon_player():
	var _player = player_preload.instantiate()
	add_child(_player)
	player = _player
	if fake_bridge == null:
		var _fake_bridge = fake_bridge_preload.instantiate()
		add_child(_fake_bridge)
		fake_bridge = _fake_bridge
	if bird_trigger == null:
		var _bird = bird_trigger_preload.instantiate()
		add_child(_bird)
		bird_trigger = _bird
		bird_trigger.body_entered.connect(_on_bird_trigger)
	for i in rat_march:
		if i != null:
			i.queue_free()
	rat_march.clear()
	for i in rat_march_preload.size():
		var _rat = rat_march_preload[i].instantiate()
		add_child(_rat)
		rat_march.append(_rat)
	if rat_trigger == null:
		var _trigger = rat_trigger_preload.instantiate()
		add_child(_trigger)
		rat_trigger = _trigger
		rat_trigger.body_entered.connect(_on_rat_marching)
	if sound_fall_trigger != null:
		sound_fall_trigger.queue_free()
	if is_checkpoint[1]:
		player.position = Vector2(3400, 0)
		camera.limit_top = 0
		camera.limit_bottom = 0
	elif is_checkpoint[0]:
		player.position = Vector2(2000, 0)
		camera.limit_top = 0
		camera.limit_bottom = 0
	else:
		player.position = Vector2(235, 580)
		camera.limit_top = 600
		camera.limit_bottom = 600
	player.died.connect(_on_player_died)
	player.walk.connect(_on_player_walk)
	player.jump.connect(_on_player_jump)
	player.idle.connect(_on_player_idle)
	for i in jumpscare:
		if i != null:
			i.queue_free()
	jumpscare.clear()
	if rats_audio.playing:
		rats_audio.stop()


func _on_player_died():
	walk_audio.stop()
	if !_is_death_playing():
		var _random = randf()
		if _random <= 0.33:
			death_audio[0].play()
		elif _random <= 0.66:
			death_audio[1].play()
		else:
			death_audio[2].play()
	respawn_timer.start()


func _on_player_change_level(is_up: bool):
	if is_up:
		camera.limit_top = 0
		camera.limit_bottom = 0
		if jumpscare.size() == 0:
			var _jump = jumpscare_preload[0].instantiate()
			add_child(_jump)
			jumpscare.append(_jump)
	else:
		camera.limit_top = 600
		camera.limit_bottom = 600


func _on_player_walk():
	if !walk_audio.playing && !_is_death_playing():
		walk_audio.play()


func _on_player_idle():
	walk_audio.stop()


func _on_player_jump():
	walk_audio.stop()
	jump_audio.play()


func _on_checkpoint_reached(id: int):
	is_checkpoint[id] = true


func _on_bridge_detect_player(body: Node2D):
	var _player: Player = body
	if _player != null && fake_bridge != null:
		fake_bridge.queue_free()


func _on_bird_trigger(body: Node2D):
	var _player: Player = body
	if _player != null:
		var _bird = bird_preload.instantiate()
		add_child(_bird)
		bird_audio.play()
	bird_trigger.queue_free()


func _on_rat_marching(body: Node2D):
	var _player: Player = body
	if _player != null:
		for i in rat_march:
			i.is_able_to_move = true
			rats_audio.play()
	var _sound = sound_fall_preload.instantiate()
	add_child(_sound)
	rat_trigger.queue_free()
	sound_fall_trigger = _sound
	sound_fall_trigger.body_entered.connect(_on_sound_drop)


func _on_sound_drop(body: Node2D):
	var _player: Player = body
	if _player != null:
		var _speaker = speaker_preload.instantiate()
		add_child(_speaker)
		_speaker.hit.connect(_on_speaker_hit)
		sound_fall_trigger.queue_free()
		speaker_fall_audio.play()


func _on_bad_end_arrive(body: Node2D):
	var _player: Player = body
	if _player != null:
		front_canvas.set_deliver(true)
		is_bad_end = true


func _on_bad_end_exit(body: Node2D):
	var _player: Player = body
	if _player != null:
		front_canvas.set_deliver(false)
		is_bad_end = false


func _on_bad_end_enter():
	front_canvas.set_deliver(false)
	player.queue_free()
	front_canvas.camera_timer.start()
	front_canvas.camera_timer.timeout.connect(_move_camera)


func _move_camera():
	camera.limit_right = 7200
	is_camera_move = true
	front_canvas.ending_timer.start()
	front_canvas.ending_timer.timeout.connect(_show_bad_end)


func _show_bad_end():
	front_canvas.bg.visible = true
	is_ending_shows = true


func _on_speaker_hit():
	speaker_hit_audio.play()


func _is_death_playing():
	return death_audio[0].playing || death_audio[1].playing || death_audio[2].playing
