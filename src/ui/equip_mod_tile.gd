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
