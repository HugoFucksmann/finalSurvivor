extends CharacterBody2D

@export var enemy_pool: EnemyPool

var player_reference : CharacterBody2D

var direction : Vector2
var speed : float = 75
var damage : float = 0
var knockback : Vector2
var elite : bool = false:
	set(value):
		elite = value
		if value:
			$Sprite2D.material = load("res://effects/rainbow.tres")
			scale = Vector2(1.5,1.5)
 
var type : Enemy:
	set(value):
		type = value
		$Sprite2D.texture = value.texture
		damage = value.damage
 
func _physics_process(delta):
	var separation = (player_reference.position - position).length()
	if separation >= 500 and not elite:
		# En lugar de queue_free(), devuelve el enemigo al pool
		if enemy_pool:
			enemy_pool.return_enemy(self)
		return

	velocity = (player_reference.position - position).normalized() * speed
	knockback = knockback.move_toward(Vector2.ZERO, 1)
	velocity += knockback
	var collider = move_and_collide(velocity * delta)
	if collider:
		collider.get_collider().knockback = (collider.get_collider().global_position - global_position).normalized() * 50
