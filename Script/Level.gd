extends Spatial

onready var monster = $GridMap/Monster
onready var player = $GridMap/Player
onready var orb_container = $GridMap/Orbs

var collected_orbs = 0
var total_orb_count = 0

func _ready():
	monster.set_target(player)
	player.set_monster(monster)
	total_orb_count = orb_container.get_child_count()
	player.update_orb_num(total_orb_count, collected_orbs)
	player.connect("orb_collected", self, "on_orb_collected")
	
func on_orb_collected():
	collected_orbs += 1
	player.update_orb_num(total_orb_count, collected_orbs)
	if collected_orbs >= total_orb_count:
		player.win()
