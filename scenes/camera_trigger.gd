extends Area2D

signal moved_outside(_is_up: bool)

@export var is_up: bool


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(_on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body: Node2D):
	moved_outside.emit(is_up)
