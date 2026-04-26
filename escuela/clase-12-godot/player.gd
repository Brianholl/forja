extends CharacterBody2D

const SPEED: float = 200.0

func _physics_process(_delta: float) -> void:
	var dir := Vector2(
		Input.get_axis("ui_left",  "ui_right"),
		Input.get_axis("ui_up",    "ui_down"),
	)

	if dir != Vector2.ZERO:
		dir = dir.normalized()

	velocity = dir * SPEED
	move_and_slide()
