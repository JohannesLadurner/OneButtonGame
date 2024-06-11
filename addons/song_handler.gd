extends Node

var _all_songs = [
	Song.new(0, "res://assets/songs/Isotope - Dj Jart.wav", "Isotope - Dj Jart"),
	Song.new(1, "res://assets/songs/Tera - Xomu.wav", "Tera - Xomu"),
	Song.new(2, "res://assets/songs/What I Thought Was Love - Roman Novelrain, Toryn, NikiNovok.wav", "What I Thought Was Love - Roman Novelrain, Toryn, NikiNovok")
]

func get_all_songs() -> Array:
	return _all_songs

class Song:
	var _id: int
	var _stream_path: String
	var _title: String
	
	func get_id() -> int: return _id
	func get_stream_path() -> String: return _stream_path
	func get_title() -> String: return _title
	
	func _init(id: int, stream_path: String, title: String):
		self._id = id
		self._stream_path = stream_path
		self._title = title
		
