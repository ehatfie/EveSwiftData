//
//  ModelData+fitting.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/10/25.
//

import Foundation
import SwiftData


extension ModelData {
  
  func getFitsDisplayable(for typeModels: [TypeModel]) -> [IdentifiedString]? {
    let fitsForShips: [IdentifiedString] = typeModels.compactMap { typeModel in
      guard let fits = getFitsDisplayable(for: typeModel.typeId) else {
        return nil
      }
      return IdentifiedString(
        key: nil,
        typeId: typeModel.typeId,
        value: typeModel.name,
        content: fits
      )
    }
     
    return fitsForShips
  }
  
  func getFitsForGroups(groups: [GroupModel]) async -> [IdentifiedString] {
    print("++ getFits for \(groups.count) groups: \(groups)")
    var returnValue: [IdentifiedString] = []
    for group in groups {
      let value = await getFitsForGroupModel(groupModel: group)
      returnValue.append(value)
    }
    
    return returnValue
  }
  
  func getFitsForGroupModel(groupModel: GroupModel) async -> IdentifiedString {
    let typesForGroup = getTypes(for: groupModel)
    let fitsForTypes = getFitsDisplayable(for: typesForGroup)
    return IdentifiedString(
      key: nil,
      typeId: groupModel.groupId,
      value: groupModel.name,
      content: fitsForTypes
    )
  }
  
    func getFitsDisplayable(for typeId: Int64) -> [IdentifiedString]? {
      let modelContext = modelContext
      
      let fetchDescriptor = FetchDescriptor(
        predicate: ShipFittingModel.predicate(typeId: typeId)
      )
      guard let results = try? modelContext.fetch(fetchDescriptor) else {
        return []
      }
      return results.map { value in
        IdentifiedString(typeId: value.fittingID, value: value.name)
      }
    }
}
