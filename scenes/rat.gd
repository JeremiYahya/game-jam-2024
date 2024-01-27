class_name Rat
extends Enemy

@export var speed: float
@export var patrol_timer: Timer
@export var stop_timer: Timer
@export var is_moving_right: bool



func _ready():
	body_entered.connect(on_body_entered)
	patrol_timer.timeout.connect(_stop)
	stop_timer.timeout.connect(_patrol)


	# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !patrol_timer.is_stopped():
		_move(delta)


func _move(delta):
	var i = 1 if is_moving_right else -1
	position += Vector2(i * speed * delta, 0)


func _stop():
	stop_timer.start()


func _patrol():
	is_moving_right = !is_moving_right
	patrol_timer.start()
