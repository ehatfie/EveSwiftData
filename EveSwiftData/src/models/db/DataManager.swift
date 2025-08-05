//
//  DataManager.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/8/25.
//

import SwiftData
import SwiftUI
import Yams


enum YamlFiles: String {
  case categoryIDs = "categoryIDs"
  case groupIDs = "groupIDs"
  case typeIDs = "typeIDs"
  case dogmaAttrbutes = "dogmaAttributes"
  case dogmaEffects = "dogmaEffects"
  case typeDogma = "typeDogma"
  case dogmaAttributeCategories = "dogmaAttributeCategories"
  case typeDogmaInfo = "typeDogmaInfo"
  case typeMaterials = "typeMaterials"
  case blueprints = "blueprints"
  case races = "races"
  case marketGroups = "marketGroups"
}

@Observable
class DataManager {
    var modelContext: ModelContext
    var groupModels: [GroupModel] = []
    var typeModels: [TypeModel] = []
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func loadData() async {
        
    }
    
    func loadData(for file: YamlFiles) async {
        let start = Date()
        print("loadData for file \(file.rawValue)")
        switch file {
        case .groupIDs:
            let results = try? await readYamlAsync2(for: file, type: GroupData.self)
            print("++ got \(results?.count) took \(Date().timeIntervalSince(start))")
            guard let results else { return }
            
            let foo = results.map { groupID, groupData in
                return GroupModel(groupId: groupID, groupData: groupData)
            }
            self.groupModels = foo
        case .typeIDs:
            await loadTypeModel()
        case .categoryIDs :
            await loadCategoryData()
        case .marketGroups:
            await loadMarketGroups()
        case .dogmaEffects:
            await loadDogmaEffectModel()
        case .dogmaAttrbutes:
            await loadDogmaAttributes()
        case .dogmaAttributeCategories:
            await loadDogmaAttributeCategory()
        case .typeDogma:
            await loadTypeDogma()
        default: return
        }
        print("** loadData took \(Date().timeIntervalSince(start))")
    }
    
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
        let results = try? await readYamlAsync2(for: .categoryIDs, type: CategoryData.self)

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
        let results = try? await readYamlAsync2(for: .marketGroups, type: MarketGroupIdOk.self)
        
        let data = results?.map { MarketGroupModel(from: $0.1, marketGroupId: Int($0.0))}
        guard let data else {
            print("++ no data")
            return
        }
        
        insertModels(data)
    }
    
    func loadDogmaAttributes() async {
        let existing = try? modelContext.fetch(FetchDescriptor<DogmaAttributeModel>())
        guard existing?.isEmpty ?? true else {
            return
        }
        let results = try? await readYamlAsync2(
            for: .dogmaAttrbutes,
            type: DogmaAttributeData1.self
        )
        
        let data = results?.map { DogmaAttributeModel(attributeId: $0.0, data: $0.1) }
        guard let data else {
            print("++ no data")
            return
        }
        
        insertModels(data)
    }
    
    func loadDogmaAttributeCategory() async {
        let existing = try? modelContext.fetch(FetchDescriptor<DogmaAttributeCategoryModel>())
        guard existing?.isEmpty ?? true else {
            return
        }
        let results = try? await readYamlAsync2(
            for: .dogmaAttributeCategories,
            type: TypeDogmaAttributeCategoryData.self
        )
        
        let data = results?.map { DogmaAttributeCategoryModel(categoryId: $0.0, data: $0.1) }
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
        
        let data = results?.map { DogmaEffectModel(dogmaEffectId: $0.0, dogmaEffectData: $0.1) }
        guard let data else {
            print("++ no data")
            return
        }
        
        insertModels(data)
    }

    func loadTypeDogma() async {
        let existing = try? modelContext.fetch(FetchDescriptor<TypeDogmaInfoModel>())
        guard existing?.isEmpty ?? true else {
            print("++ has \(existing?.count ?? -1) TypeDogmaInfoModel")
            return
        }
        
        let results = try? await readYamlAsync2(
            for: .typeDogma, type: TypeDogmaData.self
        )
        
        let data = results?.map { TypeDogmaInfoModel(typeId: $0.0, data: $0.1) }
        guard let data = data else {
            print("++ no data result")
            return }

        print("++ inserting \(data.count)")
        insertModels(data)
    }
    
    func insertModels(_ data: [any PersistentModel]) {
        print("++ insert \(data.count) models")
        let start = Date()
        do {
            let maxBatchSize: Int = 1000
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
}

extension DataManager {
    func readYamlAsync<T: Decodable>(for fileName: YamlFiles, type: T.Type) async throws -> [Int64: T] {
        print("++ readYamlAsync")
      guard let path = Bundle.main.path(forResource: fileName.rawValue, ofType: "yaml") else {
        throw NSError(domain: "", code: 0)
      }
      
      let url = URL(fileURLWithPath: path)
      let data = try Data(contentsOf: url)
      let yaml = String(data: data, encoding: .utf8)!
      let node = try Yams.compose(yaml: yaml)!
      //let foo = decode2(splits: 0, some: node, type: T.self)
      return await decodeNode(node: node, type: T.self)
    }
    func readYamlAsync2<T: Decodable>(for fileName: YamlFiles, type: T.Type, splits: Int = 3) async throws -> [(Int64, T)] {
        print("++ readYamlAsync2")
      guard let path = Bundle.main.path(forResource: fileName.rawValue, ofType: "yaml") else {
        throw NSError(domain: "", code: 0)
      }
    let start = Date()
      let url = URL(fileURLWithPath: path)
      let data = try Data(contentsOf: url)
      let yaml = String(data: data, encoding: .utf8)!
        print("** created yaml string took \(Date().timeIntervalSince(start))")
//        let decoder = YAMLDecoder()
//        do {
//            let foo = try decoder.decode([Int: T].self, from: yaml)
//            print("** decoded values in \(Date().timeIntervalSince(start))")
//        } catch let err {
//            print("-- yaml decode error \(err)")
//        }
//
//
      let node = try Yams.compose(yaml: yaml)!
      print("** created yaml node took \(Date().timeIntervalSince(start))")
      return await decodeNodeAsync(node: node, type: T.self, splits: splits)
    }
    func decodeNode<T: Decodable>(node: Yams.Node, type: T.Type) -> [Int64: T] {
        //print("++ decodeNode")
        let start = Date()
      guard let mapping = node.mapping else {
        print("NO MAPPING")
        return [:]
      }
      
        let keyValuePair = mapping.map { $0 }
      var returnValues: [Int64: T] = [:]
        
      
        print("++ got kvp \(returnValues.count) in \(Date().timeIntervalSince(start))")
      keyValuePair.forEach { key, value in
        guard let keyValue = key.int else { return }
        do {
          let decrypted = try decodeValue(
            node: value,
            type: T.self
          )
          returnValues[Int64(keyValue)] = decrypted
        } catch let err {
          print("Decode error \(err) for \(type) decodeNode")
        }
      }
      
      return returnValues
    }
    func decodeValue<T: Decodable>(node: Node, type: T.Type) throws -> T {
      let decoder = YAMLDecoder()
      let result = try decoder.decode(T.self, from: node)
      return result
    }
    
    func decodeNodeAsync<T: Decodable>(node: Yams.Node, type: T.Type, splits: Int = 4) async -> [(Int64, T)] {
        print("++ decodeNodeAsync")
      guard let mapping = node.mapping else {
        print("NO MAPPING")
        return []
      }
        let keyValuePair = mapping.map { $0 }//.filter{ $0.key == 17478}
      
      let start = Date()
      
      let values = await withTaskGroup(of: [(Int64, T)].self, returning: [(Int64, T)].self) { taskGroup in
        var returnValues = [(Int64, T)]()
        
        taskGroup.addTask { await self.splitAndDecodeAsync(splits: splits, nodes: keyValuePair, type: type) }
        
        for await result in taskGroup {
          returnValues.append(contentsOf: result)
        }
        
        return returnValues
      }
     
      print("decodeNodeAsync() - splitAndSortAsync done \(Date().timeIntervalSince(start))")

      return values
    }
    func splitAndDecodeAsync<T: Decodable>(splits: Int, nodes: [Node.Mapping.Element], type: T.Type) async -> [(Int64, T)] {
        //print("++ splitAndSortAsync \(nodes.count)")
      let keyValueCount = nodes.count
      
      let top = Array(nodes[0 ..< keyValueCount / 2])
      let bottom = Array(nodes[keyValueCount / 2 ..< keyValueCount])
      
      guard splits > 0 else {
        return await decodeNodeAsync(splits: 0, nodes: nodes, type: type)
      }
      
      let values = await withTaskGroup(of: [(Int64,T)].self, returning: [(Int64,T)].self) { taskGroup in
        var returnValues = [(Int64, T)]()
        
        taskGroup.addTask { await self.splitAndDecodeAsync(splits: splits - 1, nodes: top, type: type) }
        taskGroup.addTask { await self.splitAndDecodeAsync(splits: splits - 1, nodes: bottom, type: type) }
        
        for await result in taskGroup {
          returnValues.append(contentsOf: result)
        }
        
        return returnValues
      }
    
      return values
      //return await firstThing + secondThing
    }
    func decodeNode<T: Decodable>(splits: Int, nodes: [Node.Mapping.Element], type: T.Type) async -> [(Int64, T)] {
        //print("++ decodeNode")
      var returnValues: [(Int64,T)] = []
      let decoder = YAMLDecoder()
      
      nodes.forEach { key, value in
        guard let keyValue = key.int else { return }
        do {
          let result = try decoder.decode(T.self, from: value)
          
          returnValues.append((Int64(keyValue),result))
        } catch let err {
          print("Decode error \(err) for \(type) decode2")
        }
      }

      return returnValues
    }
    func decodeNodeAsync<T: Decodable>(splits: Int, nodes: [Node.Mapping.Element], type: T.Type) async -> [(Int64, T)] {
        //print("++ decodeNode")
      var returnValues: [(Int64,T)] = []
      //print("decode2() - start splits \(splits) for \(some.count)")
      let decoder = YAMLDecoder()
      
      let start = Date()
        
        returnValues = await withTaskGroup(of: [(Int64, T)].self, returning: [(Int64, T)].self) { taskGroup in
            for node in nodes {
                taskGroup.addTask {
                    guard let keyValue = node.key.int else { return ([]) }
                    do {
                        let result = try decoder.decode(T.self, from: node.value)
                        return [(Int64(keyValue),result)]
                    } catch let err {
                        print("Decode error \(err) for \(type) decode2")
                        return []
                    }
                }
            }
            
            var returnValues: [(Int64, T)] = []
            
            for await result in taskGroup {
                returnValues.append(contentsOf: result)
            }
            return returnValues
        }

      return returnValues
    }
}
