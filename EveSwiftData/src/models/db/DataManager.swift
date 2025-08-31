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
  case tournamentRuleSets = "tournamentRuleSets"
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
      await loadGroupModels()
    case .typeIDs:
      await loadTypeModel()
    case .categoryIDs:
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
    case .tournamentRuleSets:
      await loadTournamentRules()
    default: return
    }
    print("** loadData took \(Date().timeIntervalSince(start))")
  }

  func loadTournamentRules() async {
    let results = try? await readTournamentYamlAsync(
      for: .tournamentRuleSets,
      type: TournamentRulesData.self
    )
    
    guard let results else { return }
    print("++ got \(results.count) tournament rule sets")
    let models = results.map { TournamentRuleSetModel(data: $0) }
    //let tournamentRuleSets = results.map(\.self)
    insertModels(models)
  }

  func loadGroupModels() async {
    let results = try? await readYamlAsync2(
      for: .groupIDs,
      type: GroupData.self
    )

    guard let results else { return }

    let groupModels = results.map { groupID, groupData in
      return GroupModel(groupId: groupID, groupData: groupData)
    }
    insertModels(groupModels)
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
  func readYamlAsync<T: Decodable>(for fileName: YamlFiles, type: T.Type)
    async throws -> [Int64: T]
  {
    print("++ readYamlAsync")
    guard
      let path = Bundle.main.path(
        forResource: fileName.rawValue,
        ofType: "yaml"
      )
    else {
      throw NSError(domain: "", code: 0)
    }

    let url = URL(fileURLWithPath: path)
    let data = try Data(contentsOf: url)
    let yaml = String(data: data, encoding: .utf8)!
    let node = try Yams.compose(yaml: yaml)!
    //let foo = decode2(splits: 0, some: node, type: T.self)
    return await decodeNode(node: node, type: T.self)
  }
  
  func decodeSequence<T: Decodable>(
    node: Yams.Node,
    type: T.Type
  ) async -> [T] {
    print("++ decodeSequence")
    guard let sequence = node.sequence else {
      print("++ no sequence")
      return []
    }
    
    return sequence.compactMap { node in
      do {
        let decoded = try decodeValue(node: node, type: type)
        return decoded
      } catch let error {
        print("decode node error \(error)")
      }
      return nil
    }
  }
  
  func readTournamentYamlAsync<T: Decodable>(
    for fileName: YamlFiles,
    type: T.Type,
    splits: Int = 3
  ) async throws -> [T] {
    guard
      let path = Bundle.main.path(
        forResource: fileName.rawValue,
        ofType: "yaml"
      )
    else {
      throw NSError(domain: "", code: 0)
    }
    let start = Date()
    let url = URL(fileURLWithPath: path)
    let data = try Data(contentsOf: url)
    let yaml = String(data: data, encoding: .utf8)!
    let node = try Yams.compose(yaml: yaml)!
    
    return await decodeSequence(node: node, type: T.self)
  }
  
  func readYamlAsync2<T: Decodable>(
    for fileName: YamlFiles,
    type: T.Type,
    splits: Int = 3
  ) async throws -> [(Int64, T)] {
    print("++ readYamlAsync2")
    guard
      let path = Bundle.main.path(
        forResource: fileName.rawValue,
        ofType: "yaml"
      )
    else {
      throw NSError(domain: "", code: 0)
    }
    let start = Date()
    let url = URL(fileURLWithPath: path)
    let data = try Data(contentsOf: url)
    let yaml = String(data: data, encoding: .utf8)!
    print("** created yaml string took")
    let node = try Yams.compose(yaml: yaml)!
    print("** created yaml node took \(Date().timeIntervalSince(start))")
    return await decodeNodeAsync(node: node, type: T.self, splits: splits)
  }
  
  func decodeNode<T: Decodable>(node: Yams.Node, type: T.Type) -> [Int64: T] {
    //print("++ decodeNode")
    let start = Date()
    guard let mapping = node.mapping else {
      print("NO MAPPING for \(node)")
      return [:]
    }

    let keyValuePair = mapping.map { $0 }
    var returnValues: [Int64: T] = [:]

    print(
      "++ got kvp \(returnValues.count) in \(Date().timeIntervalSince(start))"
    )
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

  func decodeNodeAsync<T: Decodable>(
    node: Yams.Node,
    type: T.Type,
    splits: Int = 4
  ) async -> [(Int64, T)] {
    print("++ decodeNodeAsync")
    if let scalar = node.scalar {
      print("++ got scalar")
    }

    
    if let anchor = node.anchor {
      print("++ got anchor")
    }
    guard let mapping = node.mapping else {
      print("NO MAPPING for")
      return []
    }
    let keyValuePair = mapping.map { $0 }  //.filter{ $0.key == 17478}

    let start = Date()

    let values = await withTaskGroup(
      of: [(Int64, T)].self,
      returning: [(Int64, T)].self
    ) { taskGroup in
      var returnValues = [(Int64, T)]()

      taskGroup.addTask {
        await self.splitAndDecodeAsync(
          splits: splits,
          nodes: keyValuePair,
          type: type
        )
      }

      for await result in taskGroup {
        returnValues.append(contentsOf: result)
      }

      return returnValues
    }

    print(
      "decodeNodeAsync() - splitAndSortAsync done \(Date().timeIntervalSince(start))"
    )

    return values
  }
  
  func splitAndDecodeAsync<T: Decodable>(
    splits: Int,
    nodes: [Node.Mapping.Element],
    type: T.Type
  ) async -> [(Int64, T)] {
    //print("++ splitAndSortAsync \(nodes.count)")
    let keyValueCount = nodes.count

    let top = Array(nodes[0..<keyValueCount / 2])
    let bottom = Array(nodes[keyValueCount / 2..<keyValueCount])

    guard splits > 0 else {
      return await decodeNodeAsync(splits: 0, nodes: nodes, type: type)
    }

    let values = await withTaskGroup(
      of: [(Int64, T)].self,
      returning: [(Int64, T)].self
    ) { taskGroup in
      var returnValues = [(Int64, T)]()

      taskGroup.addTask {
        await self.splitAndDecodeAsync(
          splits: splits - 1,
          nodes: top,
          type: type
        )
      }
      taskGroup.addTask {
        await self.splitAndDecodeAsync(
          splits: splits - 1,
          nodes: bottom,
          type: type
        )
      }

      for await result in taskGroup {
        returnValues.append(contentsOf: result)
      }

      return returnValues
    }

    return values
    //return await firstThing + secondThing
  }
  
  func decodeNode<T: Decodable>(
    splits: Int,
    nodes: [Node.Mapping.Element],
    type: T.Type
  ) async -> [(Int64, T)] {
    //print("++ decodeNode")
    var returnValues: [(Int64, T)] = []
    let decoder = YAMLDecoder()

    nodes.forEach { key, value in
      guard let keyValue = key.int else { return }
      do {
        let result = try decoder.decode(T.self, from: value)

        returnValues.append((Int64(keyValue), result))
      } catch let err {
        print("Decode error \(err) for \(type) decode2")
      }
    }

    return returnValues
  }
  
  func decodeNodeAsync<T: Decodable>(
    splits: Int,
    nodes: [Node.Mapping.Element],
    type: T.Type
  ) async -> [(Int64, T)] {
    //print("++ decodeNode")
    var returnValues: [(Int64, T)] = []
    //print("decode2() - start splits \(splits) for \(some.count)")
    let decoder = YAMLDecoder()

    let start = Date()

    returnValues = await withTaskGroup(
      of: [(Int64, T)].self,
      returning: [(Int64, T)].self
    ) { taskGroup in
      for node in nodes {
        taskGroup.addTask {
          guard let keyValue = node.key.int else { return ([]) }
          do {
            let result = try decoder.decode(T.self, from: node.value)
            return [(Int64(keyValue), result)]
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
