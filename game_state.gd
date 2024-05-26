extends Node


var current_stream: AudioStream
var current_rewards: Array

var unlocked_songs: Array
var unlocked_characters: Array
var selected_character: CharacterHandler.Character
var gameplay_properties: Gameplay.Properties = Gameplay.Properties.new()
