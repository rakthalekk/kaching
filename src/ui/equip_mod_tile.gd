class_name EquipModTile
extends TextureButton


var mod : Modification

func populate_mod(modification: Modification):
	mod = modification
	
	$Label.text = mod.name
