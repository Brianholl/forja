extends Node2D

func _ready() -> void:
	print("=== El Dragón de Píxeles — escena lista ===")
	print("Flechas: mover  |  Esc: salir")

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()
