//
//  FittingEngine.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/1/25.
//
import Foundation
import SwiftData

/*
 EFT Fitting rules
 Section order
 0. Ship hull, fitting name
 1. Low slots
 2. Midslots
 3. High slots
 4. Rigs
 5. Subsystems
 6. Services (Structures)
 7. Drones/Fighters
 8. Implants
 9. Boosters
 10. Items in cargo
 
 Sections 0-7 are separated by one empty line
 Sections 7-8 are separated by two empty lines
 Sections 8-9 are separated by one empty line
 Sections 9-10 are separated by two empty lines
 
 */

enum EFTFitCategory: Int, CaseIterable, Equatable {
  case name = 0
  case lowSlots = 1
  case midSlots = 2
  case highslots = 3
  case rigs = 4
  case subsystems = 5
  case droneBay = 6
  case implants = 7
  case boosters = 8
  case cargo = 9
  
  case unknown = -1
  
  var name: String {
    switch self {
    case .name: "Name"
    case .lowSlots: "Low Slots"
    case .midSlots: "Mid Slots"
    case .highslots: "High Slots"
    case .boosters: "Boosters"
    case .rigs: "Rigs"
    case .subsystems: "Subsystems"
    case .cargo: "Cargo"
    case .implants: "Implants"
    case .droneBay: "Drone bay"
    case .unknown: "Unknown"
    }
  }
}

extension EFTFitCategory {
  
  var next: EFTFitCategory {
    EFTFitCategory(rawValue: rawValue.advanced(by: 1)) ?? .unknown
  }
  
  var emptyLineCount: Int {
    switch self {
    case .droneBay, .boosters:
      return 2
    default:
      return 1
    }
  }
  
}

struct ShipFittingDisplayable {
  let name: String
  let shipName: String
  let shipId: Int64
  let sections: [FittingSectionDisplayable]
}

@Observable
class FittingEngine {
  var modelContext: ModelContext
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
  }
  
  func makeShipFittingDisplayable(_ data: ShipFittingModel) -> ShipFittingDisplayable? {
    let shipTypeID = data.shipTypeID
    guard let shipModel = fetchTypeModel(typeId: shipTypeID) else {
      print("++ no ship Model for \(shipTypeID)")
      return nil
    }
    print("++ data name \(data.name)")
    return ShipFittingDisplayable(
      name: data.name,
      shipName: shipModel.name,
      shipId: shipTypeID,
      sections: makeShipFittingSections(data: data)
    )
  }
  
  func makeShipFittingSections(data: ShipFittingModel) -> [FittingSectionDisplayable] {
    var fittingSectionItems: [EFTFitCategory: [ShipFittingItem]] = [:]
    for item in data.items {
      if ItemFlagCategory.HiSlots.allCases.contains(where: { $0.rawValue == item.flagID}) {
        fittingSectionItems[.highslots, default: []].append(item)
      } else if ItemFlagCategory.MidSlots.allCases.contains(where: { $0.rawValue == item.flagID}) {
        fittingSectionItems[.midSlots, default: []].append(item)
      } else if ItemFlagCategory.LowSlots.allCases.contains(where: { $0.rawValue == item.flagID}) {
        fittingSectionItems[.lowSlots, default: []].append(item)
      } else if ItemFlagCategory.SubsystemSlots.allCases.contains(where: { $0.rawValue == item.flagID}) {
        fittingSectionItems[.subsystems, default: []].append(item)
      } else if ItemFlagCategory.RigSlots.allCases.contains(where: { $0.rawValue == item.flagID}) {
        fittingSectionItems[.rigs, default: []].append(item)
      } else if ItemFlagCategory.droneBay.rawValue == item.flagID  {
        fittingSectionItems[.droneBay, default: []].append(item)
      } else if ItemFlagCategory.cargo .rawValue == item.flagID {
        fittingSectionItems[.cargo, default: []].append(item)
      }
    }
    var returnValues: [FittingSectionDisplayable] = []
    let orderedCategories: [EFTFitCategory] = [
      .highslots,
      .midSlots,
      .lowSlots,
      .rigs,
      .subsystems,
    ]
    for value in orderedCategories {
      guard let items = fittingSectionItems[value] else { continue }
      let content = items.compactMap({ item -> FittingItemDisplayable? in
        return makeShipFittingItemDisplayable(item, category: value)
      })
      returnValues.append(
        FittingSectionDisplayable(title: value.name, content: content)
      )
    }
    
    return returnValues
  }
  
  func makeShipFittingItemDisplayable(_ data: ShipFittingItem, category: EFTFitCategory) -> FittingItemDisplayable? {
    let context = modelContext
    guard let typeModel = fetchTypeModel(typeId: data.typeID) else {
      print("++ nno typeModel for \(data.typeID) \(data.flag) \(data.flagID)")
      return nil
    }
    
    return FittingItemDisplayable(
      typeId: typeModel.typeId,
      itemState: category == .highslots ? .active : .online,
      chargeIcon: "",
      itemIcon: "",
      name: typeModel.name,
      attributes: [:],
      flagId: data.flagID
    )
  }
    
    func makeAttributes(for data: ShipFittingItem) -> [Int64: IdentifiedString] {
        return [:]
    }
  
  func fetchTypeModel(typeId: Int64) -> TypeModel? {
    let modelContext = modelContext
    let fetchDescriptor = FetchDescriptor(
      predicate: TypeModel.predicate(typeId: typeId)
    )

    return ((try? modelContext.fetch(fetchDescriptor)) ?? []).first
  }
  
  func processEFTString(_ value: String) async -> ShipFitting? {
    
    let values: [EFTFitCategory: [FitEntry]] = parseInventoryGroupsAsArrays(value)
    var createdValues: [ShipFittingItem] = []
    var shipName: String = ""
    var fitName: String? = nil
    
    for value in values.sorted(by: { $0.key.rawValue < $1.key.rawValue }) {
      guard !value.value.isEmpty else { continue }
      guard let first = value.value.first, !first.value.isEmpty else { continue }
      let key = value.key
      print("++ \(key)")
      var index = 0
      var returnValues: [ShipFittingItem] = []
      for item in value.value {
        if key == .name {
          shipName = item.value
          fitName = item.charge
        }
        
        let fittingItem = makeShipFittingItem(for: item, category: key, index: index)
        index += 1
        guard let fittingItem else { continue }
        returnValues.append(fittingItem)
      }
      createdValues.append(contentsOf: returnValues)
      index = 0
    }

    guard let shipTypeID = getShipTypeID(for: shipName) else {
      print("++ no ShipTypeID for \(shipName)")
      return nil
    }
    let fit = ShipFitting(
      description: "",
      fittingID: 0,
      items: createdValues,
      name: fitName ?? "NO_FIT_NAME",
      shipTypeID: shipTypeID
    )
    return fit
  }
  
  func processFittingName(_ data: String) -> (String, Int64)? {
    guard !data.isEmpty else {
      return nil
    }
    let modelContext = self.modelContext
    
    let splitString = data.split(separator: ",")
    let shipTypeName = String(splitString[0].dropFirst())
    let fitName = String(splitString[1].dropLast())
    let fetchDescriptor = FetchDescriptor(predicate: TypeModel.predicate(name: fitName))
    guard let typeModel = ((try? modelContext.fetch(fetchDescriptor)) ?? []).first else {
      return nil
    }
    return (fitName, typeModel.typeId)
  }
  
  func getShipTypeID(for name: String) -> Int64? {
    let modelContext = self.modelContext
    
    let fetchDescriptor = FetchDescriptor(predicate: TypeModel.predicate(name: name))
    guard let typeModel = ((try? modelContext.fetch(fetchDescriptor)) ?? []).first else {
      return nil
    }
    return typeModel.typeId
  }
  
  func makeShipFittingItem(for data: FitEntry, category: EFTFitCategory, index: Int) -> ShipFittingItem? {
    let modelcontext = self.modelContext
    
    let name = data.value
    guard !name.isEmpty else {
      return nil
    }
    let splitName = name.split(separator: " x")
    let newName = String(splitName[0])
    let charge = String((splitName.last ?? "").dropFirst())
    
//    if newName != name {
//      print("turned \(name) into \(newName)")
//    }
    
    let fetchDescriptor = FetchDescriptor(
      predicate: TypeModel.predicate(name: newName)
    )
    guard let typeModel = ((try? modelContext.fetch(fetchDescriptor)) ?? []).first else {
      //print("didnt get typeModel for \(newName)")
      return nil
    }
    let quantity = charge.isEmpty ? 1 : Int(charge) ?? 1
    guard let flagValue = flagValue(for: category, index: index) else {
      return nil
    }
    let item = ShipFittingItem(
      typeID: typeModel.typeId,
      flagID: flagValue,
      flag: ItemFlag(rawValue: flagValue)!.name,
      quantity: quantity,
      charge: nil
    )
    return item
  }
  
  func flagValue(for fittingCategory: EFTFitCategory, index: Int) -> Int64? {
    print("++ flagValue for \(fittingCategory.name) at index \(index)")
    switch fittingCategory {
    case .highslots: return ItemFlagCategory.HiSlots(offset: index)?.rawValue
    case .midSlots: return ItemFlagCategory.MidSlots(offset: index)?.rawValue
    case .lowSlots: return ItemFlagCategory.LowSlots(offset: index)?.rawValue
    case .rigs: return ItemFlagCategory.RigSlots(offset: index)?.rawValue
    case .subsystems: return ItemFlagCategory.RigSlots(offset: index)?.rawValue
    case .boosters: return ItemFlagCategory.cargo.rawValue
    case .cargo: return ItemFlagCategory.cargo.rawValue
    case .droneBay: return ItemFlagCategory.droneBay.rawValue
    default: return nil
    }
  }

}

extension FittingEngine {
  func printStrings(_ data: [String]) {
    for data in data {
      print(data)
    }
  }
  
  func parseInventoryGroupsAsArrays(_ input: String) -> [EFTFitCategory: [FitEntry]] {
    let lines = input.components(separatedBy: .newlines)
      //.map{ $0.trimmingCharacters(in: .whitespaces) }
    print("lines \(lines)")
    var category: EFTFitCategory = .name
    
    var emptyLineCount = 0
    var items: [EFTFitCategory: [FitEntry]] = [:]
    
    for line in lines {
      guard !line.isEmpty else {
        emptyLineCount += 1
        if emptyLineCount >= category.emptyLineCount {
          category = category.next
          emptyLineCount = 0
        }
        continue
      }
      
      let trimmedLine = line
        .trimmingCharacters(in: .whitespacesAndNewlines)
        .split(separator: ",")
      
      let value: String
      let charge: String?
      if category == .name {
        value = String(trimmedLine[0].dropFirst())
        if let last = trimmedLine.last {
          charge = String(last.dropLast())
        } else {
          charge = nil
        }
      } else {
        value = String(trimmedLine[0])
        if let last = trimmedLine.last {
          charge = String(last)
        } else {
          charge = nil
        }
      }
  
      
      items[category, default: []]
        .append(
          FitEntry(
            value: value,
            charge: charge
          )
        )
    }
    return items
  }
  
}


struct FitEntry: Codable {
  let value: String
  let charge: String?
}
