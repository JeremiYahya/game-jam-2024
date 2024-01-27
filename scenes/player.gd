class_name Player
extends CharacterBody2D

signal died

const gravity = 1000
const speed = 200
const jump_force = 600

@export var ground_detector: Area2D
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
		is_jumpable = false
	
	if Input.is_action_pressed("move_left") && Input.is_action_pressed("move_right"):
		velocity.x = 0
	elif Input.is_action_pressed("move_left"):
		velocity.x = -speed
	elif Input.is_action_pressed("move_right"):
		velocity.x = speed
	else:
		velocity.x = 0
	
	move_and_slide()


func _on_ground_detector_body_entered(body: Node2D):
	if body.collision_layer == 2:
		is_jumpable = true
