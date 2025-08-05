//
//  TraitsModel.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/31/25.
//

import Foundation
import SwiftData


public struct TypeTraits: Codable, Hashable {
  //public var miscBonuses: [String]?
  public var roleBonuses: [RoleBonuses]?
  public var types: [String: [RoleBonuses]]?
}

@Model
final public class TypeTraitsModel {
    
    public var typeId: Int64
    
    public init(
        typeId: Int64
    ) {
        self.typeId = typeId
    }
    
    public init(typeId: Int64, data: TypeTraits) {
        self.typeId = typeId
        
    }
    
}
