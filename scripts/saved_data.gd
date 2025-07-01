extends Node

var path = "user://data.json"
var data


func _ready():
	if FileAccess.file_exists(path):
		var file = FileAccess.open(path, FileAccess.READ)
		data = JSON.parse_string(file.get_as_text())
		file.close()
	else:
		var file = FileAccess.open(path, FileAccess.WRITE)
		data = {'sounds': true, 'music': true, 'high_score': 0}
		file.store_string(JSON.stringify(data))
		file.close()


func set_value(what, value):
	var file = FileAccess.open(path, FileAccess.WRITE)
	data[what] = value
	file.store_string(JSON.stringify(data))
	file.close()
