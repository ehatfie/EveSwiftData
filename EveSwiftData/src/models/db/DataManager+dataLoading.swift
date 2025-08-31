//
//  DBManager+dataLoading.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/30/25.
//
import SwiftData

extension DataManager {
  func loadTypeModel() async {
    //let start = Date()

    //        let existing = try? modelContext.fetch(FetchDescriptor<TypeModel>())
    //        guard existing?.isEmpty ?? true else {
    //            return
    //        }
    //
    do {
      let results = try await readYamlAsync2(for: .typeIDs, type: TypeData.self)

      //guard let results else { return }

      let typeModels = results.map { typeID, typeData in
        return TypeModel(typeId: typeID, data: typeData)
      }
      insertModels(typeModels)
    } catch let error {
      print("++ load type model error \(error)")
    }

    //self.typeModels = typeModels
  }

  func loadCategoryData() async {
    print("++ loadCategoryData")
    let results = try? await readYamlAsync2(
      for: .categoryIDs,
      type: CategoryData.self
    )

    let data = results?.map { value -> CategoryModel in
      CategoryModel(id: value.0, data: value.1)
    }
    guard let data else {
      print("++ no data")
      return
    }
    insertModels(data)
    //let results = try? await readYamlAsync2(for: <#T##YamlFiles#>, type: <#T##Decodable.Type#>)
  }

  func loadMarketGroups() async {
    print("++ loadMarketGroups")
    let existing = try? modelContext.fetch(FetchDescriptor<MarketGroupModel>())
    guard existing?.isEmpty ?? true else {
      return
    }
    let results = try? await readYamlAsync2(
      for: .marketGroups,
      type: MarketGroupIdOk.self
    )

    let data = results?.map {
      MarketGroupModel(from: $0.1, marketGroupId: Int($0.0))
    }
    guard let data else {
      print("++ no data")
      return
    }

    insertModels(data)
  }
  func loadDogmaAttributes() async {
    let existing = try? modelContext.fetch(
      FetchDescriptor<DogmaAttributeModel>()
    )
    guard existing?.isEmpty ?? true else {
      return
    }
    let results = try? await readYamlAsync2(
      for: .dogmaAttrbutes,
      type: DogmaAttributeData1.self
    )

    let data = results?.map {
      DogmaAttributeModel(attributeId: $0.0, data: $0.1)
    }
    guard let data else {
      print("++ no data")
      return
    }

    insertModels(data)
  }

  func loadDogmaAttributeCategory() async {
    let existing = try? modelContext.fetch(
      FetchDescriptor<DogmaAttributeCategoryModel>()
    )
    guard existing?.isEmpty ?? true else {
      return
    }
    let results = try? await readYamlAsync2(
      for: .dogmaAttributeCategories,
      type: TypeDogmaAttributeCategoryData.self
    )

    let data = results?.map {
      DogmaAttributeCategoryModel(categoryId: $0.0, data: $0.1)
    }
    guard let data else {
      print("++ no data")
      return
    }

    insertModels(data)
  }

  func loadDogmaEffectModel() async {
    let existing = try? modelContext.fetch(FetchDescriptor<DogmaEffectModel>())
    guard existing?.isEmpty ?? true else {
      return
    }
    let results = try? await readYamlAsync2(
      for: .dogmaEffects,
      type: DogmaEffectData.self
    )

    let data = results?.map {
      DogmaEffectModel(dogmaEffectId: $0.0, dogmaEffectData: $0.1)
    }
    guard let data else {
      print("++ no data")
      return
    }

    insertModels(data)
  }

  func loadTypeDogma() async {
    let existing = try? modelContext.fetch(
      FetchDescriptor<TypeDogmaInfoModel>()
    )
    guard existing?.isEmpty ?? true else {
      print("++ has \(existing?.count ?? -1) TypeDogmaInfoModel")
      return
    }

    let results = try? await readYamlAsync2(
      for: .typeDogma,
      type: TypeDogmaData.self
    )

    let data = results?.map { TypeDogmaInfoModel(typeId: $0.0, data: $0.1) }
    guard let data = data else {
      print("++ no data result")
      return
    }

    print("++ inserting \(data.count)")
    insertModels(data)
  }
}
