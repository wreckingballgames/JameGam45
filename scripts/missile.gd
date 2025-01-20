class_name Missile
extends Area2D

@export var direction: Vector2 = Vector2.UP
@export var acceleration_rate: float = 50.0


func _ready() -> void:
	look_at(global_position + acceleration_rate * direction)


func _physics_process(delta: float) -> void:
	global_position += direction * acceleration_rate


func expire() -> void:
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	expire()


func _on_body_entered(body: Node2D) -> void:
	expire()
