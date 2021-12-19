extends KinematicBody2D
class_name Actor

export var speed: Vector2 = Vector2(300.0,1000.0)
export var gravity: float = 3000.0
export var hp: int

var _velocity: Vector2 = Vector2.ZERO

func _physics_process(delta: float) -> void:
	_velocity.y += gravity * delta
