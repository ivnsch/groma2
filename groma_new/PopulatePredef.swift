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
    let fruits = "fruits".loc
    let veggies = "veggies".loc
    let meat = "meat".loc
    let fish = "fish".loc
    let sweets = "sweets".loc
    let eggs = "eggs".loc
    let grains = "grains".loc
    let beans = "beans".loc
    let drinks = "drinks".loc
    let oil = "oil".loc
    let spices = "spices".loc
    let pet = "pet".loc
    let hygiene = "hygiene".loc
    let cleaning = "cleaning".loc
    let office = "office".loc
    let alcohol = "alcohol".loc
    let cigarettes = "cigarettes".loc
    let entertainment = "entertainment".loc

    let predefinedData = [
        // pet
        PredefItem(name: "cat_food", price: 0, tag: pet),
        PredefItem(name: "dog_food", price: 0, tag: pet),
        PredefItem(name: "cat_sand", price: 0, tag: pet),

        // drinks
        PredefItem(name: "in_club_mate", price: 0, tag: drinks),
        PredefItem(name: "in_black_currant_juice", price: 0, tag: drinks),
        PredefItem(name: "in_coca_cola", price: 0, tag: drinks),
        PredefItem(name: "in_sprite", price: 0, tag: drinks),
        PredefItem(name: "in_fanta", price: 0, tag: drinks),
        PredefItem(name: "in_pepsi", price: 0, tag: drinks),
        
        // oil
        PredefItem(name: "olive_oil", price: 0, tag: oil),

        // spices
        PredefItem(name: "salt", price: 0, tag: spices),
        PredefItem(name: "black_pepper", price: 0, tag: spices),
        PredefItem(name: "cumin", price: 0, tag: spices),
        PredefItem(name: "saffron", price: 0, tag: spices),
        PredefItem(name: "cloves", price: 0, tag: spices),
        PredefItem(name: "chillis", price: 0, tag: spices),
        PredefItem(name: "mace", price: 0, tag: spices),
        PredefItem(name: "cardamom".loc, price: 0, tag: spices),
        PredefItem(name: "ginger".loc, price: 0, tag: spices),
        PredefItem(name: "turmeric".loc, price: 0, tag: spices),
        PredefItem(name: "parsley".loc, price: 0, tag: spices),
        PredefItem(name: "basil".loc, price: 0, tag: spices),
        PredefItem(name: "mint".loc, price: 0, tag: spices),
        PredefItem(name: "coriander".loc, price: 0, tag: spices),
        PredefItem(name: "rosemary".loc, price: 0, tag: spices),

        // eggs
        PredefItem(name: "eggs_6", price: 0, tag: eggs),
        PredefItem(name: "eggs_12", price: 0, tag: eggs),
        
        // grains
        PredefItem(name: "rice_basmati".loc, price: 0, tag: grains),
        PredefItem(name: "lentils".loc, price: 0, tag: grains),

        // bread
        PredefItem(name: "baguette", price: 0, tag: "Bread"),
        PredefItem(name: "bread_loaf", price: 0, tag: "Bread"),
        PredefItem(name: "bread_bundle_4", price: 0, tag: "Bread"),

        // fruits
        PredefItem(name: "apples".loc, price: 0, tag: fruits),
        PredefItem(name: "avocado".loc, price: 0, tag: fruits),
        PredefItem(name: "bananas".loc, price: 0, tag: fruits),
        PredefItem(name: "blackberries".loc, price: 0, tag: fruits),
        PredefItem(name: "blueberries".loc, price: 0, tag: fruits),
        PredefItem(name: "cranberries".loc, price: 0, tag: fruits),
        PredefItem(name: "cherries".loc, price: 0, tag: fruits),
        PredefItem(name: "coconut".loc, price: 0, tag: fruits),
        PredefItem(name: "currant".loc, price: 0, tag: fruits),
        PredefItem(name: "kiwis".loc, price: 0, tag: fruits),
        PredefItem(name: "red grapes".loc, price: 0, tag: fruits),
        PredefItem(name: "green grapes".loc, price: 0, tag: fruits),
        PredefItem(name: "black grapes".loc, price: 0, tag: fruits),
        PredefItem(name: "grapes".loc, price: 0, tag: fruits),
        PredefItem(name: "lemons".loc, price: 0, tag: fruits),
        PredefItem(name: "limes".loc, price: 0, tag: fruits),
        PredefItem(name: "mandarines".loc, price: 0, tag: fruits),
        PredefItem(name: "mangos".loc, price: 0, tag: fruits),
        PredefItem(name: "melons".loc, price: 0, tag: fruits),
        PredefItem(name: "nectarines".loc, price: 0, tag: fruits),
        PredefItem(name: "oranges".loc, price: 0, tag: fruits),
        PredefItem(name: "olives".loc, price: 0, tag: fruits),
        PredefItem(name: "pears".loc, price: 0, tag: fruits),
        PredefItem(name: "peaches".loc, price: 0, tag: fruits),
        PredefItem(name: "pineapple".loc, price: 0, tag: fruits),
        PredefItem(name: "pomegranate".loc, price: 0, tag: fruits),
        PredefItem(name: "plums".loc, price: 0, tag: fruits),
        PredefItem(name: "strawberries".loc, price: 0, tag: fruits),
        PredefItem(name: "watermelons".loc, price: 0, tag: fruits),
        PredefItem(name: "tomatoes", price: 0, tag: fruits),

        // veggies
        PredefItem(name: "aspargus".loc, price: 0, tag: veggies),
        PredefItem(name: "broccoli".loc, price: 0, tag: veggies),
        PredefItem(name: "carrots".loc, price: 0, tag: veggies),
        PredefItem(name: "celery".loc, price: 0, tag: veggies),
        PredefItem(name: "champignons".loc, price: 0, tag: veggies),
        PredefItem(name: "garlic".loc, price: 0, tag: veggies),
        PredefItem(name: "kale".loc, price: 0, tag: veggies),
        PredefItem(name: "onions".loc, price: 0, tag: veggies),
        PredefItem(name: "white onions".loc, price: 0, tag: veggies),
        PredefItem(name: "red onions".loc, price: 0, tag: veggies),
        PredefItem(name: "lettuce".loc, price: 0, tag: veggies),
        PredefItem(name: "pepper".loc, price: 0, tag: veggies),
        PredefItem(name: "potatoes", price: 0, tag: veggies),
        PredefItem(name: "sweet_potato".loc, price: 0, tag: veggies),
        PredefItem(name: "corn".loc, price: 0, tag: veggies),

        // beans
        PredefItem(name: "red_beans".loc, price: 0, tag: beans),
        PredefItem(name: "white_beans".loc, price: 0, tag: beans),
        PredefItem(name: "green_beans".loc, price: 0, tag: beans),

        // meat
        PredefItem(name: "chicken_breast".loc, price: 0, tag: meat),
        PredefItem(name: "chicken_wings".loc, price: 0, tag: meat),
        PredefItem(name: "chicken_drumsticks".loc, price: 0, tag: meat),
        PredefItem(name: "pork_5_min".loc, price: 0, tag: meat),
        PredefItem(name: "steak".loc, price: 0, tag: meat),
        PredefItem(name: "turkey".loc, price: 0, tag: meat),
        PredefItem(name: "grinded_meat".loc, price: 0, tag: meat),
        PredefItem(name: "salami", price: 0, tag: meat),
        PredefItem(name: "liver_sausage", price: 0, tag: meat),

        // fish
        PredefItem(name: "salmon".loc, price: 0, tag: fish),
        PredefItem(name: "sardines".loc, price: 0, tag: fish),
        PredefItem(name: "shrimps".loc, price: 0, tag: fish),
        PredefItem(name: "tuna".loc, price: 0, tag: fish),

     
        // sweets
        PredefItem(name: "ice_big".loc, price: 0, tag: sweets),
        PredefItem(name: "ice_small".loc, price: 0, tag: sweets),
        PredefItem(name: "popsicles".loc, price: 0, tag: sweets),
        PredefItem(name: "doughnuts".loc, price: 0, tag: sweets),
        PredefItem(name: "cake".loc, price: 0, tag: sweets),
        PredefItem(name: "pudding".loc, price: 0, tag: sweets),
        PredefItem(name: "cheese cake".loc, price: 0, tag: sweets),
        PredefItem(name: "pie".loc, price: 0, tag: sweets),
        PredefItem(name: "strawberry_jam".loc, price: 0, tag: sweets),
        PredefItem(name: "peaches_jam".loc, price: 0, tag: sweets),
        PredefItem(name: "honey".loc, price: 0, tag: sweets),
        PredefItem(name: "gummy_bears".loc, price: 0, tag: sweets),
        PredefItem(name: "lollipops".loc, price: 0, tag: sweets),
        PredefItem(name: "jelly_beans".loc, price: 0, tag: sweets),
        PredefItem(name: "chocolate".loc, price: 0, tag: sweets),
        PredefItem(name: "sour_candy".loc, price: 0, tag: sweets),
        PredefItem(name: "maoams", price: 0, tag: sweets),
        
        // dairy
        PredefItem(name: "milk".loc, price: 0, tag: sweets),
        PredefItem(name: "cheese".loc, price: 0, tag: sweets),
        PredefItem(name: "blue_cheese".loc, price: 0, tag: sweets),
        PredefItem(name: "feta_cheese".loc, price: 0, tag: sweets),
        PredefItem(name: "goat_cheese".loc, price: 0, tag: sweets),
        PredefItem(name: "cream".loc, price: 0, tag: sweets),
        PredefItem(name: "butter".loc, price: 0, tag: sweets),
        PredefItem(name: "jogurt".loc, price: 0, tag: sweets),

        // hygiene
        PredefItem(name: "tooth_paste", price: 0, tag: hygiene),
        PredefItem(name: "tooth_floss", price: 0, tag: hygiene),
        PredefItem(name: "soap", price: 0, tag: hygiene),
        PredefItem(name: "liquid soap", price: 0, tag: hygiene),
        PredefItem(name: "shampoo", price: 0, tag: hygiene),
        PredefItem(name: "razors", price: 0, tag: hygiene),
        PredefItem(name: "nail clipper", price: 0, tag: hygiene),
        PredefItem(name: "listerine", price: 0, tag: hygiene),
        PredefItem(name: "towel", price: 0, tag: hygiene),
        PredefItem(name: "sanitary towels", price: 0, tag: hygiene),
        PredefItem(name: "tampons", price: 0, tag: hygiene),
        PredefItem(name: "condoms", price: 0, tag: hygiene),
        
        // cleaning
        PredefItem(name: "dish soap", price: 0, tag: cleaning),
        PredefItem(name: "sponges", price: 0, tag: cleaning),
        PredefItem(name: "wire sponges", price: 0, tag: cleaning),
        PredefItem(name: "cleaning agent", price: 0, tag: cleaning),
        PredefItem(name: "mob", price: 0, tag: cleaning),
        PredefItem(name: "toothbrush", price: 0, tag: cleaning),
        PredefItem(name: "window_cleaner", price: 0, tag: cleaning),
        PredefItem(name: "oven_cleaner", price: 0, tag: cleaning),
        
        // office
        PredefItem(name: "printing_cartridge", price: 0, tag: office),
        PredefItem(name: "paper", price: 0, tag: office),
        PredefItem(name: "pen", price: 0, tag: office),
        PredefItem(name: "pencil", price: 0, tag: office),
        PredefItem(name: "eraser", price: 0, tag: office),
        PredefItem(name: "pencil_sharpener", price: 0, tag: office),
        
        // alcohol
        PredefItem(name: "beer", price: 0, tag: alcohol),
        PredefItem(name: "red whine", price: 0, tag: alcohol),
        PredefItem(name: "white whine", price: 0, tag: alcohol),
        PredefItem(name: "sangria", price: 0, tag: alcohol),
        PredefItem(name: "whiskey", price: 0, tag: alcohol),
        PredefItem(name: "rum", price: 0, tag: alcohol),
        PredefItem(name: "bayleys", price: 0, tag: alcohol),
        PredefItem(name: "brandy", price: 0, tag: alcohol),

        // cigarettes
        PredefItem(name: "cigarettes", price: 0, tag: cigarettes),

        // entertainment
        PredefItem(name: "comics", price: 0, tag: entertainment),
        PredefItem(name: "magazines", price: 0, tag: entertainment),
        PredefItem(name: "books", price: 0, tag: entertainment),
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
