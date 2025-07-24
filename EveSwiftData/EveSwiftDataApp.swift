//
//  EveSwiftDataApp.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/8/25.
//

import SwiftUI
import SwiftData

@main
struct EveSwiftDataApp: App {
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            CategoryModel.self,
            GroupModel.self,
            TypeModel.self,
            MarketGroupModel.self
        ])
        
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()
    
    @State var modelData: ModelData
    
    init() {
        self.modelData = ModelData(modelContext: sharedModelContainer.mainContext)
    }

    var body: some Scene {
        WindowGroup {
            //TestContentWrapper(viewModel: TestViewModel1(dataManager: modelData.dataManager, modelContext: modelData.modelContext))
            TestNavigationSplitView()
                .environment(modelData)
//            ContentView()
//                .environment(modelData)
        }
        .modelContainer(sharedModelContainer)
    }
}
