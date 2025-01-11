import SwiftData

func checkAndPopulateData(modelContext: ModelContext) {
    let fetchRequest = FetchDescriptor<PredefItem>()
    let existingRecords = try? modelContext.fetch(fetchRequest)
    
    // populate only once in lifecycle of app
    if existingRecords?.isEmpty ?? true {
        populatePredefinedData(modelContext: modelContext)
    }
}

func populatePredefinedData(modelContext: ModelContext) {
    let predefinedData = [
        PredefItem(name: "Celery", price: 2, tags: ["veggies"]),
        PredefItem(name: "Blue cheese", price: 3, tags: ["dairy"]),
        PredefItem(name: "Baguette", price: 1, tags: ["bread"]),
        PredefItem(name: "4 breads", price: 2, tags: ["bread"]),
        PredefItem(name: "Grinded meat", price: 6, tags: ["meat"]),
        PredefItem(name: "Eggs 6x", price: 3, tags: ["eggs"]),
        PredefItem(name: "Sweet potato", price: 0.50, tags: ["veggies"]),
        PredefItem(name: "Pepper", price: 1, tags: ["veggies"]),
        PredefItem(name: "Pepper bag", price: 3, tags: ["veggies"]),
        PredefItem(name: "Champignons", price: 2, tags: ["veggies"]),
        PredefItem(name: "Fast pork", price: 4, tags: ["meat"]),
        PredefItem(name: "Potatoes 500g", price: 4, tags: ["veggies"]),
        PredefItem(name: "Florida Eis big", price: 5, tags: ["sweets"]),
        PredefItem(name: "Florida Eis small", price: 2, tags: ["sweets"]),
        PredefItem(name: "Tomatoes", price: 2, tags: ["veggies"]),
        PredefItem(name: "Pears 5x", price: 2, tags: ["fruits"]),
        PredefItem(name: "Bananas 6x", price: 3, tags: ["fruits"]),
        PredefItem(name: "Oranges net", price: 2, tags: ["fruits"]),
        PredefItem(name: "Chicken breast", price: 15, tags: ["meat"]),
        PredefItem(name: "Rinder roulade", price: 7, tags: ["meat"]),
        PredefItem(name: "Red beans can", price: 2, tags: ["veggies"]),
        PredefItem(name: "Parsley", price: 2, tags: ["spices"]),
        PredefItem(name: "Rosemary", price: 2, tags: ["spices"]),
        PredefItem(name: "Cilantro", price: 2, tags: ["spices"]),
        PredefItem(name: "Kale", price: 3, tags: ["veggies"]),
        PredefItem(name: "Jogurt", price: 2, tags: ["dairy"]),
        PredefItem(name: "Olive oil", price: 8, tags: ["oil"]),
        PredefItem(name: "Onions", price: 2, tags: ["veggies"]),
        PredefItem(name: "Black currant juice", price: 4, tags: ["fruits"]),
        PredefItem(name: "Maoams", price: 2, tags: ["sweets"]),
        PredefItem(name: "Club mate", price: 1, tags: ["drinks"]),
        PredefItem(name: "Milk", price: 2, tags: ["dairy"]),
        PredefItem(name: "Cream big", price: 2, tags: ["dairy"]),
        PredefItem(name: "Cream small", price: 1, tags: ["dairy"]),
        PredefItem(name: "Honey", price: 3, tags: ["sweets"]),
        PredefItem(name: "Salt", price: 1, tags: ["spices"]),
        PredefItem(name: "Butter", price: 2, tags: ["dairy"]),
        PredefItem(name: "Tuna", price: 2, tags: ["meat"]),
        PredefItem(name: "Liver sausage", price: 2, tags: ["meat"]),
        PredefItem(name: "Salami", price: 3, tags: ["meat"]),
        PredefItem(name: "Cat food", price: 2, tags: ["pet"]),
        PredefItem(name: "Chicken slices", price: 3, tags: ["meat"]),
        PredefItem(name: "Tooth paste", price: 5, tags: ["hygiene"]),
        PredefItem(name: "Turkey", price: 10, tags: ["meat"]),
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
