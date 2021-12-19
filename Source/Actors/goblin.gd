extends Actor

onready var anim_player = $AnimationPlayer
onready var char_sprite = $Sprite
onready var melee_sprite = $Area2D/melee_sprite
onready var melee_hitbox = $Area2D/melee_hitbox

var player
var direction: int 


func _ready() -> void:
	player = get_node("/root/Node2D/TileMap/player")


func _physics_process(delta: float) -> void:
	var dir = (player.global_position -global_position).normalized()
	direction = get_direction()
	_velocity = calculate_move_velocity(_velocity, dir, speed)
	move_and_slide(_velocity, Vector2.UP)
	sprite_mode(direction)
	die()
	
func get_direction() -> int:
	if _velocity.x < 0:
		return -1
	elif _velocity.x > 0:
		return 1
	else:
		return 0

func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	return out

func sprite_mode(direction: int) -> void:
	if direction == 1 and !is_attacking_or_getting_hit():
		anim_player.play("move")
		char_sprite.flip_h = false
		melee_sprite.flip_h = false
		melee_sprite.offset.x = 15
		melee_hitbox.position.x = 6.098

	elif direction == -1 and !is_attacking_or_getting_hit():
		anim_player.play("move")
		char_sprite.flip_h = true
		melee_sprite.flip_h = true
		melee_sprite.offset.x = 10
		melee_hitbox.position.x = -3.1
		
	elif direction == 0 and !is_attacking_or_getting_hit():
		anim_player.play("idle")
		
func is_attacking_or_getting_hit() -> bool:
	if anim_player.get_current_animation() == "attack" or anim_player.get_current_animation() == "hit":
		return true
	else: return false

func attack():
	anim_player.play("attack")

func die():
	if hp <= 0:
		anim_player.play("die")
		queue_free()


func _on_player_detector_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		attack()
	


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("projectiles") or area.is_in_group("melee"):
		hp = hp - 1
		anim_player.play("hit")
		print("ouch")
