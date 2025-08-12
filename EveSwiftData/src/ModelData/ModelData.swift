//
//  ModelData.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/8/25.
//
import Foundation
import SwiftUI
import SwiftData

@Observable @MainActor
class ModelData {
  var modelContext: ModelContext
  let dataManager: DataManager // = DataManager()
  var fittingEngine: FittingEngine
  
  var isItemInspectorPresented: Bool = false
  var searchString: String = ""
  
  var sidebarItems: [any IdentifiedStringProtocol] = []
  
  var path: NavigationPath = NavigationPath() {
    didSet {
      // Check if the person navigates away from a view that's showing the inspector.
      if path.count < oldValue.count && isItemInspectorPresented == true {
        // Dismiss the inspector.
        isItemInspectorPresented = false
      }
    }
  }
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
    self.dataManager = DataManager(modelContext: modelContext)
    self.fittingEngine = FittingEngine(modelContext: modelContext)
    Task {
      await makeSidebarItems()
      //await makeFittingSidebarItems1()
    }
  }
  
  func makeFittingSidebarItems() async {
    let context = modelContext
    let category: Int64 = 6
    
    let groupFetch = FetchDescriptor(
      predicate: GroupModel.predicate(categoryId: category)
    )
    
    do {
      let groupModels = try context.fetch(groupFetch)
      let fits = await getFitsForGroups(groups: groupModels)
      self.sidebarItems = fits
      print("++ made \(fits.count) objects")
    } catch let fetchError {
      print("++ Error fetching fitting sidebar items: \(fetchError)")
    }
  }
  
  func getFittingModels() -> [ShipFittingModel] {
    let context = modelContext
    let result = try? context.fetch(
      FetchDescriptor(predicate: ShipFittingModel.predicate())
    )
    return result ?? []
  }
  
  func makeFittingSidebarItems1() async {
    let context = modelContext
    let category: Int64 = 6
    let fits = getFittingModels()
    let displayable = fits.map { ShipFittingString(data: $0)}
    self.sidebarItems = displayable
  }

  func getTypes(for groupModel: GroupModel) -> [TypeModel] {
    let modelContext = modelContext
    let result = try? modelContext.fetch(
      FetchDescriptor(predicate: TypeModel.predicate(groupId: groupModel.groupId))
    )
    return result ?? []
  }

  func getFits(for typeId: Int64) -> [ShipFittingModel] {
    let modelContext = modelContext
    
    let fetchDescriptor = FetchDescriptor(
      predicate: ShipFittingModel.predicate(typeId: typeId)
    )
    return (try? modelContext.fetch(fetchDescriptor)) ?? []
  }
  
  func makeSidebarItems() async {
    let context = modelContext
    let supportedMarketGroups: Set<Int> = [
//        157, 1112,
//        1111,
//        24,
//        4,
        11,
        9
    ]
    let rootMarketGroupsFetch = FetchDescriptor<MarketGroupModel>(
      predicate: #Predicate { supportedMarketGroups.contains($0.marketGroupId) },
      sortBy: [
        //.init(\.start)
      ]
    )
    //upcomingTrips.fetchLimit = 50
    //upcomingTrips.includePendingChanges = true
    
    do {
      let start = Date()
      let rootMarketGroups = try context.fetch(rootMarketGroupsFetch)
        print("++ rootMarketGroupsFetch took \(Date().timeIntervalSince(start)) for \(rootMarketGroups.count) items")
      var sidebarItems: [any IdentifiedStringProtocol] = []
      sidebarItems = await withTaskGroup(
        of: (any IdentifiedStringProtocol).self,
        returning: [any IdentifiedStringProtocol].self
      ) { taskGroup in
        for marketGroup in rootMarketGroups {
          taskGroup.addTask {
            let marketGroupId = marketGroup.marketGroupId
            let start2 = Date()
            let childIdentifiers: [any IdentifiedStringProtocol]? = await self.getChildIdentifiersAsync(for: marketGroupId)
            print("++ top level identifiers took \(Date().timeIntervalSince(start2))")
            return MarketGroupString(
              typeId: Int64(marketGroup.marketGroupId),
              value: marketGroup.name,
              content: childIdentifiers
            )
          }
        }
        var returnValues: [any IdentifiedStringProtocol] = []
        
        for await result in taskGroup {
          returnValues.append(result)
        }

        return returnValues
      }
      print("sidebar tooks \(Date().timeIntervalSince(start))")
      //let sidebarItems = rootMarketGroups.map { IdentifiedString(typeId: Int64($0.marketGroupId), value: $0.name)}
      self.sidebarItems = sidebarItems
    } catch let err {
      print("context load error \(err)")
    }
    
  }
  
  // this can be faster async but I dont want to do it right now
  func getChildIdentifiers(for marketGroupId: Int) -> [IdentifiedString]? {
    let context = self.modelContext
    var childIdentifiers: [IdentifiedString] = []
    let fetch = FetchDescriptor<MarketGroupModel>(
      predicate: #Predicate { $0.parentGroupId == marketGroupId },
      sortBy: []
    )
    
    do {
      let childMarketGroups = try context.fetch(fetch)
      print("++ found \(childMarketGroups.count) childMarketGroups")
      guard !childMarketGroups.isEmpty else {
        // here we should be fetching type models
        childIdentifiers = getTypeModelIdentifiers(for: marketGroupId)
          
        return childIdentifiers
      }
      
      childIdentifiers = childMarketGroups.map { child in
        let childContent = getChildIdentifiers(for: child.marketGroupId)
        let value = IdentifiedString(
          typeId: Int64(child.marketGroupId),
          value: child.name,
          content: childContent
        )
        return value
      }
      return childIdentifiers
    } catch let err {
      print("ERr \(err)")
      return []
    }
  }
  
  func getChildIdentifiersAsync(for marketGroupId: Int) async -> [any IdentifiedStringProtocol]? {
    let context = self.modelContext
    var childIdentifiers: [any IdentifiedStringProtocol] = []
    let fetch = FetchDescriptor<MarketGroupModel>(
      predicate: #Predicate { $0.parentGroupId == marketGroupId },
      sortBy: []
    )
    
    let start = Date()
    do {
      let childMarketGroups = try context.fetch(fetch)
      //print("++ found \(childMarketGroups.count) childMarketGroups")
      guard !childMarketGroups.isEmpty else {
        // here we should be fetching type models
          let typeStart = Date()
        childIdentifiers = await getTypeModelIdentifiersAsync(for: marketGroupId)
        
        return childIdentifiers
      }
      
      childIdentifiers = await withTaskGroup(of: MarketGroupString.self, returning: [MarketGroupString].self) { taskGroup in
        for childMarketGroup in childMarketGroups {
          taskGroup.addTask {
            let childIdentifiers = await self.getChildIdentifiersAsync(for: childMarketGroup.marketGroupId)
            return await MarketGroupString(
              typeId: Int64(childMarketGroup.marketGroupId),
              value: childMarketGroup.name,
              content: childIdentifiers
            )
            //return IdentifiedString
          }
        }

        var returnValues: [MarketGroupString] = []
        
        for await value in taskGroup {
          returnValues.append(value)
        }
        
        return returnValues
      }
      
      
      return childIdentifiers
    } catch let err {
      print("ERr \(err)")
      return []
    }
  }
  
  
  func getTypeModelIdentifiers(for marketGroupId: Int) -> [IdentifiedString] {
    let context = self.modelContext
    let typeModelFetchDescriptor = FetchDescriptor<TypeModel>(
      predicate: #Predicate { $0.marketGroupID == marketGroupId },
      sortBy: []
    )
    var typeModelIdentifiers: [IdentifiedString] = []
    do {
      let typeModels = try context.fetch(typeModelFetchDescriptor)
      //print("++ got \(typeModels.count) typeModels for group")
      typeModelIdentifiers = typeModels.map { typeModel in
        IdentifiedString(typeId: typeModel.typeId, value: typeModel.name)
      }
    } catch let err {
      print("Err \(err)")
    }
    
    return typeModelIdentifiers
  }
  
  func getTypeModelIdentifiersAsync(for marketGroupId: Int) async -> [TypeString] {
    let context = self.modelContext
    let typeModelFetchDescriptor = FetchDescriptor<TypeModel>(
      predicate: #Predicate { $0.marketGroupID == marketGroupId },
      sortBy: []
    )
    var typeModelIdentifiers: [TypeString] = []
    do {
      let typeModels = try context.fetch(typeModelFetchDescriptor)
      //print("++ got \(typeModels.count) typeModels for group async")
      typeModelIdentifiers = typeModels.map { typeModel in
        TypeString(typeId: typeModel.typeId, value: typeModel.name)
      }
    } catch let err {
      print("Err \(err)")
    }
    
    return typeModelIdentifiers
  }
}
