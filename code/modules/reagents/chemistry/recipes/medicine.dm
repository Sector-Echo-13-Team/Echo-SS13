
/datum/chemical_reaction/bicaridine
	results = list(/datum/reagent/medicine/bicaridine = 3)
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/oxygen = 1, /datum/reagent/consumable/sugar = 1)

/datum/chemical_reaction/bicaridinep
	results = list(/datum/reagent/medicine/bicaridinep = 3)
	required_reagents = list(/datum/reagent/medicine/bicaridine = 1, /datum/reagent/consumable/nutriment = 1, /datum/reagent/consumable/sodiumchloride = 1)

/datum/chemical_reaction/kelotane
	results = list(/datum/reagent/medicine/kelotane = 2)
	required_reagents = list(/datum/reagent/carbon = 1, /datum/reagent/silicon = 1)

/datum/chemical_reaction/dermaline
	results = list(/datum/reagent/medicine/dermaline = 3)
	required_reagents = list(/datum/reagent/medicine/kelotane = 1, /datum/reagent/acetone = 1, /datum/reagent/phosphorus = 1)

/datum/chemical_reaction/antitoxin
	results = list(/datum/reagent/medicine/antitoxin = 3)
	required_reagents = list(/datum/reagent/nitrogen = 1, /datum/reagent/silicon = 1, /datum/reagent/potassium = 1)

/datum/chemical_reaction/dexalin
	results = list(/datum/reagent/medicine/dexalin = 5)
	required_reagents = list(/datum/reagent/oxygen = 5)
	required_catalysts = list(/datum/reagent/toxin/plasma = 1)

/datum/chemical_reaction/dexalinp
	results = list(/datum/reagent/medicine/dexalinp = 3)
	required_reagents = list(/datum/reagent/medicine/dexalin = 1, /datum/reagent/carbon = 1, /datum/reagent/iron = 1)

/datum/chemical_reaction/tricordrazine
	results = list(/datum/reagent/medicine/tricordrazine = 3)
	required_reagents = list(/datum/reagent/medicine/bicaridine = 1, /datum/reagent/medicine/kelotane = 1, /datum/reagent/medicine/antitoxin = 1)

/datum/chemical_reaction/tetracordrazine
	results = list(/datum/reagent/medicine/tetracordrazine = 4)
	required_reagents = list(/datum/reagent/medicine/tricordrazine = 3, /datum/reagent/medicine/dexalin = 1)
/datum/chemical_reaction/synthflesh
	results = list(/datum/reagent/medicine/synthflesh = 3)
	required_reagents = list(/datum/reagent/blood = 1, /datum/reagent/carbon = 1, /datum/reagent/medicine/styptic_powder = 1)

/datum/chemical_reaction/styptic_powder
	results = list(/datum/reagent/medicine/styptic_powder = 4)
	required_reagents = list(/datum/reagent/aluminium = 1, /datum/reagent/hydrogen = 1, /datum/reagent/oxygen = 1, /datum/reagent/toxin/acid = 1)
	mix_message = "The solution yields an astringent powder."

/datum/chemical_reaction/corazone
	results = list(/datum/reagent/medicine/corazone = 3)
	required_reagents = list(/datum/reagent/phenol = 2, /datum/reagent/lithium = 1)

/datum/chemical_reaction/carthatoline
	results = list(/datum/reagent/medicine/carthatoline = 3)
	required_reagents = list(/datum/reagent/medicine/antitoxin = 1, /datum/reagent/carbon = 2)
	required_catalysts = list(/datum/reagent/toxin/plasma = 1)

/*/datum/chemical_reaction/hepanephrodaxon //WS edit: temporary removal of an overloaded chem
	results = list(/datum/reagent/medicine/hepanephrodaxon = 5)
	required_reagents = list(/datum/reagent/medicine/carthatoline = 2, /datum/reagent/carbon = 2, /datum/reagent/lithium = 1)
	required_catalysts = list(/datum/reagent/toxin/plasma = 5)*/

/datum/chemical_reaction/system_cleaner
	results = list(/datum/reagent/medicine/system_cleaner = 4)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/chlorine = 1, /datum/reagent/phenol = 2, /datum/reagent/potassium = 1)

/datum/chemical_reaction/liquid_solder
	results = list(/datum/reagent/medicine/liquid_solder = 3)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/copper = 1, /datum/reagent/silver = 1)
	required_temp = 370
	mix_message = "The mixture becomes a metallic slurry."

/datum/chemical_reaction/perfluorodecalin
	results = list(/datum/reagent/medicine/perfluorodecalin = 3)
	required_reagents = list(/datum/reagent/hydrogen = 1, /datum/reagent/fluorine = 1, /datum/reagent/fuel/oil = 1)
	required_temp = 370
	mix_message = "The mixture rapidly turns into a dense pink liquid."

/datum/chemical_reaction/leporazine
	results = list(/datum/reagent/medicine/leporazine = 2)
	required_reagents = list(/datum/reagent/silicon = 1, /datum/reagent/copper = 1)
	required_catalysts = list(/datum/reagent/toxin/plasma = 5)

/datum/chemical_reaction/rezadone
	results = list(/datum/reagent/medicine/rezadone = 3)
	required_reagents = list(/datum/reagent/toxin/carpotoxin = 1, /datum/reagent/cryptobiolin = 1, /datum/reagent/copper = 1)

/datum/chemical_reaction/spaceacillin
	results = list(/datum/reagent/medicine/spaceacillin = 2)
	required_reagents = list(/datum/reagent/cryptobiolin = 1, /datum/reagent/medicine/epinephrine = 1)

/datum/chemical_reaction/oculine
	results = list(/datum/reagent/medicine/oculine = 3)
	required_reagents = list(/datum/reagent/medicine/charcoal = 1, /datum/reagent/carbon = 1, /datum/reagent/hydrogen = 1)
	mix_message = "The mixture bubbles noticeably and becomes a dark grey color!"

/datum/chemical_reaction/inacusiate
	results = list(/datum/reagent/medicine/inacusiate = 2)
	required_reagents = list(/datum/reagent/water = 1, /datum/reagent/carbon = 1, /datum/reagent/medicine/charcoal = 1)
	mix_message = "The mixture sputters loudly and becomes a light grey color!"

/datum/chemical_reaction/synaptizine
	results = list(/datum/reagent/medicine/synaptizine = 3)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/lithium = 1, /datum/reagent/water = 1)

/datum/chemical_reaction/charcoal
	results = list(/datum/reagent/medicine/charcoal = 2)
	required_reagents = list(/datum/reagent/ash = 1, /datum/reagent/consumable/sodiumchloride = 1)
	mix_message = "The mixture yields a fine black powder."
	required_temp = 380

/datum/chemical_reaction/silver_sulfadiazine
	results = list(/datum/reagent/medicine/silver_sulfadiazine = 5)
	required_reagents = list(/datum/reagent/ammonia = 1, /datum/reagent/silver = 1, /datum/reagent/sulfur = 1, /datum/reagent/oxygen = 1, /datum/reagent/chlorine = 1)

/datum/chemical_reaction/salglu_solution
	results = list(/datum/reagent/medicine/salglu_solution = 3)
	required_reagents = list(/datum/reagent/consumable/sodiumchloride = 1, /datum/reagent/water = 1, /datum/reagent/consumable/sugar = 1)

/datum/chemical_reaction/mine_salve
	results = list(/datum/reagent/medicine/mine_salve = 3)
	required_reagents = list(/datum/reagent/fuel/oil = 1, /datum/reagent/water = 1, /datum/reagent/iron = 1)

/datum/chemical_reaction/mine_salve2
	results = list(/datum/reagent/medicine/mine_salve = 15)
	required_reagents = list(/datum/reagent/toxin/plasma = 5, /datum/reagent/iron = 5, /datum/reagent/consumable/sugar = 1) // A sheet of plasma, a twinkie and a sheet of metal makes four of these

/*WS Begin - No Cobbychmes

/datum/chemical_reaction/instabitaluri
	results = list(/datum/reagent/medicine/c2/instabitaluri = 3)
	required_reagents = list(/datum/reagent/blood = 1, /datum/reagent/carbon = 1, /datum/reagent/medicine/c2/libital = 1)

WS End */

/datum/chemical_reaction/calomel
	results = list(/datum/reagent/medicine/calomel = 2)
	required_reagents = list(/datum/reagent/mercury = 1, /datum/reagent/chlorine = 1)
	required_temp = 374

/datum/chemical_reaction/potass_iodide
	results = list(/datum/reagent/medicine/potass_iodide = 2)
	required_reagents = list(/datum/reagent/potassium = 1, /datum/reagent/iodine = 1)

/datum/chemical_reaction/pen_acid
	results = list(/datum/reagent/medicine/pen_acid = 6)
	required_reagents = list(/datum/reagent/fuel = 1, /datum/reagent/chlorine = 1, /datum/reagent/ammonia = 1, /datum/reagent/toxin/formaldehyde = 1, /datum/reagent/sodium = 1, /datum/reagent/toxin/cyanide = 1)

/datum/chemical_reaction/sal_acid
	results = list(/datum/reagent/medicine/sal_acid = 5)
	required_reagents = list(/datum/reagent/sodium = 1, /datum/reagent/phenol = 1, /datum/reagent/carbon = 1, /datum/reagent/oxygen = 1, /datum/reagent/toxin/acid = 1)

/datum/chemical_reaction/oxandrolone
	results = list(/datum/reagent/medicine/oxandrolone = 6)
	required_reagents = list(/datum/reagent/carbon = 3, /datum/reagent/phenol = 1, /datum/reagent/hydrogen = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/salbutamol
	results = list(/datum/reagent/medicine/salbutamol = 5)
	required_reagents = list(/datum/reagent/medicine/sal_acid = 1, /datum/reagent/lithium = 1, /datum/reagent/aluminium = 1, /datum/reagent/bromine = 1, /datum/reagent/ammonia = 1)

/datum/chemical_reaction/ephedrine
	results = list(/datum/reagent/medicine/ephedrine = 4)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/fuel/oil = 1, /datum/reagent/hydrogen = 1, /datum/reagent/diethylamine = 1)
	mix_message = "The solution fizzes and gives off toxic fumes."

/datum/chemical_reaction/diphenhydramine
	results = list(/datum/reagent/medicine/diphenhydramine = 4)
	required_reagents = list(/datum/reagent/fuel/oil = 1, /datum/reagent/carbon = 1, /datum/reagent/bromine = 1, /datum/reagent/diethylamine = 1, /datum/reagent/consumable/ethanol = 1)
	mix_message = "The mixture dries into a pale blue powder."

/datum/chemical_reaction/oculine
	results = list(/datum/reagent/medicine/oculine = 3)
	required_reagents = list(/datum/reagent/medicine/charcoal = 1, /datum/reagent/carbon = 1, /datum/reagent/hydrogen = 1)
	mix_message = "The mixture sputters loudly and becomes a pale pink color."

/datum/chemical_reaction/atropine
	results = list(/datum/reagent/medicine/atropine = 5)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/acetone = 1, /datum/reagent/diethylamine = 1, /datum/reagent/phenol = 1, /datum/reagent/toxin/acid = 1)

/datum/chemical_reaction/epinephrine
	results = list(/datum/reagent/medicine/epinephrine = 6)
	required_reagents = list(/datum/reagent/phenol = 1, /datum/reagent/acetone = 1, /datum/reagent/diethylamine = 1, /datum/reagent/oxygen = 1, /datum/reagent/chlorine = 1, /datum/reagent/hydrogen = 1)

/datum/chemical_reaction/strange_reagent
	results = list(/datum/reagent/medicine/strange_reagent = 3)
	required_reagents = list(/datum/reagent/medicine/omnizine = 1, /datum/reagent/water/holywater = 1, /datum/reagent/toxin/mutagen = 1)

/datum/chemical_reaction/strange_reagent/alt
	results = list(/datum/reagent/medicine/strange_reagent = 2)
	required_reagents = list(/datum/reagent/medicine/omnizine/protozine = 1, /datum/reagent/water/holywater = 1, /datum/reagent/toxin/mutagen = 1)

/datum/chemical_reaction/mannitol
	results = list(/datum/reagent/medicine/mannitol = 3)
	required_reagents = list(/datum/reagent/consumable/sugar = 1, /datum/reagent/hydrogen = 1, /datum/reagent/water = 1)
	mix_message = "The solution slightly bubbles, becoming thicker."

/datum/chemical_reaction/neurine
	results = list(/datum/reagent/medicine/neurine = 3)
	required_reagents = list(/datum/reagent/medicine/mannitol = 1, /datum/reagent/acetone = 1, /datum/reagent/oxygen = 1)

/datum/chemical_reaction/mutadone
	results = list(/datum/reagent/medicine/mutadone = 3)
	required_reagents = list(/datum/reagent/toxin/mutagen = 1, /datum/reagent/acetone = 1, /datum/reagent/bromine = 1)

/datum/chemical_reaction/antihol
	results = list(/datum/reagent/medicine/antihol = 3)
	required_reagents = list(/datum/reagent/consumable/ethanol = 1, /datum/reagent/medicine/charcoal = 1, /datum/reagent/copper = 1)

/datum/chemical_reaction/cryoxadone
	results = list(/datum/reagent/medicine/cryoxadone = 3)
	required_reagents = list(/datum/reagent/stable_plasma = 1, /datum/reagent/acetone = 1, /datum/reagent/toxin/mutagen = 1)

/datum/chemical_reaction/pyroxadone
	results = list(/datum/reagent/medicine/pyroxadone = 2)
	required_reagents = list(/datum/reagent/medicine/cryoxadone = 1, /datum/reagent/toxin/slimejelly = 1)

/datum/chemical_reaction/clonexadone
	results = list(/datum/reagent/medicine/clonexadone = 2)
	required_reagents = list(/datum/reagent/medicine/cryoxadone = 1, /datum/reagent/sodium = 1)
	required_catalysts = list(/datum/reagent/toxin/plasma = 5)

/datum/chemical_reaction/haloperidol
	results = list(/datum/reagent/medicine/haloperidol = 5)
	required_reagents = list(/datum/reagent/chlorine = 1, /datum/reagent/fluorine = 1, /datum/reagent/aluminium = 1, /datum/reagent/medicine/potass_iodide = 1, /datum/reagent/fuel/oil = 1)

/datum/chemical_reaction/regen_jelly
	results = list(/datum/reagent/medicine/regen_jelly = 1)
	required_reagents = list(/datum/reagent/medicine/tetracordrazine = 1, /datum/reagent/toxin/slimejelly = 1)

/datum/chemical_reaction/regen_jelly2
	results = list(/datum/reagent/medicine/regen_jelly = 2)
	required_reagents = list(/datum/reagent/medicine/omnizine = 1, /datum/reagent/toxin/slimejelly = 1)

/*WS Begin
/datum/chemical_reaction/higadrite
	results = list(/datum/reagent/medicine/higadrite = 3)
	required_reagents = list(/datum/reagent/phenol = 2, /datum/reagent/lithium = 1)
WS End*/
/datum/chemical_reaction/morphine
	results = list(/datum/reagent/medicine/morphine = 2)
	required_reagents = list(/datum/reagent/carbon = 2, /datum/reagent/hydrogen = 2, /datum/reagent/consumable/ethanol = 1, /datum/reagent/oxygen = 1)
	required_temp = 480

/datum/chemical_reaction/modafinil
	results = list(/datum/reagent/medicine/modafinil = 5)
	required_reagents = list(/datum/reagent/diethylamine = 1, /datum/reagent/ammonia = 1, /datum/reagent/phenol = 1, /datum/reagent/acetone = 1, /datum/reagent/toxin/acid = 1)
	required_catalysts = list(/datum/reagent/bromine = 1) // as close to the real world synthesis as possible

/datum/chemical_reaction/psicodine
	results = list(/datum/reagent/medicine/psicodine = 5)
	required_reagents = list(/datum/reagent/medicine/mannitol = 2, /datum/reagent/water = 2, /datum/reagent/impedrezene = 1)

/*WS Begin - No Cobby

/datum/chemical_reaction/granibitaluri
	results = list(/datum/reagent/medicine/granibitaluri = 3)
	required_reagents = list(/datum/reagent/acetone = 1, /datum/reagent/phenol = 1, /datum/reagent/nitrogen = 1)
	required_catalysts = list(/datum/reagent/iron = 5)
WS End */

/datum/chemical_reaction/medsuture
	required_reagents = list(/datum/reagent/cellulose = 10, /datum/reagent/toxin/formaldehyde = 20, /datum/reagent/medicine/polypyr = 15) //This might be a bit much, reagent cost should be reviewed after implementation.
	mob_react = FALSE

/datum/chemical_reaction/medsuture/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/medical/suture/medicated(location)

/datum/chemical_reaction/medmesh
	required_reagents = list(/datum/reagent/cellulose = 20, /datum/reagent/consumable/aloejuice = 20, /datum/reagent/space_cleaner/sterilizine = 10)
	mob_react = FALSE

/datum/chemical_reaction/medmesh/on_reaction(datum/reagents/holder, created_volume)
	var/location = get_turf(holder.my_atom)
	for(var/i in 1 to created_volume)
		new /obj/item/stack/medical/mesh/advanced(location)

/datum/chemical_reaction/converbital
	results = list(/datum/reagent/medicine/converbital = 3)
	required_reagents = list(/datum/reagent/fuel = 1, /datum/reagent/acetone = 1, /datum/reagent/medicine/kelotane = 1)
	mix_message = "The mixture spits and steams as it settles into a reddish-black paste"

/datum/chemical_reaction/convuri
	results = list(/datum/reagent/medicine/convuri = 3)
	required_reagents = list(/datum/reagent/fuel = 1, /datum/reagent/ash =1, /datum/reagent/medicine/bicaridine = 1)
	mix_message = "the mixture rapidly dries into an orange powder"

/datum/chemical_reaction/trophazole
	results = list(/datum/reagent/medicine/trophazole = 4)
	required_reagents = list(/datum/reagent/copper = 1, /datum/reagent/acetone = 2,  /datum/reagent/phosphorus = 1)

/datum/chemical_reaction/rhigoxane
	results = list(/datum/reagent/medicine/rhigoxane/ = 5)
	required_reagents = list(/datum/reagent/cryostylane = 3, /datum/reagent/bromine = 1, /datum/reagent/lye = 1)

/datum/chemical_reaction/thializid
	results = list(/datum/reagent/medicine/thializid = 5)
	required_reagents = list(/datum/reagent/sulfur = 1, /datum/reagent/fluorine = 1, /datum/reagent/toxin = 1, /datum/reagent/nitrous_oxide = 2)

/datum/chemical_reaction/medsuture/ash
	required_reagents = list(/datum/reagent/ash_fibers = 10, /datum/reagent/toxin/formaldehyde = 20, /datum/reagent/medicine/polypyr = 15)

/datum/chemical_reaction/medmesh/ash
	required_reagents = list(/datum/reagent/ash_fibers = 20, /datum/reagent/consumable/aloejuice = 20, /datum/reagent/space_cleaner/sterilizine = 10)

/datum/chemical_reaction/lavaland_extract
	results = list(/datum/reagent/medicine/lavaland_extract = 5)
	required_reagents = list(/datum/reagent/consumable/vitfro = 1, /datum/reagent/medicine/puce_essence = 2,  /datum/reagent/toxin/plasma = 2)

/datum/chemical_reaction/bonefixingjuice
	results = list(/datum/reagent/medicine/bonefixingjuice = 3)
	required_reagents = list(/datum/reagent/consumable/entpoly = 1, /datum/reagent/calcium = 1, /datum/reagent/toxin/plasma = 1)

/datum/chemical_reaction/skele_boon
	results = list(/datum/reagent/medicine/skeletons_boon = 5)
	required_reagents = list(/datum/reagent/medicine/lavaland_extract = 1, /datum/reagent/medicine/bonefixingjuice = 1, /datum/reagent/titanium = 5)

/datum/chemical_reaction/pure_soulus_dust_hollow
	results = list(/datum/reagent/medicine/soulus/pure = 10,)
	required_reagents = list(/datum/reagent/medicine/soulus = 20, /datum/reagent/medicine/system_cleaner = 1, /datum/reagent/water/hollowwater = 10)

/datum/chemical_reaction/pure_soulus_dust_holy
	results = list(/datum/reagent/medicine/soulus/pure = 10,)
	required_reagents = list(/datum/reagent/medicine/soulus = 20, /datum/reagent/medicine/system_cleaner = 1, /datum/reagent/water/holywater = 10)

/datum/chemical_reaction/chartreuse
	results = list(/datum/reagent/medicine/chartreuse = 10)
	required_reagents = list(/datum/reagent/medicine/puce_essence = 5, /datum/reagent/consumable/tinlux = 5, /datum/reagent/consumable/entpoly = 1)

/datum/chemical_reaction/molten_bubbles
	results = list(/datum/reagent/medicine/molten_bubbles = 30)
	required_reagents = list(/datum/reagent/clf3 = 10, /datum/reagent/consumable/space_cola = 20, /datum/reagent/medicine/leporazine = 1, /datum/reagent/medicine/lavaland_extract = 1)

/datum/chemical_reaction/plasma_bubbles
	results = list(/datum/reagent/medicine/molten_bubbles/plasma = 3)
	required_reagents = list(/datum/reagent/medicine/molten_bubbles = 3, /datum/reagent/toxin/plasma = 2)

/datum/chemical_reaction/sand_bubbles
	results = list(/datum/reagent/medicine/molten_bubbles/sand = 3)
	required_reagents = list(/datum/reagent/medicine/molten_bubbles = 3, /datum/reagent/silicon = 2)

/datum/chemical_reaction/sand_bubbles/plasma			// Subbing plasma bubbles for reg
	required_reagents = list(/datum/reagent/medicine/molten_bubbles/plasma = 3, /datum/reagent/silicon = 2)
