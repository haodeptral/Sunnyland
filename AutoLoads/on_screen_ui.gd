extends Node

signal health_changed(old_health, new_health, max_health)
signal coin_collected(value)
signal level_completed()

var curr_level:int = 0
var total_coin: int = 0
var level_data: Dictionary = {}
