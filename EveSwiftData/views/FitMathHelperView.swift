//
//  FitMathHelper.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/11/25.
//
import SwiftData
import SwiftUI


enum DogmaModifierDomain: String {
  case own = "itemID"
  case character = "charID"
  case ship = "shipID"
  case target = "targetID"
  case other = "otherID"
}

enum DogmaModifier: Int64 {
  case preAssign = -1
  case preMult = 0
  case preDiv = 1
  case modAdd = 2
  case modSub = 3
  case postMult = 4
  case postDiv = 5
  case postPercent = 6
  case postAssign = 7
}

/*
 16229 = brutix
 3146 = Heavy Neutron Blaster II
 */

struct ItemDogmaInfo {
  let dogmaEffects: [DogmaEffectValue]
  let dogmaAttributeBonuses: [TypeDogmaAttributeInfoModel]
  let categorizedDogmaAttributes: [Int64: [Int64: AttributeValue]]
}

@Observable
class FitMathHelperViewModel {
  let defaultTypeId: Int64 = 3146
  let modelContext: ModelContext
  
  var dogmaEffects: [TypeDogmaEffectInfoModel] = []
  var dogmaAttributeBonuses: [TypeDogmaAttributeInfoModel] = []
  var categorizedDogmaAttributes: [Int64: [Int64: AttributeValue]] = [:]
  var modifiedCategorizedDogmaAttributes: [Int64: [Int64: AttributeValue]] = [:]
  var attributeValues: [AttributeValue] = []
  
  var selectedItemID: Int64? = 10190
  
  var selectedItemDogmaInfo: ItemDogmaInfo?
  
  init(modelContext: ModelContext) {
    self.modelContext = modelContext
    setup()
    setupSelectedItem()
    
  }
  
  func setup() {
    let typeDogmaInfo = self.getTypeDogmaInfoModel(for: defaultTypeId)
    self.dogmaEffects = typeDogmaInfo?.effects ?? []
    self.dogmaAttributeBonuses = typeDogmaInfo?.attributes ?? []
    // need to make [Int64: AttributeValue]
    guard let attributes = typeDogmaInfo?.attributes else {
      return
    }
    
    self.attributeValues = makeAttributeValues(for: attributes)
    processAttributes(dogmaAttributeModels: self.attributeValues)
  }
  
  func setupSelectedItem() {
    guard let selectedItemID, let itemDogmaInfo = makeItemDogmaInfo(typeId: selectedItemID) else {
      return
    }
    self.selectedItemDogmaInfo = itemDogmaInfo
  }
  
  func doMath() {
    guard let selectedItemDogmaInfo else {
       return
    }
    
    var localAttributeDict: [Int64: AttributeValue] = [:]
    for attributeValue in attributeValues {
      localAttributeDict[attributeValue.attributeId] = attributeValue
    }
    let sourceDogmaEffects = selectedItemDogmaInfo.dogmaEffects
    
    for dogmaEffect in sourceDogmaEffects {
      let dogmEffectModel = dogmaEffect.dogmaEffectModel
      let modifierInfo = dogmEffectModel.modifierInfo
      applyModifiers(modifiers: modifierInfo, to: &localAttributeDict)
    }
    
    var local1: [Int64: [Int64: AttributeValue]] = [:]
    for attributeValue in localAttributeDict {
      guard let categoryId = attributeValue.value.categoryId else {
        continue
      }
      
      var existing = local1[categoryId, default: [:]]
      existing[attributeValue.key] = attributeValue.value
      local1[categoryId, default: [:]] = existing
    }
    self.modifiedCategorizedDogmaAttributes = local1
  }
  
  func applyModifiers(
    modifiers: [ModifierInfo],
    to attributes: inout [Int64: AttributeValue]
  ) {
    for modifier in modifiers {
      let modifiyingAttributeID = modifier.modifiyingAttributeID
      let modifiedAttributeID = modifier.modifiedAttributeID
      
    }
  }

}

struct FitMathHelperView: View {
  var viewModel: FitMathHelperViewModel
  var body: some View {
    VStack {
      //TypeInfo(typeId: viewModel.defaultShipId)
      TypeDetailView(
        typeId: viewModel.defaultTypeId,
        modelContext: viewModel.modelContext
      ).frame(height: 400)
      if let selectedItemID = viewModel.selectedItemID {
        TypeDetailView(typeId: selectedItemID, modelContext: viewModel.modelContext)
          .frame(height: 400)
      }
     
    }
  }
}

//#Preview {
//  FitMathHelperView(viewModel: FitMathHelperViewModel())
//}


extension FitMathHelperViewModel {
  func makeItemDogmaInfo(typeId: Int64) -> ItemDogmaInfo? {
    let typeDogmaInfo = self.getTypeDogmaInfoModel(for: typeId)
    let dogmaEffects = typeDogmaInfo?.effects ?? []
    let dogmaAttributes = typeDogmaInfo?.attributes ?? []
    
    guard let typeDogmaAttributeInfo = typeDogmaInfo?.attributes else {
      return nil
    }
    let attributeValues = makeAttributeValues(for: typeDogmaAttributeInfo)
    let categorizedAttributes = makeCategorizedAttributes(for: attributeValues)
    let effectValues = makeEffectValue(for: dogmaEffects)
    let itemDogmaInfo = ItemDogmaInfo(
      dogmaEffects: effectValues,
      dogmaAttributeBonuses: dogmaAttributes,
      categorizedDogmaAttributes: categorizedAttributes
    )
    return itemDogmaInfo
  }
  
  func makeEffectValue(for dogmaEffects: [TypeDogmaEffectInfoModel]) -> [DogmaEffectValue] {
    
    return dogmaEffects.compactMap(makeDogmaEffectValue(for:))
  }
  
  func makeDogmaEffectValue(for dogmaEffect: TypeDogmaEffectInfoModel) -> DogmaEffectValue? {
    
    return nil
  }
  
  func makeAttributeValues(for attributes: [TypeDogmaAttributeInfoModel]) -> [AttributeValue] {
    let attributeValues = attributes.compactMap(makeAttributeValue(for:))
    return attributeValues
  }
  
  func makeAttributeValue(for typeDogmaAttributeInfoModel: TypeDogmaAttributeInfoModel) -> AttributeValue? {
    let attributeID = typeDogmaAttributeInfoModel.attributeID
    guard let dogmaAttributeModel = self.getAttributeModel(for: attributeID) else {
      return nil
    }
    return AttributeValue(
      dogmaAttributeModel: dogmaAttributeModel,
      typeDogmaAttributeInfoModel: typeDogmaAttributeInfoModel)
  }
  
  func processAttributes(dogmaAttributeModels: [AttributeValue]) {
    let categorizedAttributes = self.makeCategorizedAttributes(for: dogmaAttributeModels)
    self.categorizedDogmaAttributes = categorizedAttributes
    self.modifiedCategorizedDogmaAttributes = categorizedAttributes
  }
  
  func makeCategorizedAttributes(
    for dogmaAttributeValues: [AttributeValue]
  ) -> [Int64: [Int64: AttributeValue]] {
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
    }
    
    return categorizedAttributes
  }
  
  // TypeModel getter
  func getTypeModel(typeId: Int64) -> TypeModel? {
    let modelContext = modelContext
    let fetchDescriptor = FetchDescriptor(
      predicate: TypeModel.predicate(typeId: typeId)
    )

    return try? modelContext.fetch(fetchDescriptor).first
  }
  
  // TypeDogmaInfoModel getter
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
  
  // DogmaAttributeModel getter
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
  
  // DogmaEffectModel getter
  func getDogmaEffectModel(for effectID: Int64) -> DogmaEffectModel? {
    let modelContext = self.modelContext
    let fetchDescriptor = FetchDescriptor(
      predicate: DogmaEffectModel.predicate(effectId: effectID)
      )
    return try? modelContext.fetch(fetchDescriptor).first
  }
}
