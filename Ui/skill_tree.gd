extends Panel
 
var skill_tree
var total_stat : Stats
 
func _ready():
	load_skill_tree()
	for branch in get_children():
		for upgrade in branch.get_children():
			upgrade.connect("toggled", Callable(self, "_on_Upgrade_toggled"))
 
func load_skill_tree():
	if SavedData.skill_tree == []:
		set_skill_tree()
 
	skill_tree = SavedData.skill_tree
	for branch in get_children():
		for upgrade in branch.get_children():
			upgrade.enabled = skill_tree[branch.get_index()][upgrade.get_index()]
	get_total_stats()
 
func set_skill_tree():
	skill_tree = []
	for each_branch in get_children():
		var branch = []
		for upgrade in each_branch.get_children():
			branch.append(upgrade.enabled)
		skill_tree.append(branch)
 
	SavedData.skill_tree = skill_tree
	SavedData.set_and_save()
 
func add_stats(stat):
	total_stat.max_health += stat.max_health
	total_stat.recovery += stat.recovery
	total_stat.armor += stat.armor
	total_stat.movement_speed += stat.movement_speed
	total_stat.might += stat.might
	total_stat.area += stat.area
	total_stat.magnet += stat.magnet
	total_stat.growth += stat.growth
 
func get_total_stats():
	total_stat = Stats.new()
	for branch in get_children():
		for upgrade in branch.get_children():
			if upgrade.enabled:
				add_stats(upgrade.skill.stats)
	Persistence.bonus_stats = total_stat
 
func _on_Upgrade_toggled(upgrade: Node):
	var branch_index = upgrade.get_parent().get_index()
	var upgrade_index = upgrade.get_index()
	skill_tree[branch_index][upgrade_index] = upgrade.enabled
	SavedData.skill_tree = skill_tree
	SavedData.set_and_save()
