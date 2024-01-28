class_name Speaker
extends Enemy

@export var speed: float
@export var timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_entered)
	timer.timeout.connect(_on_timeout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += Vector2(0, speed * delta)


func _on_timeout():
	queue_free()
