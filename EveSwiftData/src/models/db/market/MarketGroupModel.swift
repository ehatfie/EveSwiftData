//
//  MarketGroupModel.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/21/25.
//
import SwiftData

public struct MarketGroupIdOk: Codable {

    /** description string */
    public var descriptionID: ThingName?
    public var hasTypes: Bool
    public var iconID: Int?
    /** name string */
    public var nameID: ThingName
    /** parent_group_id integer */
    public var parentGroupID: Int?


    public init(
        descriptionID: ThingName?,
        hasTypes: Bool,
        iconID: Int?,
        nameID: ThingName,
        parentGroupID: Int? = nil
    ) {
        self.descriptionID = descriptionID
        self.hasTypes = hasTypes
        self.iconID = iconID
        self.nameID = nameID
        self.parentGroupID = parentGroupID
    }

//    public enum CodingKeys: String, CodingKey {
//        case _description = "description"
//        case marketGroupId = "market_group_id"
//        case name
//        case parentGroupId = "parent_group_id"
//        case types
//    }

}

@Model
final public class MarketGroupModel: Sendable {
    @Attribute(.unique)
    public var marketGroupId: Int
    
    public var groupDescription: String
    public var hasTypes: Bool
    public var iconID: Int?
    public var name: String
    public var parentGroupId: Int?
    
    //var childGroups: [MarketGroupModel]
    
    //@Relationship(inverse:\MarketGroupModel.childGroups)
    //var parent: MarketGroupModel?

    public init(
        groupDescription: String,
        hasTypes: Bool,
        iconID: Int?,
        marketGroupId: Int,
        name: String,
        parentGroupId: Int? = nil
    ) {
        self.groupDescription = groupDescription
        self.hasTypes = hasTypes
        self.iconID = iconID
        self.marketGroupId = marketGroupId
        self.name = name
        self.parentGroupId = parentGroupId
        //self.childGroups = []
    }
    
    public convenience init(from model: MarketGroupIdOk, marketGroupId: Int) {
        self.init(
            groupDescription: model.descriptionID?.en ?? "",
            hasTypes: model.hasTypes,
            iconID: model.iconID,
            marketGroupId: marketGroupId,
            name: model.nameID.en ?? "",
            parentGroupId: model.parentGroupID
        )
    }
}
