class_name FrontCanvas
extends CanvasLayer

@export var start_label: Label
@export var deliver_label: Label
@export var bg: ColorRect
@export var ending_timer: Timer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func delete_start():
	start_label.visible = false


func set_deliver(_visible: bool):
	deliver_label.visible = _visible
