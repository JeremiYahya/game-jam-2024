class_name Bird
extends Enemy

@export var speed: float
@export var timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	body_entered.connect(on_body_entered)
	timer.timeout.connect(_on_timeoout)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position -= Vector2(speed * delta, 0)


func _on_timeoout():
	queue_free()
