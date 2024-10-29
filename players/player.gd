extends CharacterBody2D
 
var speed : float = 150
var health : float = 100.0 :
	set(value):
		health = value
		%Health.value = value
		
# Agregar variables para la cámara
@onready var camera = $Camera2D
var camera_smoothing_speed = 10.0
var camera_limits = Rect2(0, 0, 1024, 600) # Ajusta estos valores según el tamaño de tu nivel

# Agregar variables para el desplazamiento
var camera_pan_speed = 500.0
var camera_pan_acceleration = 50.0
var camera_pan_velocity = Vector2.ZERO


func _unhandled_input(event):
	# Zoom
	if event.is_action_pressed("zoom_in"):
		camera.zoom *= 0.9
	elif event.is_action_pressed("zoom_out"):
		camera.zoom *= 1.1
	camera.zoom = clamp(camera.zoom, Vector2(0.5, 0.5), Vector2(2.0, 2.0))

	# Desplazamiento
	if event is InputEventMouseMotion and Input.is_action_pressed("pan"):
		camera_pan_velocity += event.relative * camera_pan_acceleration
		camera_pan_velocity = camera_pan_velocity.clamped(camera_pan_speed)
		
		
func _physics_process(delta):
	velocity = Input.get_vector("left","right","up","down") * speed
	move_and_collide(velocity * delta)
 	 # Actualizar posición de la cámara
	var target_position = global_position
	target_position.x = clamp(target_position.x, camera_limits.position.x, camera_limits.end.x)
	target_position.y = clamp(target_position.y, camera_limits.position.y, camera_limits.end.y)
	camera.global_position = camera.global_position.lerp(target_position, delta * camera_smoothing_speed)

	# Aplicar desplazamiento de la cámara
	camera.global_position += camera_pan_velocity * delta
	camera_pan_velocity = camera_pan_velocity.move_toward(Vector2.ZERO, camera_pan_speed * delta)
	
#	if velocity == Vector2.ZERO:
#		$AnimationPlayer.play("idle")
#	else:
#		$AnimationPlayer.play("run")
 
	if velocity.x < 0:
		$Sprite2D.flip_h = true
	elif velocity.x > 0:
		$Sprite2D.flip_h = false
 
func take_damage(amount):
	health -= amount
	print(amount)
 
 
func _on_self_damage_body_entered(body):
	take_damage(body.damage)
 


func _on_timer_timeout() -> void:
	%Collision.set_deferred("disabled",true)
	%Collision.set_deferred("disabled",false)
