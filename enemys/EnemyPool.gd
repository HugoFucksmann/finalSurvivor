extends Node
class_name EnemyPool

@export var enemy_scene : PackedScene  # La escena de enemigo que se instanciará
var pool : Array = []  # Array que almacenará los enemigos reciclables

# Función para obtener un enemigo del pool o crear uno si no hay disponibles
func get_enemy() -> CharacterBody2D:
	if pool.size() > 0:
		var enemy = pool.pop_back()
		enemy.show()  # Asegúrate de que el enemigo esté visible al reutilizarlo
		return enemy
	else:
		return enemy_scene.instantiate() as CharacterBody2D

# Función para regresar un enemigo al pool
func return_enemy(enemy: CharacterBody2D) -> void:
	enemy.hide()  # Oculta el enemigo en lugar de liberarlo
	enemy.position = Vector2.ZERO  # Opcional: restablece la posición o cualquier otro estado necesario
	pool.append(enemy)  # Añade el enemigo de vuelta al pool
