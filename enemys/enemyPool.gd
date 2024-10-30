# enemy_pool.gd
extends Node2D

const ENEMY_SCENE = preload("res://enemys/enemy.tscn")
const POOL_SIZE = 100

var pool = []

func _ready():
	# Crear pool inicial de enemigos
	for _i in range(POOL_SIZE):
		var enemy = ENEMY_SCENE.instantiate()
		pool.append(enemy)
		add_child(enemy)
		enemy.hide()

func get_enemy():
	# Buscar un enemigo disponible en el pool
	for enemy in pool:
		if not enemy.visible:
			return enemy

	# Si no hay ninguno disponible, crear uno nuevo
	var new_enemy = ENEMY_SCENE.instantiate()
	pool.append(new_enemy)
	add_child(new_enemy)
	return new_enemy

func return_enemy(enemy):
	# Devolver un enemigo al pool
	enemy.hide()
	enemy.global_position = Vector2.ZERO
	enemy.velocity = Vector2.ZERO
	enemy.knockback = Vector2.ZERO
