class_name Checkpoint
extends Area2D

signal checkpoint_entered(_id: int)

@export var id: int


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: Node2D):
	checkpoint_entered.emit(id)
