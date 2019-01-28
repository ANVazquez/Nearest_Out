extends KinematicBody2D

#const will help you be able to control the flow of the game and editing making easier on me
const SPEED = 80
const GRAVITY = 13
const JUMP_PWR = -250
const FLOOR = Vector2(0, -1)
#loads the scene
const ARROW = preload("res://arrow.tscn")

var velocity = Vector2()
var grounded = false
var bowAttack = false

func _ready():
	pass

func _physics_process(delta):
	
	if Input.is_action_pressed("ui_right"):
		if bowAttack == false || is_on_floor() == false:
			velocity.x = SPEED
			if bowAttack == false:
				$AnimatedSprite.play("run")
				$AnimatedSprite.flip_h = false
				#this is to make the arrow go in the right direction
				if sign($Position2D.position.x) == -1:
					$Position2D.position.x *= -1
	elif Input.is_action_pressed("ui_left"):
		if bowAttack == false || is_on_floor() == false:
			velocity.x = -SPEED
			if bowAttack == false:
				$AnimatedSprite.play("run")
				$AnimatedSprite.flip_h = true
				#this is to make the arrow go in the left direction
				if sign($Position2D.position.x) == 1:
					$Position2D.position.x *= -1
	else:
		velocity.x = 0
		if grounded == true && bowAttack == false:
			$AnimatedSprite.play("idle")
		
	if Input.is_action_just_pressed("ui_up"):
		if bowAttack == false:
			if grounded == true:
				velocity.y = JUMP_PWR
				grounded = false
		
	if Input.is_action_just_pressed("shoot") && bowAttack == false:
		if is_on_floor():
			velocity.x = 0
		bowAttack = true
		$AnimatedSprite.play("bow_attack")
		var arrow = ARROW.instance()
		if sign($Position2D.position.x) == 1:
			arrow.direction_of_arrow(1)
		else:
			arrow.direction_of_arrow(-1)
		#this will get the stage 1 scene
		get_parent().add_child(arrow)
		arrow.position = $Position2D.global_position
	
	
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, FLOOR)
	
	if is_on_floor():
		if grounded == false:
			bowAttack = false
		grounded = true
	else:
		if bowAttack == false:
			grounded = false
			if velocity.y < 0:
				$AnimatedSprite.play("jump")
			else:
				$AnimatedSprite.play("fall")


func _on_AnimatedSprite_animation_finished():
	bowAttack = false
