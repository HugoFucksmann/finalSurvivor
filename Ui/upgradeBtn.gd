extends TextureButton

@export var skill: Skill

var enabled: bool = false:
	set(value):
		enabled = value
		$Panel.show_behind_parent = value
		
		if value:
			# Configuración dinámica de puntos para el contorno (OutLine) alrededor del botón
			$OutLine.clear_points()
			$OutLine.add_point(Vector2(0, -1))
			$OutLine.add_point(Vector2(self.size.x, -1))
			$OutLine.add_point(Vector2(self.size.x, self.size.y))
			$OutLine.add_point(Vector2(0, self.size.y))
		
		# Si hay un nodo anterior, dibuja la conexión de forma dinámica
		if value and get_index() != 0:
			$Conection.clear_points()
			var previous_button = get_parent().get_child(get_index() - 1)
			$Conection.add_point(Vector2(self.size.x / 2, self.size.y / 2) + initial_modifier())
			$Conection.add_point(previous_button.position - position + Vector2(self.size.x / 2, self.size.y / 2) + final_modifier())

func _ready():
	if skill:
		texture_normal = skill.texture
		
func is_upgradable() -> bool:
	# Determina si el nodo actual es mejorable en función del estado del nodo anterior
	if get_index() == 0:
		return true
	elif get_index() > 0:
		return get_parent().get_child(get_index() - 1).enabled
	return false

func _on_pressed() -> void:
	# Verifica si se cumplen las condiciones para actualizar el nodo y realizar la acción
	if skill.cost <= SavedData.gold and is_upgradable() and not enabled:
		SavedData.gold -= skill.cost
		enabled = true
		get_parent().get_parent().set_skill_tree()
		get_parent().get_parent().get_total_stats()

func initial_modifier() -> Vector2:
	# Calcula el modificador inicial de la conexión según la posición del nodo anterior
	var previous_button = get_parent().get_child(get_index() - 1)
	var difference = previous_button.position - position
	var modification: Vector2 = Vector2.ZERO
	
	if difference.x < 0:
		modification += Vector2(-self.size.x / 2, 0)
	elif difference.x > 0:
		modification += Vector2(self.size.x / 2, 0)
		
	if difference.y < 0:
		modification += Vector2(0, -self.size.y / 2)
	elif difference.y > 0:
		modification += Vector2(0, self.size.y / 2)
	
	return modification

func final_modifier() -> Vector2:
	# Calcula el modificador final de la conexión para ajustar el punto de llegada
	var previous_button = get_parent().get_child(get_index() - 1)
	var difference = previous_button.position - position
	var modification: Vector2 = Vector2.ZERO
	
	if difference.x < 0:
		modification += Vector2(self.size.x / 2, 0)
	elif difference.x > 0:
		modification += Vector2(-self.size.x / 2, 0)
		
	if difference.y < 0:
		modification += Vector2(0, self.size.y / 2)
	elif difference.y > 0:
		modification += Vector2(0, -self.size.y / 2)
	
	return modification
