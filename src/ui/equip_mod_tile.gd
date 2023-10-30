class_name EquipModTile
extends TextureButton


var mod : Modification
var menu: EquipMenu


func populate_mod(modification: Modification):
	mod = modification
	
	$Label.text = mod.name
	
	tooltip_text = mod.description
