class_name Racer
extends CharacterBody2D

## Essentially enumerated keys for the array of valid direction Vector2s, directions.
enum Direction {
	North,
	NorthEast,
	East,
	SouthEast,
	South,
	SouthWest,
	West,
	NorthWest,
	NumberOfDirections,
}

## All of the valid directions for a racer to face in-game. Use Direction enum to index.
const directions: PackedVector2Array = [
	Vector2(0, -1),
	Vector2(1, -1),
	Vector2(1, 0),
	Vector2(1, 1),
	Vector2(0, 1),
	Vector2(-1, 1),
	Vector2(-1, 0),
	Vector2(-1, -1),
]

const sprite_filenames: PackedStringArray = [
	"north.png",
	"northeast.png",
	"east.png",
	"southeast.png",
	"south.png",
	"southwest.png",
	"west.png",
	"northwest.png",
]

@export var top_acceleration: float = 50.0
@export var sprite_folder_path: String
@export var acceleration_rate: float = 5.0
@export var brake_rate: float = 0.05
@export var constant_deceleration_rate: float = 0.005

var forward := directions[Direction.North]
var forward_direction_pointer := Direction.North:
	get:
		return forward_direction_pointer
	set(value):
		# Clamp direction_pointer within Direction enum (for turning)
		if (value < 0):
			forward_direction_pointer = Direction.NumberOfDirections - 1
		elif (value >= Direction.NumberOfDirections):
			forward_direction_pointer = 0
		else:
			forward_direction_pointer = value

@onready var sprite_2d: Sprite2D = %Sprite2D


func _ready() -> void:
	set_sprite_to_forward()


func _physics_process(delta: float) -> void:
	handle_input()
	move_and_slide()
	# TODO: Accelerate toward zero each frame and make it feel good
	velocity = lerp(velocity, Vector2.ZERO, constant_deceleration_rate)


func handle_input() -> void:
	# Acceleration input
	if Input.is_action_pressed("accelerate"):
		accelerate()
	elif Input.is_action_pressed("reverse"):
		reverse()
	elif Input.is_action_pressed("brake"):
		brake()
	
	# Turning input
	# TODO: Make it possible to hold turn and only slowly turn over time
	if Input.is_action_just_pressed("turn_left"):
		turn_left()
	elif Input.is_action_just_pressed("turn_right"):
		turn_right()


func update_velocity(direction: Vector2) -> void:
	# TODO: Cap acceleration in all directions (+x, -x, +y, -y) using top_acceleration
	velocity = velocity + (direction * acceleration_rate)


func accelerate() -> void:
	update_velocity(forward)


func reverse() -> void:
	update_velocity(directions[get_opposite_direction(forward_direction_pointer)])

# TODO
func brake() -> void:
	velocity = lerp(velocity, Vector2.ZERO, brake_rate)


func set_sprite_to_forward() -> void:
	sprite_2d.texture = load(sprite_folder_path + sprite_filenames[forward_direction_pointer])


func turn_left() -> void:
	forward_direction_pointer = forward_direction_pointer - 1
	forward = directions[forward_direction_pointer]
	set_sprite_to_forward()
	# TODO: Update velocity relative to whether turning while accelerating forward or backward
	update_velocity(forward)


func turn_right() -> void:
	forward_direction_pointer = forward_direction_pointer + 1
	forward = directions[forward_direction_pointer]
	set_sprite_to_forward()
	# TODO: Update velocity relative to whether turning while accelerating forward or backward
	update_velocity(forward)


func get_opposite_direction(direction: Direction) -> Direction:
	# I considered a basic modular arithmetic system for directions,
	#   but this is much simpler!
	match direction:
		Direction.North:
			return Direction.South
		Direction.NorthEast:
			return Direction.SouthWest
		Direction.East:
			return Direction.West
		Direction.SouthEast:
			return Direction.NorthWest
		Direction.South:
			return Direction.North
		Direction.SouthWest:
			return Direction.NorthEast
		Direction.West:
			return Direction.East
		Direction.NorthWest:
			return Direction.SouthEast
		_:
			# This case should never be reached.
			return Direction.NumberOfDirections


# TODO: Enable calculation of "MPH" using racer velocity
# TODO: Enable racer sliding left and right
# TODO: Enable racer shooting forward
# TODO: Enable racer to spin out
# TODO: Enable racer to take damage and be exploded then respawned
# TODO: Enable racer to be crossed by finish line
# TODO: Enable racer to collide with and be pushed away from
#   obstacles and other racers
