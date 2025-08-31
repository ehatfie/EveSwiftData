//
//  TypeDogmaModel.swift
//  EveApp
//
//  Created by Erik Hatfield on 10/9/23.
//

import Foundation
import SwiftData

public struct TypeDogmaData: Codable {
    public let dogmaAttributes: [DogmaAttributeInfo]
    public let dogmaEffects: [DogmaEffectInfo]
    
    public init(dogmaAttributes: [DogmaAttributeInfo], dogmaEffects: [DogmaEffectInfo]) {
        self.dogmaAttributes = dogmaAttributes
        self.dogmaEffects = dogmaEffects
    }
}

public struct DogmaAttributeInfo: Codable {
    public let attributeID: Int64
    public let value: Double
    
    public init(attributeID: Int64, value: Double) {
        self.attributeID = attributeID
        self.value = value
    }
}

public struct DogmaEffectInfo: Codable {
    public let effectID: Int64
    public let isDefault: Bool
    
    public init(effectID: Int64, isDefault: Bool) {
        self.effectID = effectID
        self.isDefault = isDefault
    }
}


final public class TypeDogmaAttribute: Sendable {
    public var attributeID: Int64
    public var value: Double
    
    public init() {
        self.attributeID = 0
        self.value = 0
    }
    
    public init(data: DogmaAttributeInfo) {
        self.attributeID = data.attributeID
        self.value = data.value
    }
}

final public class TypeDogmaEffect: Sendable {
    public var effectID: Int64
    public var isDefault: Bool
    
    public init() {
        self.effectID = 0
        self.isDefault = false
    }
    
    public init(data: DogmaEffectInfo) {
        self.effectID = data.effectID
        self.isDefault = data.isDefault
    }
}

@Model
final public class TypeDogmaInfoModel: Sendable {
    
    @Attribute(.unique)
    public var typeId: Int64
    
    //  @Children(for: \.$typeDogmaInfoModel) var attributes: [TypeDogmaAttributeInfoModel]
    public var attributes: [TypeDogmaAttributeInfoModel]
    public var effects: [TypeDogmaEffectInfoModel]
    // @Children(for: \.$typeDogmaInfoModel) var effects: [TypeDogmaEffectInfoModel]
    
    public init(typeId: Int64, data: TypeDogmaData) {
        self.typeId = typeId
        self.attributes = []
        
        var set = Set<Int64>()
        
        let dogmaAttributeValues = data.dogmaAttributes.map {
            TypeDogmaAttributeInfoModel(typeID: typeId, attributeID: $0.attributeID, value: $0.value)
        }
        
        dogmaAttributeValues.forEach { value in
            set.insert(value.attributeID)
        }
        
        if set.count != dogmaAttributeValues.count {
            print("have \(data.dogmaAttributes.count) attributes but \(set.count) unique values")
        }
        
        self.attributes = dogmaAttributeValues
        //self.effects = []
        self.effects = data.dogmaEffects.map {
            TypeDogmaEffectInfoModel(effectID: $0.effectID, isDefault: $0.isDefault)
        }
        //self.attributes = attributes
        //self.effects = effects
    }
    
    static func predicate(
        typeId: Int64
    ) -> Predicate<TypeDogmaInfoModel> {
        return #Predicate<TypeDogmaInfoModel> { $0.typeId == typeId }
    }

}

//struct CreateTypeDogmaInfoModel: Migration {
//  func prepare(on database: Database) -> EventLoopFuture<Void> {
//    database.schema(TypeDogmaInfoModel.schema)
//      .id()
//      .field("typeId", .int64, .required)
//      .create()
//  }
//
//  func revert(on database: Database) -> EventLoopFuture<Void> {
//    database.schema(TypeDogmaInfoModel.schema)
//      .delete()
//  }
//}

@Model
final public class TypeDogmaAttributeInfoModel: Sendable {
    
    //@Parent(key: "type_dogma_info_model")
    //public var typeDogmaInfoModel: TypeDogmaInfoModel
    public var typeID: Int64
    public var attributeID: Int64
    public var value: Double
    
    public init(typeID: Int64, attributeID: Int64, value: Double) {
        self.typeID = typeID
        self.attributeID = attributeID
        self.value = value
        //self.typeDogmaInfoModel = info
    }
    
    
}

@Model
final public class TypeDogmaEffectInfoModel: Sendable {
    
    //@Parent(key: "type_dogma_info_model")
    //public var typeDogmaInfoModel: TypeDogmaInfoModel
    
    public var effectID: Int64
    public var isDefault: Bool
    
    public init(effectID: Int64, isDefault: Bool) {
        self.effectID = effectID
        self.isDefault = isDefault
    }
}

