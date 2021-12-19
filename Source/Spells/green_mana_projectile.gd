extends Projectile

signal teleport

func _physics_process(delta: float) -> void:
	sprite_direction()
	position.x += speed.x * delta * direction.x
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func sprite_direction():
	if direction.x == 1:
		rotation_degrees = 90
	elif direction.x == -1:
		rotation_degrees = -90


func _on_green_mana_proj_body_entered(body: Node) -> void:
	emit_signal("teleport")
	queue_free()
