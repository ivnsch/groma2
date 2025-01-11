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
        PredefItem(name: "Celery", price: 2),
        PredefItem(name: "Blue cheese", price: 3),
        PredefItem(name: "Baguette", price: 1),
        PredefItem(name: "4 breads", price: 2),
        PredefItem(name: "Grinded meat", price: 6),
        PredefItem(name: "Eggs 6x", price: 3),
        PredefItem(name: "Sweet potato", price: 0.50),
        PredefItem(name: "Pepper", price: 1),
        PredefItem(name: "Pepper bag", price: 3),
        PredefItem(name: "Champignons", price: 2),
        PredefItem(name: "Fast pork", price: 4),
        PredefItem(name: "Potatoes 500g", price: 4),
        PredefItem(name: "Florida Eis big", price: 5),
        PredefItem(name: "Florida Eis small", price: 2),
        PredefItem(name: "Tomatoes", price: 2),
        PredefItem(name: "Pears 5x", price: 2),
        PredefItem(name: "Bananas 6x", price: 3),
        PredefItem(name: "Oranges net", price: 2),
        PredefItem(name: "Chicken breast", price: 15),
        PredefItem(name: "Rinder roulade", price: 7),
        PredefItem(name: "Red beans can", price: 2),
        PredefItem(name: "Parsley", price: 2),
        PredefItem(name: "Rosemary", price: 2),
        PredefItem(name: "Cilantro", price: 2),
        PredefItem(name: "Kale", price: 3),
        PredefItem(name: "Jogurt", price: 2),
        PredefItem(name: "Olive oil", price: 8),
        PredefItem(name: "Onions", price: 2),
        PredefItem(name: "Black currant juice", price: 4),
        PredefItem(name: "Maoams", price: 2),
        PredefItem(name: "Club mate", price: 1),
        PredefItem(name: "Milk", price: 2),
        PredefItem(name: "Cream big", price: 2),
        PredefItem(name: "Cream small", price: 1),
        PredefItem(name: "Honey", price: 3),
        PredefItem(name: "Salt", price: 1),
        PredefItem(name: "Butter", price: 2),
        PredefItem(name: "Tuna", price: 2),
        PredefItem(name: "Liver sausage", price: 2),
        PredefItem(name: "Salami", price: 3),
        PredefItem(name: "Cat food", price: 2),
        PredefItem(name: "Chicken slices", price: 3),
        PredefItem(name: "Tooth paste", price: 5),
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
