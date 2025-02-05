import SwiftData
import Foundation

// note that on start this is called like 13 times.
// could optimize this by setting a flag, but probably isn't that much of an issue.
func checkAndPopulateData(modelContext: ModelContext) {
    print("## in checkAndPopulateData")
    let hasPopulatedDatabase = NSUbiquitousKeyValueStore.default.bool(forKey: "hasPopulatedDatabase")

    if !hasPopulatedDatabase {
        populatePredefinedData(modelContext: modelContext)
    }
}

func populatePredefinedData(modelContext: ModelContext) {
    let fruits = "in_fruits".loc
    let veggies = "in_veggies".loc
    let meat = "in_meat".loc
    let fish = "in_fish".loc
    let sweets = "in_sweets".loc
    let eggs = "in_eggs".loc
    let grains = "in_grains".loc
    let beans = "in_beans".loc
    let drinks = "in_drinks".loc
    let oil = "in_oil".loc
    let spices = "in_spices".loc
    let pet = "in_pet".loc
    let hygiene = "in_hygiene".loc
    let cleaning = "in_cleaning".loc
    let office = "in_office".loc
    let alcohol = "in_alcohol".loc
    let cigarettes = "in_cigarettes".loc
    let entertainment = "in_entertainment".loc
    let bakery = "in_bakery".loc

    let predefinedData = [
        // pet
        PredefItem(name: "in_cat_food", price: 0, tag: pet),
        PredefItem(name: "in_dog_food", price: 0, tag: pet),
        PredefItem(name: "in_cat_sand", price: 0, tag: pet),

        // drinks
        PredefItem(name: "in_club_mate", price: 0, tag: drinks),
        PredefItem(name: "in_black_currant_juice", price: 0, tag: drinks),
        PredefItem(name: "in_orange_juice", price: 0, tag: drinks),
        PredefItem(name: "in_apple_juice", price: 0, tag: drinks),
        PredefItem(name: "in_cranberry_juice", price: 0, tag: drinks),
        PredefItem(name: "in_blueberry_juice", price: 0, tag: drinks),
        PredefItem(name: "in_banana_juice", price: 0, tag: drinks),
        PredefItem(name: "in_mango_juice", price: 0, tag: drinks),
        PredefItem(name: "in_coca_cola", price: 0, tag: drinks),
        PredefItem(name: "in_sprite", price: 0, tag: drinks),
        PredefItem(name: "in_fanta", price: 0, tag: drinks),
        PredefItem(name: "in_pepsi", price: 0, tag: drinks),
        
        // oil
        PredefItem(name: "in_olive_oil", price: 0, tag: oil),

        // spices
        PredefItem(name: "in_salt", price: 0, tag: spices),
        PredefItem(name: "in_black_pepper", price: 0, tag: spices),
        PredefItem(name: "in_cumin", price: 0, tag: spices),
        PredefItem(name: "in_saffron", price: 0, tag: spices),
        PredefItem(name: "in_cloves", price: 0, tag: spices),
        PredefItem(name: "in_chillis", price: 0, tag: spices),
        PredefItem(name: "in_mace", price: 0, tag: spices),
        PredefItem(name: "in_cardamom".loc, price: 0, tag: spices),
        PredefItem(name: "in_ginger".loc, price: 0, tag: spices),
        PredefItem(name: "in_turmeric".loc, price: 0, tag: spices),
        PredefItem(name: "in_parsley".loc, price: 0, tag: spices),
        PredefItem(name: "in_basil".loc, price: 0, tag: spices),
        PredefItem(name: "in_mint".loc, price: 0, tag: spices),
        PredefItem(name: "in_coriander".loc, price: 0, tag: spices),
        PredefItem(name: "in_rosemary".loc, price: 0, tag: spices),

        // eggs
        PredefItem(name: "in_eggs_6", price: 0, tag: eggs),
        PredefItem(name: "in_eggs_12", price: 0, tag: eggs),
        
        // grains
        PredefItem(name: "in_rice_basmati".loc, price: 0, tag: grains),
        PredefItem(name: "in_lentils".loc, price: 0, tag: grains),

        // bread
        PredefItem(name: "in_baguette", price: 0, tag: bakery),
        PredefItem(name: "in_bread_loaf", price: 0, tag: bakery),
        PredefItem(name: "in_bread_bundle_4", price: 0, tag: bakery),

        // fruits
        PredefItem(name: "in_apples".loc, price: 0, tag: fruits),
        PredefItem(name: "in_avocado".loc, price: 0, tag: fruits),
        PredefItem(name: "in_bananas".loc, price: 0, tag: fruits),
        PredefItem(name: "in_blackberries".loc, price: 0, tag: fruits),
        PredefItem(name: "in_blueberries".loc, price: 0, tag: fruits),
        PredefItem(name: "in_cranberries".loc, price: 0, tag: fruits),
        PredefItem(name: "in_cherries".loc, price: 0, tag: fruits),
        PredefItem(name: "in_coconut".loc, price: 0, tag: fruits),
        PredefItem(name: "in_currant".loc, price: 0, tag: fruits),
        PredefItem(name: "in_kiwis".loc, price: 0, tag: fruits),
        PredefItem(name: "in_red_grapes".loc, price: 0, tag: fruits),
        PredefItem(name: "in_green_grapes".loc, price: 0, tag: fruits),
        PredefItem(name: "in_black_grapes".loc, price: 0, tag: fruits),
        PredefItem(name: "in_grapes".loc, price: 0, tag: fruits),
        PredefItem(name: "in_lemons".loc, price: 0, tag: fruits),
        PredefItem(name: "in_limes".loc, price: 0, tag: fruits),
        PredefItem(name: "in_mandarines".loc, price: 0, tag: fruits),
        PredefItem(name: "in_mangos".loc, price: 0, tag: fruits),
        PredefItem(name: "in_melons".loc, price: 0, tag: fruits),
        PredefItem(name: "in_nectarines".loc, price: 0, tag: fruits),
        PredefItem(name: "in_oranges".loc, price: 0, tag: fruits),
        PredefItem(name: "in_olives".loc, price: 0, tag: fruits),
        PredefItem(name: "in_pears".loc, price: 0, tag: fruits),
        PredefItem(name: "in_peaches".loc, price: 0, tag: fruits),
        PredefItem(name: "in_pineapple".loc, price: 0, tag: fruits),
        PredefItem(name: "in_pomegranate".loc, price: 0, tag: fruits),
        PredefItem(name: "in_plums".loc, price: 0, tag: fruits),
        PredefItem(name: "in_strawberries".loc, price: 0, tag: fruits),
        PredefItem(name: "in_watermelons".loc, price: 0, tag: fruits),
        PredefItem(name: "in_tomatoes", price: 0, tag: fruits),

        // veggies
        PredefItem(name: "in_aspargus".loc, price: 0, tag: veggies),
        PredefItem(name: "in_broccoli".loc, price: 0, tag: veggies),
        PredefItem(name: "in_carrots".loc, price: 0, tag: veggies),
        PredefItem(name: "in_celery".loc, price: 0, tag: veggies),
        PredefItem(name: "in_champignons".loc, price: 0, tag: veggies),
        PredefItem(name: "in_garlic".loc, price: 0, tag: veggies),
        PredefItem(name: "in_kale".loc, price: 0, tag: veggies),
        PredefItem(name: "in_onions".loc, price: 0, tag: veggies),
        PredefItem(name: "in_white_onions".loc, price: 0, tag: veggies),
        PredefItem(name: "in_red_onions".loc, price: 0, tag: veggies),
        PredefItem(name: "in_lettuce".loc, price: 0, tag: veggies),
        PredefItem(name: "in_pepper".loc, price: 0, tag: veggies),
        PredefItem(name: "in_potatoes", price: 0, tag: veggies),
        PredefItem(name: "in_sweet_potato".loc, price: 0, tag: veggies),
        PredefItem(name: "in_corn".loc, price: 0, tag: veggies),

        // beans
        PredefItem(name: "in_red_beans".loc, price: 0, tag: beans),
        PredefItem(name: "in_white_beans".loc, price: 0, tag: beans),
        PredefItem(name: "in_green_beans".loc, price: 0, tag: beans),

        // meat
        PredefItem(name: "in_chicken_breast".loc, price: 0, tag: meat),
        PredefItem(name: "in_chicken_wings".loc, price: 0, tag: meat),
        PredefItem(name: "in_chicken_drumsticks".loc, price: 0, tag: meat),
        PredefItem(name: "in_pork_5_min".loc, price: 0, tag: meat),
        PredefItem(name: "in_steak".loc, price: 0, tag: meat),
        PredefItem(name: "in_turkey".loc, price: 0, tag: meat),
        PredefItem(name: "in_grinded_meat".loc, price: 0, tag: meat),
        PredefItem(name: "in_salami", price: 0, tag: meat),
        PredefItem(name: "in_liver_sausage", price: 0, tag: meat),
        PredefItem(name: "in_beef", price: 0, tag: meat),

        // fish
        PredefItem(name: "in_salmon".loc, price: 0, tag: fish),
        PredefItem(name: "in_sardines".loc, price: 0, tag: fish),
        PredefItem(name: "in_shrimps".loc, price: 0, tag: fish),
        PredefItem(name: "in_tuna".loc, price: 0, tag: fish),

     
        // sweets
        PredefItem(name: "in_ice_cream".loc, price: 0, tag: sweets),
        PredefItem(name: "in_popsicles".loc, price: 0, tag: sweets),
        PredefItem(name: "in_doughnuts".loc, price: 0, tag: sweets),
        PredefItem(name: "in_cake".loc, price: 0, tag: sweets),
        PredefItem(name: "in_pudding".loc, price: 0, tag: sweets),
        PredefItem(name: "in_cheese_cake".loc, price: 0, tag: sweets),
        PredefItem(name: "in_pie".loc, price: 0, tag: sweets),
        PredefItem(name: "in_strawberry_jam".loc, price: 0, tag: sweets),
        PredefItem(name: "in_peaches_jam".loc, price: 0, tag: sweets),
        PredefItem(name: "in_honey".loc, price: 0, tag: sweets),
        PredefItem(name: "in_gummy_bears".loc, price: 0, tag: sweets),
        PredefItem(name: "in_lollipops".loc, price: 0, tag: sweets),
        PredefItem(name: "in_jelly_beans".loc, price: 0, tag: sweets),
        PredefItem(name: "in_chocolate".loc, price: 0, tag: sweets),
        PredefItem(name: "in_sour_candy".loc, price: 0, tag: sweets),
        PredefItem(name: "in_maoams", price: 0, tag: sweets),
        
        // dairy
        PredefItem(name: "in_milk".loc, price: 0, tag: sweets),
        PredefItem(name: "in_cheese".loc, price: 0, tag: sweets),
        PredefItem(name: "in_blue_cheese".loc, price: 0, tag: sweets),
        PredefItem(name: "in_feta_cheese".loc, price: 0, tag: sweets),
        PredefItem(name: "in_goat_cheese".loc, price: 0, tag: sweets),
        PredefItem(name: "in_cream".loc, price: 0, tag: sweets),
        PredefItem(name: "in_butter".loc, price: 0, tag: sweets),
        PredefItem(name: "in_jogurt".loc, price: 0, tag: sweets),

        // hygiene
        PredefItem(name: "in_tooth_paste", price: 0, tag: hygiene),
        PredefItem(name: "in_tooth_floss", price: 0, tag: hygiene),
        PredefItem(name: "in_soap", price: 0, tag: hygiene),
        PredefItem(name: "in_liquid_soap", price: 0, tag: hygiene),
        PredefItem(name: "in_shampoo", price: 0, tag: hygiene),
        PredefItem(name: "in_razors", price: 0, tag: hygiene),
        PredefItem(name: "in_nail_clipper", price: 0, tag: hygiene),
        PredefItem(name: "in_listerine", price: 0, tag: hygiene),
        PredefItem(name: "in_towel", price: 0, tag: hygiene),
        PredefItem(name: "in_sanitary_towels", price: 0, tag: hygiene),
        PredefItem(name: "in_tampons", price: 0, tag: hygiene),
        PredefItem(name: "in_condoms", price: 0, tag: hygiene),
        PredefItem(name: "in_toilet_paper", price: 0, tag: hygiene),

        // cleaning
        PredefItem(name: "in_dish_soap", price: 0, tag: cleaning),
        PredefItem(name: "in_sponges", price: 0, tag: cleaning),
        PredefItem(name: "in_wire_sponges", price: 0, tag: cleaning),
        PredefItem(name: "in_cleaning_agent", price: 0, tag: cleaning),
        PredefItem(name: "in_mob", price: 0, tag: cleaning),
        PredefItem(name: "in_toothbrush", price: 0, tag: cleaning),
        PredefItem(name: "in_window_cleaner", price: 0, tag: cleaning),
        PredefItem(name: "in_oven_cleaner", price: 0, tag: cleaning),
        
        // office
        PredefItem(name: "in_printing_cartridge", price: 0, tag: office),
        PredefItem(name: "in_paper", price: 0, tag: office),
        PredefItem(name: "in_pen", price: 0, tag: office),
        PredefItem(name: "in_pencil", price: 0, tag: office),
        PredefItem(name: "in_eraser", price: 0, tag: office),
        PredefItem(name: "in_pencil_sharpener", price: 0, tag: office),
        
        // alcohol
        PredefItem(name: "in_beer", price: 0, tag: alcohol),
        PredefItem(name: "in_red_whine", price: 0, tag: alcohol),
        PredefItem(name: "in_white_whine", price: 0, tag: alcohol),
        PredefItem(name: "in_sangria", price: 0, tag: alcohol),
        PredefItem(name: "in_whiskey", price: 0, tag: alcohol),
        PredefItem(name: "in_rum", price: 0, tag: alcohol),
        PredefItem(name: "in_bayleys", price: 0, tag: alcohol),
        PredefItem(name: "in_brandy", price: 0, tag: alcohol),

        // cigarettes
        PredefItem(name: "in_cigarettes", price: 0, tag: cigarettes),

        // entertainment
        PredefItem(name: "in_comics", price: 0, tag: entertainment),
        PredefItem(name: "in_magazines", price: 0, tag: entertainment),
        PredefItem(name: "in_books", price: 0, tag: entertainment),
    ]

    for data in predefinedData {
        modelContext.insert(data)
    }
    
    do {
        try modelContext.save()
        
        NSUbiquitousKeyValueStore.default.set(true, forKey: "hasPopulatedDatabase")
        NSUbiquitousKeyValueStore.default.synchronize()
        
        logger.debug("Predefined data added successfully.")
    } catch {
        logger.error("error saving predefined data: \(error)")
    }
}

extension String {
    var loc: String {
        return NSLocalizedString(self, comment: "")
    }
}
