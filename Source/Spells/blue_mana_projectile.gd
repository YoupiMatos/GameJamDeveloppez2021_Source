extends Projectile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position.x += speed.x * delta * direction.x
	sprite_direction()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

func sprite_direction():
	if direction.x == 1:
		rotation_degrees = 90
	elif direction.x == -1:
		rotation_degrees = -90


func _on_blue_mana_proj_body_entered(body: Node) -> void:
	queue_free()
