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

    let predefinedData = [
        PredefItem(name: "Blue cheese", price: 3, tag: "Dairy"),
        PredefItem(name: "Baguette", price: 1, tag: "Bread"),
        PredefItem(name: "4 Breads", price: 2, tag: "Bread"),
        PredefItem(name: "Grinded Meat", price: 6, tag: "Meat"),
        PredefItem(name: "Eggs 6x", price: 3, tag: "Eggs"),

        PredefItem(name: "Florida Eis big", price: 5, tag: "Sweets"),
        PredefItem(name: "Florida Eis small", price: 2, tag: "Sweets"),
        PredefItem(name: "Chicken breast", price: 15, tag: "Meat"),
        PredefItem(name: "Rinder roulade", price: 7, tag: "Meat"),
        PredefItem(name: "Parsley", price: 2, tag: "Spices"),
        PredefItem(name: "Rosemary", price: 2, tag: "Spices"),
        PredefItem(name: "Cilantro", price: 2, tag: "Spices"),
        PredefItem(name: "Jogurt", price: 2, tag: "Dairy"),
        PredefItem(name: "Olive Oil", price: 8, tag: "Oil"),
        PredefItem(name: "Black currant juice", price: 4, tag: "Fruits"),
        PredefItem(name: "Maoams", price: 2, tag: "Sweets"),
        PredefItem(name: "Club mate", price: 1, tag: "Drinks"),
        PredefItem(name: "Milk", price: 2, tag: "Dairy"),
        PredefItem(name: "Cream big", price: 2, tag: "Dairy"),
        PredefItem(name: "Cream small", price: 1, tag: "Dairy"),
        PredefItem(name: "Honey", price: 3, tag: "Sweets"),
        PredefItem(name: "Salt", price: 1, tag: "Spices"),
        PredefItem(name: "Butter", price: 2, tag: "Dairy"),
        PredefItem(name: "Tuna", price: 2, tag: "Meat"),
        PredefItem(name: "Liver sausage", price: 2, tag: "Meat"),
        PredefItem(name: "Salami", price: 3, tag: "Meat"),
        PredefItem(name: "Cat food", price: 2, tag: "Pet"),
        PredefItem(name: "Chicken slices", price: 3, tag: "Meat"),
        PredefItem(name: "Tooth paste", price: 5, tag: "hygiene"),
        PredefItem(name: "Turkey", price: 10, tag: "Meat"),
        PredefItem(name: "Steak", price: 15, tag: "Meat"),
        PredefItem(name: "Feta", price: 2, tag: "Dairy"),
        PredefItem(name: "Basmati rice", price: 2, tag: "Grains"),
        PredefItem(name: "Rice", price: 2, tag: "Grains"),
        PredefItem(name: "Chicken wings", price: 6, tag: "Meat"),
        PredefItem(name: "Cat sand", price: 7, tag: "Pet"),
        
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
        PredefItem(name: "red_beans".loc, price: 0, tag: veggies),
        PredefItem(name: "sweet_potato".loc, price: 0, tag: veggies),
        
        // Meat
        PredefItem(name: "chicken_breast".loc, price: 0, tag: meat),
        PredefItem(name: "chicken_wings".loc, price: 0, tag: meat),
        PredefItem(name: "chicken_drumsticks".loc, price: 0, tag: meat),
        PredefItem(name: "pork_5_min".loc, price: 0, tag: meat),
        PredefItem(name: "steak".loc, price: 0, tag: meat),
        PredefItem(name: "turkey".loc, price: 0, tag: meat),
        
        // Fish
        PredefItem(name: "salmon".loc, price: 0, tag: fish),
        PredefItem(name: "sardines".loc, price: 0, tag: fish),
        PredefItem(name: "shrimps".loc, price: 0, tag: fish),
        PredefItem(name: "tuna".loc, price: 0, tag: fish),


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
