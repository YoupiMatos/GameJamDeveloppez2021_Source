extends Actor

onready var blue_mana = preload("res://Source/Spells/blue_mana_projectile.tscn")
onready var red_mana = preload("res://Source/Spells/red_mana_projectile.tscn")
onready var green_mana = preload("res://Source/Spells/green_mana_projectile.tscn")

onready var anim_player = $AnimationPlayer
onready var char_sprite = $Sprite
onready var melee_sprite = $Area2D/melee_sprite
onready var melee_hitbox = $Area2D/melee_hitbox

var dj_counter: int
var attack_animation: = ["ranged_attack", "melee_attack"]
var equipped_mana: String = "blue_mana"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	var is_jump_interrupted: = Input.is_action_just_released("jump") and _velocity.y < 0.0
	var direction = get_direction()
	sprite_mode(direction)
	double_jump()
	_velocity = calculate_move_velocity(_velocity, direction, speed, is_jump_interrupted)
	_velocity = move_and_slide(_velocity, Vector2.UP)
	attacking()
	shoot(equipped_mana)
	equip_mana()


#renvoie 1 si on appuie à droite (1 - 0) ou -1 si on appuie à gauche (0 - 1)
func get_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("right") - Input.get_action_strength("left"),
		-1.0 if Input.is_action_just_pressed("jump") and (is_on_floor() or dj_counter > 0) else 1.0
	)


func calculate_move_velocity(
		linear_velocity: Vector2,
		direction: Vector2,
		speed: Vector2,
		is_jump_interrupted: bool
	) -> Vector2:
	var out: = linear_velocity
	out.x = speed.x * direction.x
	out.y += gravity * get_physics_process_delta_time()
	
	if direction.y == -1.0:
		out.y = speed.y * direction.y
	if is_jump_interrupted:
		out.y = 0
	return out


func sprite_mode(direction: Vector2) -> void:
	if direction.x == 1 and !is_attacking():
		anim_player.play("move")
		char_sprite.flip_h = false
		melee_sprite.flip_h = false
		melee_sprite.offset.x = 15
		melee_hitbox.position.x = 15

	elif direction.x == -1 and !is_attacking():
		anim_player.play("move")
		char_sprite.flip_h = true
		melee_sprite.flip_h = true
		melee_sprite.offset.x = -15
		melee_hitbox.position.x = -15
		
	elif direction.x == 0 and !is_attacking():
		anim_player.play("idle")
	
	if !is_on_floor() and _velocity.y < 0 and !is_attacking():
		anim_player.play("jump_up")
	elif !is_on_floor() and _velocity.y > 0 and !is_attacking():
		anim_player.play("jump_down")


func attacking() -> void:
	if Input.is_action_just_pressed("melee"):
		anim_player.play("melee_attack")


func double_jump():
	if is_on_floor():
		dj_counter = 1
	else:
		if Input.is_action_just_pressed("jump") and dj_counter > 0:
			dj_counter -= 1


func shoot(mana_type):
	var proj = get(mana_type)
	if Autoload.get(mana_type) == false:
		return
	else:
		if Input.is_action_just_pressed("ranged"):
			if get_node_or_null("/root/Node2D/green_mana_proj") != null:
				return
			else:
				proj = proj.instance()
				owner.add_child(proj)
				if char_sprite.flip_h == true:
					proj.direction.x = -1
				else: proj.direction.x = 1
				proj.position = self.global_position + (Vector2(15.0,0.0) * proj.direction)
				anim_player.play("ranged_attack")
				if mana_type == "green_mana":
					var teleport = get_node("/root/Node2D/green_mana_proj")
					teleport.connect("teleport", self, "teleportation")


func is_attacking() -> bool:
	if attack_animation.has(anim_player.get_current_animation()) == true or anim_player.get_current_animation() == "hit":
		return true
	else: return false


func equip_mana():
	if Autoload.blue_mana == true:
		if Input.is_action_just_pressed("blue_mana"):
			equipped_mana = "blue_mana"
	if Autoload.red_mana == true:
		if Input.is_action_just_pressed("red_mana"):
			equipped_mana = "red_mana"
	if Autoload.green_mana == true:
		if Input.is_action_just_pressed("green_mana"):
			equipped_mana = "green_mana"


func teleportation():
	global_position = get_node("/root/Node2D/green_mana_proj").global_position




func _on_hitbox_body_entered(body: Node) -> void:
	if body.is_in_group("ennemies"):
		anim_player.play("hit")
		hp -= 1
