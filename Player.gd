extends KinematicBody2D

#const will help you be able to control the flow of the game and editing making easier on me
const SPEED = 80
const GRAVITY = 13
const JUMP_PWR = -250
const FLOOR = Vector2(0, -1) 

var velocity = Vector2()
var grounded = false

func _physics_process(delta):
	
	if Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
		$AnimatedSprite.flip_h = false
		$AnimatedSprite.play("run")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
		$AnimatedSprite.flip_h = true
		$AnimatedSprite.play("run")
	else:
		velocity.x = 0
		$AnimatedSprite.play("idle")
		
	if Input.is_action_pressed("ui_select"):
		if grounded == true:
			velocity.y = JUMP_PWR
			grounded = false
		
	velocity.y += GRAVITY
	
	if is_on_floor():
		grounded = true
	else:
		grounded = false
		if velocity.y < 0:
			print("jumping")
			$AnimatedSprite.play("jump")
		else:
			$AnimatedSprite.play("fall")
	
	velocity = move_and_slide(velocity, FLOOR)
	
	