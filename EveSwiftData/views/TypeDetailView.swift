//
//  TypeDetailView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/23/25.
//

import SwiftData
import SwiftUI

struct DogmaEffectValue {
  let typeDogmaEffectInfoModel: TypeDogmaEffectInfoModel
  let dogmaEffectModel: DogmaEffectModel
}

struct AttributeCategoryValue: Identifiable {
  var id: Int64 {
    categoryId
  }
  let categoryId: Int64
  let attributeValues: [AttributeValue]
  init(categoryId: Int64, attributeValues: [AttributeValue]) {
    self.categoryId = categoryId
    self.attributeValues = attributeValues
  }
}

struct AttributeValue: Identifiable {
  var id: Int64 {
    attributeId
  }
  let value: Double
  let attributeId: Int64
  let text: String
  let categoryId: Int64?

  init(value: Double, attributeId: Int64, categoryId: Int64?, text: String) {
    self.value = value
    self.attributeId = attributeId
    self.text = text
    self.categoryId = categoryId
  }

  init(
    dogmaAttributeModel: DogmaAttributeModel,
    typeDogmaAttributeInfoModel: TypeDogmaAttributeInfoModel
  ) {
    self.init(
      value: typeDogmaAttributeInfoModel.value,
      attributeId: typeDogmaAttributeInfoModel.attributeID,
      categoryId: dogmaAttributeModel.categoryID,
      text: dogmaAttributeModel.displayNameID ?? dogmaAttributeModel.name
    )
  }
}

@Observable
class TypeDetailViewModel {
  let modelContext: ModelContext
  var typeModels: [TypeModel] = []
  var typeDogmaInfo: [TypeDogmaInfoModel] = []
  var attributes: [AttributeValue] = []
  var attributeCategories: [AttributeCategoryValue] = []

  var shieldAttributes: [Int64: AttributeValue] = [:]
  var armorAttributes: [Int64: AttributeValue] = [:]
  var categorizedAttributes: [Int64: [Int64: AttributeValue]] = [:]

  init(typeId: Int64, modelContext: ModelContext) {
    self.modelContext = modelContext

    let fetchDescriptor = FetchDescriptor(
      predicate: TypeModel.predicate(typeId: typeId)
    )
    self.typeModels = (try? modelContext.fetch(fetchDescriptor)) ?? []

    let fetchDescriptor2 = FetchDescriptor(
      predicate: TypeDogmaInfoModel.predicate(typeId: typeId),
    )
    self.typeDogmaInfo = (try? modelContext.fetch(fetchDescriptor2)) ?? []
    guard !typeDogmaInfo.isEmpty else {
      return
    }
    let start = Date()
    let data = typeDogmaInfo[0].attributes.compactMap {
      attribute -> (TypeDogmaAttributeInfoModel, DogmaAttributeModel)? in
      let fetchDescriptor3 = FetchDescriptor(
        predicate: DogmaAttributeModel.predicate(
          attributeId: attribute.attributeID
        ),
        sortBy: [
          SortDescriptor(\DogmaAttributeModel.categoryID, order: .reverse)
        ]
      )

      guard let attributeModel = try? modelContext.fetch(fetchDescriptor3).first
      else {
        print("++ no attribute model for \(attribute.attributeID)")
        return nil
      }

      return (attribute, attributeModel)
    }
    let attributeModels = data.map {
      (typeDogmaAttributeInfoModel, attributeModel) in
      AttributeValue(
        dogmaAttributeModel: attributeModel,
        typeDogmaAttributeInfoModel: typeDogmaAttributeInfoModel
      )
    }
    print("++ attributeQuery took \(Date().timeIntervalSince(start))")
    self.attributes = attributeModels
    self.processAttributes(dogmaAttributeModels: attributeModels)
    var attributeCategories: [Int64: [AttributeValue]] = [:]
    for attribute in attributes {
      guard let categoryId = attribute.categoryId else {
        continue
      }
      attributeCategories[categoryId, default: []].append(attribute)
    }
    let attributeCategoryValues = attributeCategories.map { key, value in
      return AttributeCategoryValue(
        categoryId: key,
        attributeValues: value.sorted(by: { $0.attributeId < $1.attributeId })
      )
    }
    self.attributeCategories = attributeCategoryValues.sorted(by: {
      $0.categoryId < $1.categoryId
    })
  }

  func processAttributes(dogmaAttributeModels: [AttributeValue]) {
    var shieldAttributes: [Int64: AttributeValue] = [:]
    var armorAttributes: [Int64: AttributeValue] = [:]

    var categorizedAttributes: [Int64: [Int64: AttributeValue]] = [:]

    for attribute in attributes {
      guard let categoryId = attribute.categoryId else {
        print("++ no categoryId for \(attribute.attributeId)")
        var existingAttributeCategory = categorizedAttributes[0, default: [:]]
        existingAttributeCategory[attribute.attributeId] = attribute
        categorizedAttributes[0] = existingAttributeCategory
        continue
      }
      var existingAttributeCategory = categorizedAttributes[
        categoryId,
        default: [:]
      ]
      existingAttributeCategory[attribute.attributeId] = attribute
      categorizedAttributes[categoryId] = existingAttributeCategory
      switch categoryId {
      case 2: shieldAttributes[attribute.attributeId] = attribute
      case 3: armorAttributes[attribute.attributeId] = attribute
      default: continue
      }
    }

    self.shieldAttributes = shieldAttributes
    self.armorAttributes = armorAttributes
    self.categorizedAttributes = categorizedAttributes
  }
}

struct TypeDetailView: View {

  @State var viewModel: TypeDetailViewModel

  @Query private var typeModels: [TypeModel]
  @Query private var dogmaAttributes: [TypeDogmaInfoModel]

  var typeModel: TypeModel {
    viewModel.typeModels[0]
  }

  var dogmaInfo: TypeDogmaInfoModel {
    viewModel.typeDogmaInfo[0]
  }

  init(typeId: Int64, modelContext: ModelContext) {
    self.viewModel = TypeDetailViewModel(
      typeId: typeId,
      modelContext: modelContext
    )
    self._typeModels = Query(
      filter: TypeModel.predicate(typeId: typeId)
    )

    self._dogmaAttributes = Query(
      filter: TypeDogmaInfoModel.predicate(typeId: typeId)
    )
  }

  var body: some View {

    VStack(alignment: .leading) {
      Text(typeModel.name)
        .font(.title)
      Text("\(typeModel.groupID)")

      HStack(alignment: .top) {
        Text("\(dogmaInfo.attributes.count) dogma attributes")
        Text("\(dogmaInfo.effects.count) dogma effects")
      }
      
      if let traits = typeModel.traits {
        VStack(alignment: .center) {
          TypeTraitsView(typeTraits: traits)
        }
        
      }
      
      Grid(alignment: .topLeading) {
        GridRow {
          ScrollView {
            attributeView1()
          }
          List(dogmaInfo.effects, id: \.effectID) { effect in
            EffectInfo(effectId: effect.effectID)
          }
        }
      }.border(.orange)
    }
  }
  
  func attributeView() -> some View {
    List(viewModel.attributeCategories) { attributeCategory in
      GroupBox {
        DogmaCategoryInfo(categoryId: attributeCategory.categoryId)
        Grid(alignment: .topLeading) {
          ForEach(attributeCategory.attributeValues) { attributeValue in
            GridRow {
              //Text("\(attributeValue.attributeId)")
              Text(
                attributeValue.text + " \(attributeValue.attributeId)"
              )
              //AttributeInfo(attributeId: attributeValue.attributeId)
              Text(String(format: "%.2f", attributeValue.value))  //attributeValue.value
            }
          }
        }
      }
    }.border(.yellow)
  }
  
  @ViewBuilder
  func attributeView1() -> some View {
    let adaptiveColumn = [
      GridItem(.flexible(), alignment: .topLeading),
      //GridItem(.flexible(), alignment: .top),
      //GridItem(.flexible(), alignment: .top)
      //GridItem(.adaptive(minimum: 250), alignment: .top),
      //GridItem(.adaptive(minimum: 250), alignment: .top)
    ]
    
      
    Grid(alignment: .topLeading, horizontalSpacing: 5) {
      LazyVGrid(columns: adaptiveColumn) {
        ForEach(viewModel.attributeCategories) { attributeCategory in
          GroupBox {
            DogmaCategoryInfo(categoryId: attributeCategory.categoryId)
            Grid(alignment: .topLeading) {
              ForEach(attributeCategory.attributeValues) { attributeValue in
                GridRow(alignment: .top) {
                  //Text("\(attributeValue.attributeId)")
                  Text(
                    attributeValue.text + " \(attributeValue.attributeId)"
                  )
                  //AttributeInfo(attributeId: attributeValue.attributeId)
                  Text(String(format: "%.2f", attributeValue.value))  //attributeValue.value
                }
              }
            }
          }
        }
        
      }
    }
  }
}

#Preview {
  TypeDetailView(typeId: 0, modelContext: try! ModelContainer().mainContext)
}
