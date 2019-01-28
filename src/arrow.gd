extends Area2D

const SPEED = 100

var velocity = Vector2()
var direction = 1

func _ready():
	pass

func direction_of_arrow(direct):
	direction = direct
	if direct == -1:
		$AnimatedSprite.flip_h = true

func _physics_process(delta):
	velocity.x = SPEED * delta * direction
	translate(velocity)
	$AnimatedSprite.play("arrow")

#distroys the arrow when it exits screen
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

#this is going to detect if the arrow hits a wall
func _on_arrow_body_entered(body):
	queue_free()
