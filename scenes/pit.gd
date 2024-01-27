class_name Pit
extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func on_body_entered(body: Node2D):
	var _player: Player = body
	if _player:
		_player.died.emit()
		_player.queue_free()
