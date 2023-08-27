extends Node


func _ready():
	var lt = LootTable.new()
	var item1 = LootItem.new()
	item1.probability = 1.0
	item1.contents = "scepter"
	var item2 = LootItem.new()
	item2.probability = 3.0
	item2.contents = "ring"
	var item3 = LootItem.new()
	item3.probability = 10.0
	item3.contents = "bones"
	lt.add_drop(item1)
	lt.add_drop(item2)
	lt.add_drop(item3)
	var scount = 0
	var rcount = 0
	var bcount = 0
	for i in range(1000):
		var drops = lt.drop()
		for item in drops:
			match item.contents:
				"scepter":
					scount += 1
				"bones":
					bcount += 1
				"ring":
					rcount += 1
	print(bcount," ",rcount," ",scount," ")

class LootRandomizer:
	pass

class LootObject:
	var probability : float
	var enabled : bool = true
	var always : bool = false
	var unique : bool = false

class LootTable extends LootObject:
	var total_count := 0.0
	var drop_count : int = 1
	var contents : Array[LootObject]
	var results : Array[LootObject]# Do I need this?
	
	func add_drop(item : LootObject):
		contents.append(item)
		total_count += item.probability
	
	func add_array(item_array : Array):
		for item in item_array:
			add_drop(item)
	
	func drop_seed():
		pass
	
	func drop() -> Array:
		var drop_results = []
		for item in contents:
			item as LootObject
			if !item.enabled:
				continue
			if item.always:
				drop_results.append(item)
		for i in range(drop_count):
			drop_results.append(get_single_drop(randf_range(0.0,total_count)))
		return drop_results
	
	func get_single_drop( count : float) -> LootObject:
		count = fmod(count, total_count)
		var max_iterations = 10
		while max_iterations > 0:
			max_iterations -= 1
			for item in contents:
				if !item.enabled or item.always:
					continue
				count -= item.probability
				if count < 0:
					return item
		return null

class LootItem extends LootObject:
	var contents = "Item"
	var amount : float = 1.0
