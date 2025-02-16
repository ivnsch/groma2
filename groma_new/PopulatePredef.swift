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
    let predefinedData = generatePredefinedData()
//    let predefinedData = generateDevelopmentPredefinedData()

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

func generatePredefinedData() -> [PredefItem] {
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
    let dairy = "in_dairy".loc

    return [
        // pet
        PredefItem(name: "in_cat_food".loc, price: 0, tag: pet),
        PredefItem(name: "in_dog_food".loc, price: 0, tag: pet),
        PredefItem(name: "in_cat_sand".loc, price: 0, tag: pet),

        // drinks
        PredefItem(name: "in_club_mate".loc, price: 0, tag: drinks),
        PredefItem(name: "in_black_currant_juice".loc, price: 0, tag: drinks),
        PredefItem(name: "in_orange_juice".loc, price: 0, tag: drinks),
        PredefItem(name: "in_apple_juice".loc, price: 0, tag: drinks),
        PredefItem(name: "in_cranberry_juice".loc, price: 0, tag: drinks),
        PredefItem(name: "in_blueberry_juice".loc, price: 0, tag: drinks),
        PredefItem(name: "in_banana_juice".loc, price: 0, tag: drinks),
        PredefItem(name: "in_mango_juice".loc, price: 0, tag: drinks),
        PredefItem(name: "in_coca_cola".loc, price: 0, tag: drinks),
        PredefItem(name: "in_sprite".loc, price: 0, tag: drinks),
        PredefItem(name: "in_fanta".loc, price: 0, tag: drinks),
        PredefItem(name: "in_pepsi".loc, price: 0, tag: drinks),
        
        // oil
        PredefItem(name: "in_olive_oil".loc, price: 0, tag: oil),

        // spices
        PredefItem(name: "in_salt".loc, price: 0, tag: spices),
        PredefItem(name: "in_black_pepper".loc, price: 0, tag: spices),
        PredefItem(name: "in_cumin".loc, price: 0, tag: spices),
        PredefItem(name: "in_saffron".loc, price: 0, tag: spices),
        PredefItem(name: "in_cloves".loc, price: 0, tag: spices),
        PredefItem(name: "in_chillis".loc, price: 0, tag: spices),
        PredefItem(name: "in_mace".loc, price: 0, tag: spices),
        PredefItem(name: "in_cardamom".loc, price: 0, tag: spices),
        PredefItem(name: "in_ginger".loc, price: 0, tag: spices),
        PredefItem(name: "in_turmeric".loc, price: 0, tag: spices),
        PredefItem(name: "in_parsley".loc, price: 0, tag: spices),
        PredefItem(name: "in_basil".loc, price: 0, tag: spices),
        PredefItem(name: "in_mint".loc, price: 0, tag: spices),
        PredefItem(name: "in_coriander".loc, price: 0, tag: spices),
        PredefItem(name: "in_rosemary".loc, price: 0, tag: spices),

        // eggs
        PredefItem(name: "in_eggs_6".loc, price: 0, tag: eggs),
        PredefItem(name: "in_eggs_12".loc, price: 0, tag: eggs),
        
        // grains
        PredefItem(name: "in_rice_basmati".loc, price: 0, tag: grains),
        PredefItem(name: "in_lentils".loc, price: 0, tag: grains),

        // bread
        PredefItem(name: "in_baguette".loc, price: 0, tag: bakery),
        PredefItem(name: "in_bread_loaf".loc, price: 0, tag: bakery),
        PredefItem(name: "in_bread_bundle_4".loc, price: 0, tag: bakery),

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
        PredefItem(name: "in_tomatoes".loc, price: 0, tag: fruits),

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
        PredefItem(name: "in_potatoes".loc, price: 0, tag: veggies),
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
        PredefItem(name: "in_salami".loc, price: 0, tag: meat),
        PredefItem(name: "in_liver_sausage".loc, price: 0, tag: meat),
        PredefItem(name: "in_beef".loc, price: 0, tag: meat),

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
        PredefItem(name: "in_lollipops".loc, price: 0, tag: sweets),
        PredefItem(name: "in_jelly_beans".loc, price: 0, tag: sweets),
        PredefItem(name: "in_chocolate".loc, price: 0, tag: sweets),
        PredefItem(name: "in_sour_candy".loc, price: 0, tag: sweets),
        PredefItem(name: "in_maoams".loc, price: 0, tag: sweets),
        
        // dairy
        PredefItem(name: "in_milk".loc, price: 0, tag: dairy),
        PredefItem(name: "in_cheese".loc, price: 0, tag: dairy),
        PredefItem(name: "in_blue_cheese".loc, price: 0, tag: dairy),
        PredefItem(name: "in_feta_cheese".loc, price: 0, tag: dairy),
        PredefItem(name: "in_goat_cheese".loc, price: 0, tag: dairy),
        PredefItem(name: "in_cream".loc, price: 0, tag: dairy),
        PredefItem(name: "in_butter".loc, price: 0, tag: dairy),
        PredefItem(name: "in_jogurt".loc, price: 0, tag: dairy),

        // hygiene
        PredefItem(name: "in_tooth_paste".loc, price: 0, tag: hygiene),
        PredefItem(name: "in_tooth_floss".loc, price: 0, tag: hygiene),
        PredefItem(name: "in_soap".loc, price: 0, tag: hygiene),
        PredefItem(name: "in_liquid_soap".loc, price: 0, tag: hygiene),
        PredefItem(name: "in_shampoo".loc, price: 0, tag: hygiene),
        PredefItem(name: "in_razors".loc, price: 0, tag: hygiene),
        PredefItem(name: "in_nail_clipper".loc, price: 0, tag: hygiene),
        PredefItem(name: "in_listerine".loc, price: 0, tag: hygiene),
        PredefItem(name: "in_towel".loc, price: 0, tag: hygiene),
        PredefItem(name: "in_sanitary_towels".loc, price: 0, tag: hygiene),
        PredefItem(name: "in_tampons".loc, price: 0, tag: hygiene),
        PredefItem(name: "in_condoms".loc, price: 0, tag: hygiene),
        PredefItem(name: "in_toilet_paper".loc, price: 0, tag: hygiene),

        // cleaning
        PredefItem(name: "in_dish_soap".loc, price: 0, tag: cleaning),
        PredefItem(name: "in_sponges".loc, price: 0, tag: cleaning),
        PredefItem(name: "in_wire_sponges".loc, price: 0, tag: cleaning),
        PredefItem(name: "in_cleaning_agent".loc, price: 0, tag: cleaning),
        PredefItem(name: "in_mob".loc, price: 0, tag: cleaning),
        PredefItem(name: "in_toothbrush".loc, price: 0, tag: cleaning),
        PredefItem(name: "in_window_cleaner".loc, price: 0, tag: cleaning),
        PredefItem(name: "in_oven_cleaner".loc, price: 0, tag: cleaning),
        
        // office
        PredefItem(name: "in_printing_cartridge".loc, price: 0, tag: office),
        PredefItem(name: "in_paper".loc, price: 0, tag: office),
        PredefItem(name: "in_pen".loc, price: 0, tag: office),
        PredefItem(name: "in_pencil".loc, price: 0, tag: office),
        PredefItem(name: "in_eraser".loc, price: 0, tag: office),
        PredefItem(name: "in_pencil_sharpener".loc, price: 0, tag: office),
        
        // alcohol
        PredefItem(name: "in_beer".loc, price: 0, tag: alcohol),
        PredefItem(name: "in_red_whine".loc, price: 0, tag: alcohol),
        PredefItem(name: "in_white_whine".loc, price: 0, tag: alcohol),
        PredefItem(name: "in_sangria".loc, price: 0, tag: alcohol),
        PredefItem(name: "in_whiskey".loc, price: 0, tag: alcohol),
        PredefItem(name: "in_rum".loc, price: 0, tag: alcohol),
        PredefItem(name: "in_bayleys".loc, price: 0, tag: alcohol),
        PredefItem(name: "in_brandy".loc, price: 0, tag: alcohol),

        // cigarettes
        PredefItem(name: "in_cigarettes".loc, price: 0, tag: cigarettes),

        // entertainment
        PredefItem(name: "in_comics".loc, price: 0, tag: entertainment),
        PredefItem(name: "in_magazines".loc, price: 0, tag: entertainment),
        PredefItem(name: "in_books".loc, price: 0, tag: entertainment),
    ]
}

func generateDevelopmentPredefinedData() -> [PredefItem] {
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
    let dairy = "in_dairy".loc

    return [
        // pet
        PredefItem(name: "in_cat_food".loc, price: 2, tag: pet),
        PredefItem(name: "in_dog_food".loc, price: 2, tag: pet),
        PredefItem(name: "in_cat_sand".loc, price: 5, tag: pet),

        // drinks
        PredefItem(name: "in_club_mate".loc, price: 1.2, tag: drinks),
        PredefItem(name: "in_black_currant_juice".loc, price: 2, tag: drinks),
        PredefItem(name: "in_orange_juice".loc, price: 2, tag: drinks),
        PredefItem(name: "in_apple_juice".loc, price: 2, tag: drinks),
        PredefItem(name: "in_cranberry_juice".loc, price: 2, tag: drinks),
        PredefItem(name: "in_blueberry_juice".loc, price: 2, tag: drinks),
        PredefItem(name: "in_banana_juice".loc, price: 2, tag: drinks),
        PredefItem(name: "in_mango_juice".loc, price: 2, tag: drinks),
        PredefItem(name: "in_coca_cola".loc, price: 1, tag: drinks),
        PredefItem(name: "in_sprite".loc, price: 1, tag: drinks),
        PredefItem(name: "in_fanta".loc, price: 1, tag: drinks),
        PredefItem(name: "in_pepsi".loc, price: 1, tag: drinks),
        
        // oil
        PredefItem(name: "in_olive_oil".loc, price: 7, tag: oil),

        // spices
        PredefItem(name: "in_salt".loc, price: 1, tag: spices),
        PredefItem(name: "in_black_pepper".loc, price: 1, tag: spices),
        PredefItem(name: "in_cumin".loc, price: 1, tag: spices),
        PredefItem(name: "in_saffron".loc, price: 4, tag: spices),
        PredefItem(name: "in_cloves".loc, price: 1, tag: spices),
        PredefItem(name: "in_chillis".loc, price: 1, tag: spices),
        PredefItem(name: "in_mace".loc, price: 1, tag: spices),
        PredefItem(name: "in_cardamom".loc, price: 2, tag: spices),
        PredefItem(name: "in_ginger".loc, price: 1, tag: spices),
        PredefItem(name: "in_turmeric".loc, price: 1, tag: spices),
        PredefItem(name: "in_parsley".loc, price: 1, tag: spices),
        PredefItem(name: "in_basil".loc, price: 1, tag: spices),
        PredefItem(name: "in_mint".loc, price: 1, tag: spices),
        PredefItem(name: "in_coriander".loc, price: 1, tag: spices),
        PredefItem(name: "in_rosemary".loc, price: 1, tag: spices),

        // eggs
        PredefItem(name: "in_eggs_6".loc, price: 4, tag: eggs),
        PredefItem(name: "in_eggs_12".loc, price: 7, tag: eggs),
        
        // grains
        PredefItem(name: "in_rice_basmati".loc, price: 3, tag: grains),
        PredefItem(name: "in_lentils".loc, price: 1, tag: grains),

        // bread
        PredefItem(name: "in_baguette".loc, price: 1, tag: bakery),
        PredefItem(name: "in_bread_loaf".loc, price: 0.3, tag: bakery),
        PredefItem(name: "in_bread_bundle_4".loc, price: 2, tag: bakery),

        // fruits
        PredefItem(name: "in_apples".loc, price: 0.5, tag: fruits),
        PredefItem(name: "in_avocado".loc, price: 2, tag: fruits),
        PredefItem(name: "in_bananas".loc, price: 0.4, tag: fruits),
        PredefItem(name: "in_blackberries".loc, price: 3.5, tag: fruits),
        PredefItem(name: "in_blueberries".loc, price: 3, tag: fruits),
        PredefItem(name: "in_cranberries".loc, price: 3, tag: fruits),
        PredefItem(name: "in_cherries".loc, price: 3, tag: fruits),
        PredefItem(name: "in_coconut".loc, price: 2, tag: fruits),
        PredefItem(name: "in_currant".loc, price: 2, tag: fruits),
        PredefItem(name: "in_kiwis".loc, price: 2, tag: fruits),
        PredefItem(name: "in_red_grapes".loc, price: 3, tag: fruits),
        PredefItem(name: "in_green_grapes".loc, price: 3, tag: fruits),
        PredefItem(name: "in_black_grapes".loc, price: 3, tag: fruits),
        PredefItem(name: "in_grapes".loc, price: 3, tag: fruits),
        PredefItem(name: "in_lemons".loc, price: 2, tag: fruits),
        PredefItem(name: "in_limes".loc, price: 3, tag: fruits),
        PredefItem(name: "in_mandarines".loc, price: 2, tag: fruits),
        PredefItem(name: "in_mangos".loc, price: 4, tag: fruits),
        PredefItem(name: "in_melons".loc, price: 2, tag: fruits),
        PredefItem(name: "in_nectarines".loc, price: 3, tag: fruits),
        PredefItem(name: "in_oranges".loc, price: 2, tag: fruits),
        PredefItem(name: "in_olives".loc, price: 4, tag: fruits),
        PredefItem(name: "in_pears".loc, price: 3, tag: fruits),
        PredefItem(name: "in_peaches".loc, price: 3, tag: fruits),
        PredefItem(name: "in_pineapple".loc, price: 2, tag: fruits),
        PredefItem(name: "in_pomegranate".loc, price: 4, tag: fruits),
        PredefItem(name: "in_plums".loc, price: 2, tag: fruits),
        PredefItem(name: "in_strawberries".loc, price: 3, tag: fruits),
        PredefItem(name: "in_watermelons".loc, price: 3, tag: fruits),
        PredefItem(name: "in_tomatoes".loc, price: 2, tag: fruits),

        // veggies
        PredefItem(name: "in_aspargus".loc, price: 5, tag: veggies),
        PredefItem(name: "in_broccoli".loc, price: 3, tag: veggies),
        PredefItem(name: "in_carrots".loc, price: 2, tag: veggies),
        PredefItem(name: "in_celery".loc, price: 2, tag: veggies),
        PredefItem(name: "in_champignons".loc, price: 2, tag: veggies),
        PredefItem(name: "in_garlic".loc, price: 1, tag: veggies),
        PredefItem(name: "in_kale".loc, price: 3, tag: veggies),
        PredefItem(name: "in_onions".loc, price: 2, tag: veggies),
        PredefItem(name: "in_white_onions".loc, price: 2, tag: veggies),
        PredefItem(name: "in_red_onions".loc, price: 2, tag: veggies),
        PredefItem(name: "in_lettuce".loc, price: 2, tag: veggies),
        PredefItem(name: "in_pepper".loc, price: 1, tag: veggies),
        PredefItem(name: "in_potatoes".loc, price: 2, tag: veggies),
        PredefItem(name: "in_sweet_potato".loc, price: 2, tag: veggies),
        PredefItem(name: "in_corn".loc, price: 1, tag: veggies),

        // beans
        PredefItem(name: "in_red_beans".loc, price: 2, tag: beans),
        PredefItem(name: "in_white_beans".loc, price: 2, tag: beans),
        PredefItem(name: "in_green_beans".loc, price: 2, tag: beans),

        // meat
        PredefItem(name: "in_chicken_breast".loc, price: 10, tag: meat),
        PredefItem(name: "in_chicken_wings".loc, price: 8, tag: meat),
        PredefItem(name: "in_chicken_drumsticks".loc, price: 8, tag: meat),
        PredefItem(name: "in_pork_5_min".loc, price: 6, tag: meat),
        PredefItem(name: "in_steak".loc, price: 10, tag: meat),
        PredefItem(name: "in_turkey".loc, price: 10, tag: meat),
        PredefItem(name: "in_grinded_meat".loc, price: 7, tag: meat),
        PredefItem(name: "in_salami".loc, price: 6, tag: meat),
        PredefItem(name: "in_liver_sausage".loc, price: 4, tag: meat),
        PredefItem(name: "in_beef".loc, price: 9, tag: meat),

        // fish
        PredefItem(name: "in_salmon".loc, price: 8, tag: fish),
        PredefItem(name: "in_sardines".loc, price: 5, tag: fish),
        PredefItem(name: "in_shrimps".loc, price: 6, tag: fish),
        PredefItem(name: "in_tuna".loc, price: 2, tag: fish),

     
        // sweets
        PredefItem(name: "in_ice_cream".loc, price: 2, tag: sweets),
        PredefItem(name: "in_popsicles".loc, price: 3, tag: sweets),
        PredefItem(name: "in_doughnuts".loc, price: 3, tag: sweets),
        PredefItem(name: "in_cake".loc, price: 3, tag: sweets),
        PredefItem(name: "in_pudding".loc, price: 2, tag: sweets),
        PredefItem(name: "in_cheese_cake".loc, price: 2, tag: sweets),
        PredefItem(name: "in_pie".loc, price: 2, tag: sweets),
        PredefItem(name: "in_strawberry_jam".loc, price: 2, tag: sweets),
        PredefItem(name: "in_peaches_jam".loc, price: 2, tag: sweets),
        PredefItem(name: "in_honey".loc, price: 1, tag: sweets),
        PredefItem(name: "in_lollipops".loc, price: 1, tag: sweets),
        PredefItem(name: "in_jelly_beans".loc, price: 2, tag: sweets),
        PredefItem(name: "in_chocolate".loc, price: 1, tag: sweets),
        PredefItem(name: "in_sour_candy".loc, price: 2, tag: sweets),
        PredefItem(name: "in_maoams".loc, price: 1.4, tag: sweets),
        
        // dairy
        PredefItem(name: "in_milk".loc, price: 2, tag: dairy),
        PredefItem(name: "in_cheese".loc, price: 2, tag: dairy),
        PredefItem(name: "in_blue_cheese".loc, price: 3, tag: dairy),
        PredefItem(name: "in_feta_cheese".loc, price: 2, tag: dairy),
        PredefItem(name: "in_goat_cheese".loc, price: 4, tag: dairy),
        PredefItem(name: "in_cream".loc, price: 2, tag: dairy),
        PredefItem(name: "in_butter".loc, price: 2, tag: dairy),
        PredefItem(name: "in_jogurt".loc, price: 1.2, tag: dairy),

        // hygiene
        PredefItem(name: "in_tooth_paste".loc, price: 4, tag: hygiene),
        PredefItem(name: "in_tooth_floss".loc, price: 2, tag: hygiene),
        PredefItem(name: "in_soap".loc, price: 2, tag: hygiene),
        PredefItem(name: "in_liquid_soap".loc, price: 2, tag: hygiene),
        PredefItem(name: "in_shampoo".loc, price: 3, tag: hygiene),
        PredefItem(name: "in_razors".loc, price: 2, tag: hygiene),
        PredefItem(name: "in_nail_clipper".loc, price: 2, tag: hygiene),
        PredefItem(name: "in_listerine".loc, price: 3, tag: hygiene),
        PredefItem(name: "in_towel".loc, price: 10, tag: hygiene),
        PredefItem(name: "in_sanitary_towels".loc, price: 4, tag: hygiene),
        PredefItem(name: "in_tampons".loc, price: 4, tag: hygiene),
        PredefItem(name: "in_condoms".loc, price: 3, tag: hygiene),
        PredefItem(name: "in_toilet_paper".loc, price: 5, tag: hygiene),

        // cleaning
        PredefItem(name: "in_dish_soap".loc, price: 4, tag: cleaning),
        PredefItem(name: "in_sponges".loc, price: 2, tag: cleaning),
        PredefItem(name: "in_wire_sponges".loc, price: 3, tag: cleaning),
        PredefItem(name: "in_cleaning_agent".loc, price: 5, tag: cleaning),
        PredefItem(name: "in_mob".loc, price: 10, tag: cleaning),
        PredefItem(name: "in_toothbrush".loc, price: 8, tag: cleaning),
        PredefItem(name: "in_window_cleaner".loc, price: 6, tag: cleaning),
        PredefItem(name: "in_oven_cleaner".loc, price: 8, tag: cleaning),
        
        // office
        PredefItem(name: "in_printing_cartridge".loc, price: 20, tag: office),
        PredefItem(name: "in_paper".loc, price: 5, tag: office),
        PredefItem(name: "in_pen".loc, price: 2, tag: office),
        PredefItem(name: "in_pencil".loc, price: 2, tag: office),
        PredefItem(name: "in_eraser".loc, price: 1, tag: office),
        PredefItem(name: "in_pencil_sharpener".loc, price: 2, tag: office),
        
        // alcohol
        PredefItem(name: "in_beer".loc, price: 1.2, tag: alcohol),
        PredefItem(name: "in_red_whine".loc, price: 10, tag: alcohol),
        PredefItem(name: "in_white_whine".loc, price: 10, tag: alcohol),
        PredefItem(name: "in_sangria".loc, price: 10, tag: alcohol),
        PredefItem(name: "in_whiskey".loc, price: 20, tag: alcohol),
        PredefItem(name: "in_rum".loc, price: 20, tag: alcohol),
        PredefItem(name: "in_bayleys".loc, price: 20, tag: alcohol),
        PredefItem(name: "in_brandy".loc, price: 20, tag: alcohol),

        // cigarettes
        PredefItem(name: "in_cigarettes".loc, price: 5, tag: cigarettes),

        // entertainment
        PredefItem(name: "in_comics".loc, price: 5, tag: entertainment),
        PredefItem(name: "in_magazines".loc, price: 5, tag: entertainment),
        PredefItem(name: "in_books".loc, price: 10, tag: entertainment),
    ]
}

extension String {
    var loc: String {
        return NSLocalizedString(self, comment: "")
    }
}
