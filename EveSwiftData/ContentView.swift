//
//  ContentView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/8/25.
//

import SwiftData
import SwiftUI

protocol IdentifiedStringProtocol: Identifiable, Hashable {
  var id: AnyHashable { get }
  var typeId: Int64 { get set }
  var value: String { get set }

  var content: [any IdentifiedStringProtocol]? { get }
}

struct MarketGroupString: IdentifiedStringProtocol, Hashable {
  var id: AnyHashable {
    typeId
  }
  var typeId: Int64
  var value: String

  var content: [any IdentifiedStringProtocol]?
  let content1: [MarketGroupString]? = nil

  static func == (lhs: MarketGroupString, rhs: MarketGroupString) -> Bool {
    return lhs.typeId == rhs.typeId
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(typeId)
    hasher.combine(value)

    if let contentA = content, let contentB = contentA as? [MarketGroupString] {
      hasher.combine(contentB)
    }
  }
}

struct TypeString: IdentifiedStringProtocol, Hashable {
  var id: AnyHashable {
    typeId
  }
  var typeId: Int64
  var value: String

  var content: [any IdentifiedStringProtocol]?
  let content1: [TypeString]? = nil

  static func == (lhs: TypeString, rhs: TypeString) -> Bool {
    return lhs.typeId == rhs.typeId
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(typeId)
    hasher.combine(value)

    if let contentA = content, let contentB = contentA as? [TypeString] {
      hasher.combine(contentB)
    }
  }
}

struct IdentifiedString: IdentifiedStringProtocol, Hashable {
  var id: AnyHashable {
    if let key {
      return key
    } else {
      return typeId
    }
  }
  var key: String? = nil
  var typeId: Int64
  var value: String

  var content: [any IdentifiedStringProtocol]?
  let content1: [IdentifiedString]? = nil

  static func == (lhs: IdentifiedString, rhs: IdentifiedString) -> Bool {
    return lhs.typeId == rhs.typeId
  }

  func hash(into hasher: inout Hasher) {
    hasher.combine(id)
    hasher.combine(typeId)
    hasher.combine(value)

    if let contentA = content, let contentB = contentA as? [IdentifiedString] {
      hasher.combine(contentB)
    }
  }
}

//typealias MarketGroupString = IdentifiedString
//typealias TypeString = IdentifiedString

extension Array where Element == (any IdentifiedStringProtocol) {
  func hash(into hasher: inout Hasher) {
    for element in self {
      hasher.combine(element)
    }
  }
}

@Observable class TestViewModel {
  //let dataManager: DataManager = DataManager()

  init() {}

  func loadData() {
    Task {
      //await dataManager.loadData()
    }
  }

  func loadData(for file: YamlFiles) async {

  }
}

struct ContentView: View {
  @Environment(ModelData.self) var modelData

  @State private var preferredColumn: NavigationSplitViewColumn = .detail

  @Query private var items: [GroupModel]
  @Query private var items2: [TypeModel]

  @State var viewModel: TestViewModel  // = TestViewModel()

  init() {
    self.viewModel = TestViewModel()

    //loadThing()
  }

  var body: some View {
    @Bindable var modelData = modelData
    HStack {
      VStack {
        sidebarView()
      }

      VStack {
        ShipFittingView(
          viewModel: ShipFittingViewModel(
            modelData: modelData,
            typeId: 0
          )
        )
        //detailView()
      }
    }.onAppear {
      //Task {
      //await modelData.dataManager.loadData(for: .marketGroups)
      //}
    }
    EmptyView()
  }

  @ViewBuilder
  func sidebarView() -> some View {
    VStack {
      List {
        OutlineGroup(
          modelData.sidebarItems,
          id: \.id,
          children: \.content
        ) { value in
          HStack {
            Text(value.value + " \(value.id)")
              .font(.subheadline)
          }
        }
      }
    }
  }

  @ViewBuilder
  func detailView() -> some View {
    VStack {
      Text("Item count \(items2.count)")
      HStack {
        ForEach(
          [YamlFiles.groupIDs, YamlFiles.typeIDs, YamlFiles.categoryIDs],
          id: \.rawValue
        ) { file in
          Button(file.rawValue) {
            Task {
              await loadData(file: file)
            }
          }
        }
      }
      HStack {
        Button("Delete TypeModels") {
          self.delete()
        }
      }

      //            if !viewModel.dataManager.groupModels.isEmpty {
      //                Button("Save") {
      //                    withAnimation {
      //                        for item in self.viewModel.dataManager.groupModels {
      //                            //modelContext.insert(item)
      //                        }
      //                    }
      //                }
      //            }
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

  private func loadData(file: YamlFiles) async {
    await modelData.dataManager.loadData(for: file)
    //await viewModel.loadData(for: file)

    switch file {
    case .typeIDs:
      return
    //await self.addItems(self.viewModel.dataManager.typeModels)
    default: break
    }
  }

  private func addItems(_ data: [TypeModel], to modelContext: ModelContext)
    async
  {
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

  private func addItem() {
    withAnimation {
      let newItem = Item(timestamp: Date())
      //modelContext.insert(newItem)
    }
  }

  private func delete() {
    for item in items2 {
      //modelContext.delete(item)
    }
  }

  private func deleteItems(offsets: IndexSet) {
    withAnimation {
      for index in offsets {
        //modelContext.delete(items[index])
      }
    }
  }

  private func loadData() {
    viewModel.loadData()
  }
}

#Preview {
  ContentView()
    .modelContainer(for: Item.self, inMemory: true)
}
