//
//  TypeModel.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/8/25.
//

import Foundation
import SwiftData
import Yams

public typealias TestTypealias = [Int: RoleBonuses]

//public struct TestTypes: Codable {
//  public var : Int64
//}

public struct RoleBonuses: Codable, Hashable {
  public var bonus: Double?
  public var bonusText: ThingName
  public var importance: Int64
  public var unitID: Int64?
}

public struct TypeData: Codable {
    public let capacity: Double?
    public let description: ThingName?
    public let graphicID: Int?
    public let groupID: Int64?
    public let iconID: Int?
    public let marketGroupID: Int?
    public let mass: Double?
    public let metaGroupID: Int?
    public let name: ThingName?
    public let portionSize: Int?
    public let published: Bool
    public let variationParentTypeID: Int?
    public let radius: Double?
    public let raceID: Int?
    public let sofFactionName: String?
    public let soundID: Int?
    public let volume: Double?
    public let traits: TypeTraits?

    public init(
        capacity: Double? = nil,
        description: ThingName? = nil,
        graphicID: Int? = nil,
        groupID: Int64?,
        iconID: Int? = nil,
        marketGroupID: Int? = nil,
        mass: Double? = nil,
        metaGroupID: Int? = nil,
        name: ThingName? = nil,
        portionSize: Int? = nil,
        published: Bool,
        variationParentTypeID: Int? = nil,
        radius: Double? = nil,
        raceID: Int? = nil,
        sofFactionName: String? = nil,
        soundID: Int? = nil,
        volume: Double? = nil,
        traits: TypeTraits? = nil
    ) {
        self.capacity = capacity
        self.description = description
        self.graphicID = graphicID
        self.groupID = groupID
        self.iconID = iconID
        self.marketGroupID = marketGroupID
        self.mass = mass
        self.metaGroupID = metaGroupID
        self.name = name
        self.portionSize = portionSize
        self.published = published
        self.variationParentTypeID = variationParentTypeID
        self.radius = radius
        self.raceID = raceID
        self.sofFactionName = sofFactionName
        self.soundID = soundID
        self.volume = volume
      self.traits = traits
    }
}

@Model
final public class TypeModel {
    public static let schema = "TypeData"
    
    @Attribute(.unique)
    public var typeId: Int64
    public var capacity: Double?
    public var descriptionString: String?
    public var graphicID: Int?
    public var groupID: Int64
    public var iconID: Int?
    public var marketGroupID: Int?
    public var mass: Double?
    public var metaGroupID: Int?
    public var name: String
    public var portionSize: Int?
    public var published: Bool
    public var variationParentTypeID: Int?
    public var radius: Double?
    public var raceID: Int?
    public var sofFactionName: String?
    public var soundID: Int?
    public var volume: Double?
    public var traits: TypeTraits?

    public init(
        typeId: Int64,
        data: TypeData
    ) {
      let typeTraits = data.traits
      
        self.typeId = typeId
        self.capacity = data.capacity
        self.descriptionString = data.description?.en
        self.graphicID = data.graphicID
        self.groupID = data.groupID ?? -1
        self.iconID = data.iconID
        self.marketGroupID = data.marketGroupID
        self.mass = data.mass
        self.metaGroupID = data.metaGroupID
        self.name = data.name?.en ?? ""
        self.portionSize = data.portionSize
        self.published = data.published
        self.variationParentTypeID = data.variationParentTypeID
        self.radius = data.radius
        self.raceID = data.raceID
        self.sofFactionName = data.sofFactionName
        self.soundID = data.soundID
        self.volume = data.volume
        self.traits = data.traits
    }
    
    static func predicate(
        typeId: Int64
    ) -> Predicate<TypeModel> {
        return #Predicate<TypeModel> { $0.typeId == typeId }
    }
    
    static func predicate(
        name: String
    ) -> Predicate<TypeModel> {
        return #Predicate<TypeModel> { $0.name == name }
    }
    
    static func predicate(
        groupId: Int64
    ) -> Predicate<TypeModel> {
        return #Predicate<TypeModel>{ $0.groupID == groupId }
    }
    
    static func predicate(
        groupIds: [Int64]
    ) -> Predicate<TypeModel> {
        return #Predicate<TypeModel>{ groupIds.contains($0.groupID) }
    }
}
