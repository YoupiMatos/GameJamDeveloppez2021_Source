extends Projectile

var projectile_gravity: Vector2 = Vector2(0.0, 1000.0)

func _physics_process(delta: float) -> void:
	sprite_direction()
	position.x += speed.x * delta * direction.x
	yield(get_tree().create_timer(0.3),"timeout")
	position.y += gravity * delta
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func sprite_direction():
	if direction.x == 1:
		rotation_degrees = 90
	elif direction.x == -1:
		rotation_degrees = -90


func _on_red_mana_proj_body_entered(body: Node) -> void:
	$AnimatedSprite.play("explosion")
	set_physics_process(false)
	gravity = 0
	$projectile_collision.disabled = true
	$explosion_collison.disabled = false

func _on_AnimatedSprite_animation_finished() -> void:
	if $AnimatedSprite.animation == "explosion":
		queue_free()
