class_name RatMarch
extends Enemy

@export var speed: float = 200
@export var stop_timer: Timer
var is_able_to_move: bool = false


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	_move(delta)


func _move(delta):
	if is_able_to_move:
		position -= Vector2(speed * delta, 0)
		if stop_timer.is_stopped():
			stop_timer.start()
			stop_timer.timeout.connect(_on_timeout)


func _on_timeout():
	queue_free()
