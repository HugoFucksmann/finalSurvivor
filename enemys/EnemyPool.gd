extends Node

@export var enemy_scene: PackedScene
@export var initial_pool_size: int = 10

var enemy_pool: Array = []

signal enemy_available(enemy)

func _ready():
	populate_pool()

func populate_pool():
	if enemy_scene == null:
		print("Error: enemy_scene is null.")
		return
	
	for _i in range(initial_pool_size):
		var enemy = enemy_scene.instantiate()
		enemy.queue_free()
		enemy_pool.append(enemy)

func get_available_enemy(enemy_scene, pos, player):
	for enemy in enemy_pool:
		if not enemy.is_inside_tree():
			enemy.position = pos
			enemy.player = player
			emit_signal("enemy_available", enemy)
			return enemy
	
	# Si no hay enemigos disponibles, crea uno nuevo.
	var new_enemy = enemy_scene.instantiate()
	new_enemy.position = pos
	new_enemy.player = player
	enemy_pool.append(new_enemy)
	emit_signal("enemy_available", new_enemy)
	return new_enemy
