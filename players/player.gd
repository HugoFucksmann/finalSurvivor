extends CharacterBody2D
 
var speed : float = 150
var health : float = 100.0 :
	set(value):
		health = value
		%Health.value = value
		
var nearest_enemy : CharacterBody2D
var nearest_enemy_distance : float = INF

var XP : int = 0:
	set(value):
		XP = value
		%XP.value = value
var total_XP : int = 0
var level: int = 1:
	set(value):
		level = value
		%Level.text = "Lv " + str(value)
		
		if level >= 3:
			%XP.max_value = 20
		elif level >= 7:
			%XP.max_value = 40
		
@onready var camera = $Camera2D
var camera_smoothing_speed = 10.0
var camera_limits = Rect2(0, 0, 1024, 600)
var camera_pan_speed = 500.0
var camera_pan_acceleration = 50.0
var camera_pan_velocity = Vector2.ZERO

func _physics_process(delta):
	if is_instance_valid(nearest_enemy):
		nearest_enemy_distance = nearest_enemy.separation
		print(nearest_enemy.name)
	else:
		nearest_enemy_distance = INF	
	velocity = Input.get_vector("left","right","up","down") * speed
	move_and_collide(velocity * delta)
	check_XP()
	var target_position = global_position
	target_position.x = clamp(target_position.x, camera_limits.position.x, camera_limits.end.x)
	target_position.y = clamp(target_position.y, camera_limits.position.y, camera_limits.end.y)
	camera.global_position = camera.global_position.lerp(target_position, delta * camera_smoothing_speed)
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

func gain_XP(amount):
	XP += amount
	total_XP += amount

func check_XP():
	if XP > %XP.max_value:
		XP -= %XP.max_value
		level += 1


func _on_magnes_area_entered(area: Area2D) -> void:
	if area.has_method("follow"):
		area.follow(self)
