extends Node
class_name EnemyPool

@export var enemy_scene : PackedScene  
@export var max_enemies : int = 300 
var pool : Array = [] 


func get_enemy() -> CharacterBody2D:
	if pool.size() > 0:
		var enemy = pool.pop_back()
		enemy.show()  
		return enemy
	elif get_tree().get_node_count_in_group("Enemy") < max_enemies:
		return enemy_scene.instantiate() as CharacterBody2D
	else:
		return null  


func return_enemy(enemy: CharacterBody2D) -> void:
	enemy.hide() 
	enemy.position = Vector2.ZERO 
	pool.append(enemy) 
