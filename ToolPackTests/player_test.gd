extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	if Input.is_action_pressed("ui_accept"): # fly
		velocity.y = JUMP_VELOCITY
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	# keep on screen
	if position.y > get_viewport_rect().size.y:
		position.y = get_viewport_rect().size.y
	if position.y < 0:
		position.y = 10
	if position.x > get_viewport_rect().size.x:
		position.x = get_viewport_rect().size.x
	if position.x < 0:
		position.x = 10
		
	
