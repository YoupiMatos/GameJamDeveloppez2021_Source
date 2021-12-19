extends Node

var blue_mana: bool = false setget set_blue_mana
var red_mana: bool = false setget set_red_mana
var green_mana: bool = false setget set_green_mana

func set_blue_mana(value: bool):
	blue_mana = value
	
func set_red_mana(value: bool):
	red_mana = value
	
func set_green_mana(value: bool):
	green_mana = value
