extends Area2D


func _ready():
	pass

func _physics_process(delta):
	$AnimatedSprite.play("spinning")

func _on_coin_body_entered(body):
	queue_free()
