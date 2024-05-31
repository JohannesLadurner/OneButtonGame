extends Node


#Stuff for transferring data between scenes
var current_song_id: int #If set to -1 it means that it is a custom song
var current_stream: AudioStream
var current_rewards: Array
var gameplay_properties: Gameplay.Properties = Gameplay.Properties.new()

#Stuff to persist
var unlocked_song_ids: Array
var unlocked_character_ids: Array = [0]
var selected_character_id: int
