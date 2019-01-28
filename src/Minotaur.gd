extends KinematicBody2D

#setting constants
const GRAVITY = 10
const SPEED = 30
const FLOOR = Vector2(0, -1)

#variables
var velocity = Vector2()
#1 represents facing right
var direction = 1

func _ready():
	pass
	
func _physics_process(delta):
	velocity.x = SPEED * direction
	
	if direction == 1:
		$AnimatedSprite.flip_h = false
	else:
		$AnimatedSprite.flip_h = true
	
	$AnimatedSprite.play("walk")
	
	velocity.y += GRAVITY
	
	velocity = move_and_slide(velocity, FLOOR)
	
	#is on wall detects if my sprite collided with a wall
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
	
		