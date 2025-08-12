//
//  FittingEngine2.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/10/25.
//
import SwiftData
import SwiftUI

@Observable class FittingEngine2 {
  let modelContext: ModelContext
  let fitting: ShipFittingModel
  
  var dogmaEffects: [TypeDogmaEffectInfoModel] = []
  var dogmaAttributeBonuses: [TypeDogmaAttributeInfoModel] = []
  var categorizedDogmaAttributes: [Int64: [Int64: AttributeValue]] = [:]
  var modifiedCategorizedDogmaAttributes: [Int64: [Int64: AttributeValue]] = [:]
  var attributeValues: [AttributeValue] = []
  
  init(modelContext: ModelContext, fitting: ShipFittingModel) {
    self.modelContext = modelContext
    self.fitting = fitting
    self.setup()
    // [Int64: AttributeValue]
    
  }
  
  func setup() {
    let typeDogmaInfo = self.getTypeDogmaInfoModel(for: fitting.shipTypeID)
    self.dogmaEffects = typeDogmaInfo?.effects ?? []
    self.dogmaAttributeBonuses = typeDogmaInfo?.attributes ?? []
    // need to make [Int64: AttributeValue]
    
    let data = typeDogmaInfo?.attributes.compactMap { attribute -> (TypeDogmaAttributeInfoModel, DogmaAttributeModel)? in
      guard let attributeModel = self.getAttributeModel(for: attribute.attributeID) else {
        print("++ no attributeModel for \(attribute.attributeID)")
        return nil
      }
      return (attribute, attributeModel)
    } ?? []
    
    self.attributeValues = data.map { (typeDogmaAttributeInfoModel, dogmaAttributeModel) in
      AttributeValue(
        dogmaAttributeModel: dogmaAttributeModel,
        typeDogmaAttributeInfoModel: typeDogmaAttributeInfoModel)
    }
    
    processAttributes(dogmaAttributeModels: self.attributeValues)
  }
    
    func makeShipFittingDisplayable(_ data: ShipFittingModel) -> ShipFittingDisplayable? {
      let shipTypeID = data.shipTypeID
      guard let shipModel = getTypeModel(typeId: shipTypeID) else {
        print("++ no ship Model for \(shipTypeID)")
        return nil
      }
      
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
    guard let typeModel = getTypeModel(typeId: data.typeID) else {
      print("++ nno typeModel for \(data.typeID) \(data.flag) \(data.flagID)")
      return nil
    }
    
    return FittingItemDisplayable(
      typeId: typeModel.typeId,
      itemState: category == .highslots ? .active : .online,
      chargeIcon: "",
      itemIcon: "",
      name: typeModel.name,
      attributes: makeAttributes(for: data),
      flagId: data.flagID
    )
  }
  
  func makeAttributes(for data: ShipFittingItem) -> [Int64: AttributeValue] {
    let type = getTypeModel(typeId: data.typeID)!
    
    guard let typeDogmaInfo = getTypeDogmaInfoModel(for: data.typeID) else { return [:] }
    
    var returnValues: [Int64: AttributeValue] = [:]
    print("++ making attributes for \(type.name)")
    for value in typeDogmaInfo.attributes {
      guard let dogmaAttribute = getAttributeModel(for: value.attributeID) else {
        continue
      }
      print("++ got attribute \(dogmaAttribute.categoryID ?? -1) \(dogmaAttribute.attributeID) \(dogmaAttribute.name) \(String(format: "%.2f", value.value))")
      returnValues[value.attributeID] = AttributeValue(
        dogmaAttributeModel: dogmaAttribute, typeDogmaAttributeInfoModel: value
      )
      
      guard let categoryID = dogmaAttribute.categoryID else {
        continue
      }
      
      guard let categorizedAttributes = modifiedCategorizedDogmaAttributes[categoryID] else {
        print("++ no categorizedAttributes for \(categoryID)")
        continue
      }
      
      guard let existing = categorizedAttributes[dogmaAttribute.attributeID] else {
        print("++ no existing for \(dogmaAttribute.attributeID)")
        continue
      }
      
      modifiedCategorizedDogmaAttributes[categoryID]?[dogmaAttribute.attributeID] = AttributeValue(
        value: existing.value + value.value,
        attributeId: existing.attributeId,
        categoryId: existing.categoryId,
        text: existing.text
      )
    }
    
//    let values = attributes.map { attribute -> IdentifiedString in
//      return IdentifiedString(typeId: attribute.attributeID, value: attribute.name)
//    }
      return returnValues
  }

}

extension FittingEngine2 {
    func processAttributes(dogmaAttributeModels: [AttributeValue]) {
      var shieldAttributes: [Int64: AttributeValue] = [:]
      var armorAttributes: [Int64: AttributeValue] = [:]
      
      var categorizedAttributes: [Int64: [Int64: AttributeValue]] = [:]
      
      for attribute in attributeValues {
        guard let categoryId = attribute.categoryId else {
          print("++ no categoryId for \(attribute.attributeId)")
          var existingAttributeCategory = categorizedAttributes[0, default: [:]]
          existingAttributeCategory[attribute.attributeId] = attribute
          categorizedAttributes[0] = existingAttributeCategory
          continue
        }

        var existingAttributeCategory = categorizedAttributes[categoryId, default: [:]]
        existingAttributeCategory[attribute.attributeId] = attribute
        categorizedAttributes[categoryId] = existingAttributeCategory
        switch categoryId {
        case 2: shieldAttributes[attribute.attributeId] = attribute
        case 3: armorAttributes[attribute.attributeId] = attribute
        default: continue
        }
      }
      
      //self.shieldAttributes = shieldAttributes
      //self.armorAttributes = armorAttributes
      self.categorizedDogmaAttributes = categorizedAttributes
      self.modifiedCategorizedDogmaAttributes = categorizedAttributes
    }
}

extension FittingEngine2 {
  
  func getTypeModel(typeId: Int64) -> TypeModel? {
    let modelContext = modelContext
    let fetchDescriptor = FetchDescriptor(
      predicate: TypeModel.predicate(typeId: typeId)
    )

    return ((try? modelContext.fetch(fetchDescriptor)) ?? []).first
  }
  
  func getTypeDogmaInfoModel(for typeId: Int64) -> TypeDogmaInfoModel? {
    print("++ getTypeDogmaInfoModels for \(typeId)")
    let modelContext = self.modelContext
    
    let typeDogmaInfoFetch = FetchDescriptor(
      predicate: TypeDogmaInfoModel.predicate(typeId: typeId)
    )
    let results = try? modelContext.fetch(typeDogmaInfoFetch)
    print("++ got typeDogmaInfo results \(results)")
    return results?.first // ?? []
  }
  
  func getAttributeModel(for attributeID: Int64) -> DogmaAttributeModel? {
    let modelContext = self.modelContext
    
    let fetchDescriptor3 = FetchDescriptor(
      predicate: DogmaAttributeModel.predicate(attributeId: attributeID),
      sortBy: [SortDescriptor(\DogmaAttributeModel.categoryID, order: .reverse)]
    )

    guard let attributeModel = try? modelContext.fetch(fetchDescriptor3).first else {
      print("++ no attribute model for \(attributeID)")
      return nil
    }
    return attributeModel
  }
}
