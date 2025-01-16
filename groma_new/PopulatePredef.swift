import SwiftData

// note that on start this is called like 13 times.
// could optimize this by setting a flag, but probably isn't that much of an issue.
func checkAndPopulateData(modelContext: ModelContext) {
    print("## in checkAndPopulateData")
    let fetchRequest = FetchDescriptor<PredefItem>()
    let existingRecords = try? modelContext.fetch(fetchRequest)
    
    // populate only once in lifecycle of app
    if existingRecords?.isEmpty ?? true {
        print("## records are empty, populating")
        populatePredefinedData(modelContext: modelContext)
    }
}

func populatePredefinedData(modelContext: ModelContext) {
    let predefinedData = [
        PredefItem(name: "Celery", price: 2, tag: "Veggies"),
        PredefItem(name: "Blue cheese", price: 3, tag: "Dairy"),
        PredefItem(name: "Baguette", price: 1, tag: "Bread"),
        PredefItem(name: "4 Breads", price: 2, tag: "Bread"),
        PredefItem(name: "Grinded Meat", price: 6, tag: "Meat"),
        PredefItem(name: "Eggs 6x", price: 3, tag: "Eggs"),
        PredefItem(name: "Sweet potato", price: 0.50, tag: "Veggies"),
        PredefItem(name: "Pepper", price: 1, tag: "Veggies"),
        PredefItem(name: "Pepper bag", price: 3, tag: "Veggies"),
        PredefItem(name: "Champignons", price: 2, tag: "Veggies"),
        PredefItem(name: "Fast pork", price: 4, tag: "Meat"),
        PredefItem(name: "Potatoes 500g", price: 4, tag: "Veggies"),
        PredefItem(name: "Florida Eis big", price: 5, tag: "Sweets"),
        PredefItem(name: "Florida Eis small", price: 2, tag: "Sweets"),
        PredefItem(name: "Tomatoes", price: 2, tag: "Veggies"),
        PredefItem(name: "Pears 5x", price: 2, tag: "Fruits"),
        PredefItem(name: "Bananas 6x", price: 3, tag: "Fruits"),
        PredefItem(name: "Oranges net", price: 2, tag: "Fruits"),
        PredefItem(name: "Chicken breast", price: 15, tag: "Meat"),
        PredefItem(name: "Rinder roulade", price: 7, tag: "Meat"),
        PredefItem(name: "Red beans can", price: 2, tag: "Veggies"),
        PredefItem(name: "Parsley", price: 2, tag: "Spices"),
        PredefItem(name: "Rosemary", price: 2, tag: "Spices"),
        PredefItem(name: "Cilantro", price: 2, tag: "Spices"),
        PredefItem(name: "Kale", price: 3, tag: "Veggies"),
        PredefItem(name: "Jogurt", price: 2, tag: "Dairy"),
        PredefItem(name: "Olive Oil", price: 8, tag: "Oil"),
        PredefItem(name: "Onions", price: 2, tag: "Veggies"),
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
        PredefItem(name: "Garlic", price: 2, tag: "Veggies"),
        PredefItem(name: "Avocado", price: 3, tag: "Fruits"),
        PredefItem(name: "Steak", price: 15, tag: "Meat"),
        PredefItem(name: "Olives", price: 5, tag: "Fruits"),
        PredefItem(name: "Feta", price: 2, tag: "Dairy"),
        PredefItem(name: "Lemons", price: 2, tag: "Fruit"),
        PredefItem(name: "Limes", price: 2, tag: "Fruit"),
        PredefItem(name: "Basmati rice", price: 2, tag: "Grains"),
        PredefItem(name: "Rice", price: 2, tag: "Grains"),
        PredefItem(name: "Chicken wings", price: 6, tag: "Meat"),
        PredefItem(name: "Cat sand", price: 7, tag: "Pet"),
        PredefItem(name: "Broccoli", price: 3, tag: "Veggies"),
    ]
    
    for data in predefinedData {
        modelContext.insert(data)
    }
    
    do {
        try modelContext.save()
        print("Predefined data added successfully.")
    } catch {
        print("Error saving predefined data: \(error)")
    }
}
