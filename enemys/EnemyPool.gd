extends Node
class_name EnemyPool

@export var enemy_scene : PackedScene  
@export var max_enemies : int = 300 
var pool : Array = [] 

func get_enemy() -> CharacterBody2D:
	# Limpiar referencias nulas o liberadas antes de obtener un enemigo
	pool = pool.filter(func(enemy): return is_instance_valid(enemy))
	
	if pool.size() > 0:
		var enemy = pool.pop_back()
		# Verificar que el enemigo sea válido antes de mostrarlo
		if is_instance_valid(enemy):
			enemy.show()
			return enemy
	
	# Si el pool está vacío o no tiene enemigos válidos, crear uno nuevo
	if get_tree().get_node_count_in_group("Enemy") < max_enemies:
		return enemy_scene.instantiate() as CharacterBody2D
	else:
		return null  

func return_enemy(enemy: CharacterBody2D) -> void:
	# Verificar que el enemigo sea válido antes de agregarlo al pool
	if is_instance_valid(enemy):
		enemy.hide() 
		enemy.position = Vector2.ZERO 
		pool.append(enemy)
