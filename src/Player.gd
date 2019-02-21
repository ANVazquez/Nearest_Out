extends KinematicBody2D


#const will help you be able to control the flow of the game and editing making easier on me
const SPEED = 80
const GRAVITY = 13
const JUMP_PWR = -300
const FLOOR = Vector2(0, -1)
#loads the scene so i can use it for arrow
const ARROW = preload("res://arrow.tscn")

var velocity = Vector2()
var grounded = false
var bowAttack = false
var jmp_cnt = 0
var score = 0
var dead = false

func _ready():
	pass

func _physics_process(delta):
	
	if dead == false:
		if Input.is_action_pressed("ui_right"):
			#yes you want the button to be pressed but you have to check to see if you are on the floor
			#and check to see if you are attacking. Once you check and they are both false then you 
			#can attack
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
			#if you aren't doing anything then you can idle
			velocity.x = 0
			if grounded == true && bowAttack == false:
				$AnimatedSprite.play("idle")
			
		if Input.is_action_just_pressed("ui_select"):
			#this checks to see if you aren't attacking and if you are on ground because
			#if you are attacking it will cancel out of the jump animation
			if bowAttack == false:
	#			if grounded == true:
	#				velocity.y = JUMP_PWR
	#				grounded = false
				if jmp_cnt < 2:
					jmp_cnt+=1
					velocity.y = JUMP_PWR
					grounded = false
		
		#if you click the shoot button(F) and attack is false then you want to shoot and make bowAttack 
		#equal to true so you can only shoot when the animation is done
		if Input.is_action_just_pressed("shoot") && bowAttack == false:
			if is_on_floor():
				velocity.x = 0
			bowAttack = true
			$AnimatedSprite.play("bow_attack")
			var arrow = ARROW.instance()
			#flips the arrows position
			if sign($Position2D.position.x) == 1:
				arrow.direction_of_arrow(1)
			else:
				arrow.direction_of_arrow(-1)
			#this will get the stage 1 scene
			get_parent().add_child(arrow)
			arrow.position = $Position2D.global_position
		
		
		velocity.y += GRAVITY
		
		velocity = move_and_slide(velocity, FLOOR)
		
		#this is if the player runs into the enemies
		if get_slide_count() > 0:
			for x in range(get_slide_count()):
				#if I collide with the enemy then it will play the dead function
				if "Minotaur" in get_slide_collision(x).collider.name || "grey" in get_slide_collision(x).collider.name:
					died()
		#if the score reaches this amount it will go to Winner screen
		if score >= 2:
			win_game()
	
	#if player is on the floor and grounded is false then bowAttack is false because you are not on the ground to shoot
	#but if you are on the ground and bowAttack is false then check if you are up in the air
	if is_on_floor():
		if grounded == false:
			bowAttack = false
		grounded = true
		jmp_cnt = 0
	else:
		if bowAttack == false:
			grounded = false
			if velocity.y < 0:
				$AnimatedSprite.play("jump")
			else:
				$AnimatedSprite.play("fall")
	
	#adding to the score count on screen
	var counter = get_parent().get_node("CanvasLayer/Control/RichTextLabel")
	counter.text = str(score)

func _on_AnimatedSprite_animation_finished():
	bowAttack = false

#func delay():
#	for i in range (20):
#		i

func _on_coin_body_entered(body):
	score += 1
	print(score)

func died():
	dead = true
	velocity = Vector2(0,0)
	$AnimatedSprite.play("dying")
	$CollisionShape2D.disabled = true
	$Timer.start()

func _on_Timer_timeout():
	get_tree().change_scene("GameOver.tscn")

func win_game():
	get_tree().change_scene("Winner.tscn")
