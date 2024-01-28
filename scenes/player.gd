class_name Player
extends CharacterBody2D

signal died
signal walk
signal jump
signal idle

const gravity = 1000
const speed = 200
const jump_force = 600

@export var ground_detector: Area2D
@export var anim: AnimatedSprite2D
var is_jumpable: bool = true


# Called when the node enters the scene tree for the first time.
func _ready():
	ground_detector.body_entered.connect(_on_ground_detector_body_entered)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _physics_process(delta):
	velocity.y += delta * gravity
	
	if Input.is_action_just_pressed("jump") && is_jumpable:
		velocity.y  -= jump_force
		anim.play("jump")
		is_jumpable = false
		jump.emit()
	
	if Input.is_action_pressed("move_left") && Input.is_action_pressed("move_right"):
		velocity.x = 0
		if is_jumpable:
			anim.play("idle")
			idle.emit()
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
		anim.flip_h = true
		if is_jumpable:
			anim.play("walk")
			walk.emit()
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
		anim.flip_h = false
		if is_jumpable:
			anim.play("walk")
			walk.emit()
	else:
		velocity.x = 0
		if is_jumpable:
			anim.play("idle")
			idle.emit()
	
	move_and_slide()


func _on_ground_detector_body_entered(body: Node2D):
	if body.collision_layer == 2:
		is_jumpable = true
