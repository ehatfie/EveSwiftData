//
//  ShipFittingView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/21/25.
//

import SwiftUI
import SwiftData

enum DogmaAttributeCategory: Int64 {
  case fitting = 1
  
  enum Fitting: Int64, CaseIterable {
    case lowSlot = 12
    case midslot = 13
    case highSlot = 14
    case rigSlot = 1137
    case subsystemSlot = 16
    
    var text: String {
      switch self {
      case .lowSlot: "Low Slot"
      case .midslot: "Mid Slot"
      case .highSlot: "High Slot"
      case .rigSlot: "Rig Slot"
      case .subsystemSlot: "Subsystem Slot"
      }
    }
  }
}

struct ShipFittingInformation {
  // can this be done with a dictionary
  var highSlots: [Int: Int] = [:]
  var midSlots: [Int: Int] = [:]
  var lowSlow: [Int: Int] = [:]
  var rigs: [Int: Int] = [:]
  var subsystems: [Int: Int] = [:]
}

@Observable
class ShipFittingViewModel {
  let modelData: ModelData
  let typeModel: TypeModel
  
  var attributeValues: [AttributeValue] = []
  var categorizedAttributes: [Int64: [Int64: AttributeValue]] = [:]
  var typeDogmaAttributes: [Int64: TypeDogmaAttribute] = [:]
  var typeDogmaEffects: [Int64: TypeDogmaEffect] = [:]
  
  var typeDogmaInfo: TypeDogmaInfoModel
  var displayData: [IdentifiedString] = []
  
  init(modelData: ModelData, typeId: Int64) {
    self.modelData = modelData
    let modelContext = modelData.modelContext
    let fetchDescriptor = FetchDescriptor(
      predicate: TypeModel.predicate(typeId: typeId)
    )
    
    let typeModels = (try? modelContext.fetch(fetchDescriptor)) ?? []

    self.typeModel = typeModels[0]
    let fetchDescriptor2 = FetchDescriptor(
      predicate: TypeDogmaInfoModel.predicate(typeId: typeId),
    )
    let typeDogmaInfo = ((try? modelContext.fetch(fetchDescriptor2)) ?? [])[0]
    self.typeDogmaInfo = typeDogmaInfo
    
    let data = typeDogmaInfo.attributes.compactMap { attribute -> (TypeDogmaAttributeInfoModel, DogmaAttributeModel)? in
      let fetchDescriptor3 = FetchDescriptor(
        predicate: DogmaAttributeModel.predicate(attributeId: attribute.attributeID),
        sortBy: [SortDescriptor(\DogmaAttributeModel.categoryID, order: .reverse)]
      )

      guard let attributeModel = try? modelContext.fetch(fetchDescriptor3).first else {
        print("++ no attribute model for \(attribute.attributeID)")
        return nil
      }
      
      return (attribute, attributeModel)
    }
    self.attributeValues = data.map { (typeDogmaAttributeInfoModel, attributeModel) in
      AttributeValue(
        dogmaAttributeModel: attributeModel,
        typeDogmaAttributeInfoModel: typeDogmaAttributeInfoModel)
    }
    
    processAttributes(dogmaAttributeModels: self.attributeValues)
  }
  
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
    self.categorizedAttributes = categorizedAttributes
  }
}

struct ShipFittingView: View {
  @State var viewModel: ShipFittingViewModel
  var body: some View {
    VStack {
      Text("ShipFittingView")
      
      
      Grid {
        Section("Section") {
          
        }
        
        Section("Section2") {
          
        }
        
        Section("Section3") {
          
        }
      }
      TypeDetailView(
        typeId: viewModel.typeModel.typeId,
        modelContext: viewModel.modelData.modelContext
      )
    }
  }
}

//#Preview {
//    ShipFittingView()
//}
