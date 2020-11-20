extends Node
class_name DialogAction


export(String, FILE, "*.json") var dialog_file_path: String

var _data

func get_data():
	return _data

func load_file():
	# Load the file and load any sprites listed.
	var file = File.new()
	assert(file.file_exists(dialog_file_path))
	
	file.open(dialog_file_path, file.READ)
	_data = parse_json(file.get_as_text())
	
	assert(_data.size() > 0)

	# Now load all the sprites listed.
	for item in _data:
		if item.has("sprite"):
			item["$sprite"] = load(item["sprite"])
