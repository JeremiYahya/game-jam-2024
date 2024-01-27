class_name Main
extends Node

@export var player: Player
@export var camera: Camera2D
@export var ui: Control
@export var respawn_timer: Timer
@export var up_trigger: Area2D
@export var down_trigger: Area2D
var jumpscare: Array[Node2D]
var player_preload = preload("res://scenes/player.tscn")
var jumpscare_preload = [
	preload("res://scenes/jumpscare_01.tscn"),
]


# Called when the node enters the scene tree for the first time.
func _ready():
	_summon_player()
	respawn_timer.timeout.connect(_summon_player)
	up_trigger.moved_outside.connect(_on_player_change_level)
	down_trigger.moved_outside.connect(_on_player_change_level)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player != null:
		camera.global_position = player.global_position + Vector2(-350, 0)
	pass


func _summon_player():
	var _player = player_preload.instantiate()
	add_child(_player)
	player = _player
	player.died.connect(_on_player_died)
	for i in jumpscare:
		i.queue_free()
	jumpscare.clear()


func _on_player_died():
	respawn_timer.start()


func _on_player_change_level(is_up: bool):
	if is_up:
		camera.limit_top = 0
		camera.limit_bottom = 0
		var _jump = jumpscare_preload[0].instantiate()
		add_child(_jump)
		jumpscare.append(_jump)
	else:
		camera.limit_top = 600
		camera.limit_bottom = 600
