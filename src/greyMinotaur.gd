extends KinematicBody2D

#setting constants
const GRAVITY = 10
const FLOOR = Vector2(0, -1)
#exports give you a chance to edit each spirte you have on screen in the inspector
export (int) var speed = 30
export (int) var hp = 10
#variables
var velocity = Vector2()
#1 represents facing right
var direction = 1
var died = false
var gotHit = false

func _ready():
	pass
	
func _physics_process(delta):
	if died == false && gotHit == false:
		velocity.x = speed * direction
		
		if direction == 1:
			$AnimatedSprite.flip_h = false
		else:
			$AnimatedSprite.flip_h = true
		
		$AnimatedSprite.play("walking")
		
		velocity.y += GRAVITY
		
		velocity = move_and_slide(velocity, FLOOR)
	
	#is on wall detects if my sprite collided with a wall
	if is_on_wall():
		direction = direction * -1
		$RayCast2D.position.x *= -1
	
	if $RayCast2D.is_colliding() == false:
		direction = direction * -1
		$RayCast2D.position.x *= -1
		
	if get_slide_count() > 0:
		for x in range(get_slide_count()):
			if "Player" in get_slide_collision(x).collider.name:
				get_slide_collision(x).collider.died()
		
func dead():
	gotHit = true
	if gotHit == true:
		hp -= 10
		$AnimatedSprite.play("hit")
		velocity = Vector2(0,0)
		speed += 50
		$Timer2.start()
	if hp <= 0:
		died = true
		velocity = Vector2(0,0)
		$AnimatedSprite.play("dying")
		$CollisionShape2D.disabled = true
		$Timer.start()
	

func _on_Timer_timeout():
	queue_free()


func _on_Timer2_timeout():
	gotHit = false
