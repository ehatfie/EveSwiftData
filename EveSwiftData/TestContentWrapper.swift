//
//  TestContentWrapper.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/9/25.
//

import SwiftUI
import SwiftData

@Observable class TestViewModel1 {
    let dataManager: DataManager
    let modelContext: ModelContext
    
    init(
        dataManager: DataManager,
        modelContext: ModelContext
    ) {
        self.dataManager = dataManager
        self.modelContext = modelContext
    }
    
    func loadData() {
        Task {
            await dataManager.loadData()
        }
    }
    
    func loadData(for file: YamlFiles) async {
        await dataManager.loadData(for: file)
        switch file {
        case .typeIDs:
            await addItems(dataManager.typeModels)
        default: return
        }
        
    }
    
    private func addItems(_ data: [TypeModel]) async {
        let modelContext = self.modelContext
        print("++ adding \(data.count) items")
        let start = Date()
        do {
            var maxBatchSize: Int = 1000
            var currentCount: Int = 0
            for item in data {
                
                modelContext.insert(item)
                currentCount += 1
                
                if currentCount == maxBatchSize {
                    try modelContext.save()
                    currentCount = 0
                }
                
            }
            try modelContext.save()
            print("Took \(Date().timeIntervalSince(start))")
        } catch let insertError {
            print("++ addItems insert error \(insertError)")
        }
    }
    
    func delete(){
        
    }
}

struct TestContentWrapper: View {
    @State var viewModel: TestViewModel1
    
    @Query private var items: [GroupModel]
    @Query private var items2: [TypeModel]
    
    var body: some View {
        NavigationSplitView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.name)")
                        
                    } label: {
                        Text(item.name)
                    }
                }
                .onDelete(perform: deleteItems)
            }
#if os(macOS)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
#endif
            .toolbar {
#if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
#endif
                ToolbarItem {
                    Button(action: loadData) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            detailView()
            
        }
    }
    
    @ViewBuilder
    func detailView() -> some View {
        VStack {
            Text("Item count \(items2.count)")
            HStack {
                ForEach([YamlFiles.groupIDs, YamlFiles.typeIDs], id: \.rawValue) { file in
                    Button(file.rawValue) {
                        Task {
                            await loadData(file: file)
                        }
                    }
                }
            }
            HStack {
                Button("Delete TypeModels") {
                    self.viewModel.delete()
                }
            }
            typeModelList()
        }
    }
    
    func typeModelList() -> some View {
        VStack {
            List(items2) { item in
                Text(item.name)
            }
        }
    }
    
    private func loadData() {
        viewModel.loadData()
    }
    
    private func loadData(file: YamlFiles) async {
        await viewModel.loadData(for: file)
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                //modelContext.delete(items[index])
            }
        }
    }
}

//#Preview {
//    TestContentWrapper()
//}
