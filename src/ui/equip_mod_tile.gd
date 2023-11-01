class_name EquipModTile
extends TextureButton


var mod : AttackModification
var menu: EquipMenu


func populate_mod(modification: AttackModification):
	mod = modification
	
	$Label.text = mod.name
	
	tooltip_text = mod.description


func _on_pressed():
	menu.equip_mod(self)
	
#	var list
#	if(mod.coin_type == Modification.COIN_TYPE.PENNY):
#		list =  menu.penny_mod_list
#	if(mod.coin_type == Modification.COIN_TYPE.DIME):
#		list =  menu.dime_mod_list
#	if(mod.coin_type == Modification.COIN_TYPE.QUARTER):
#		list =  menu.quarter_mod_list
#
#
#	for mod_tile in list.get_children():
#		mod_tile.color_rect.visible = false
	
	
#	$ColorRect.visible = true
