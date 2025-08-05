//
//  DogmaAttribute.swift
//  EveApp
//
//  Created by Erik Hatfield on 9/30/23.
//

import Foundation
import SwiftData

@Model
final public class DogmaAttributeModel: Sendable {
    
    @Attribute(.unique)
    public var attributeID: Int64
    public var categoryID: Int64?
    public var dataType: Int
    public var defaultValue: Double
    public var attributeDescription: String?
    public var displayNameID: String?
    public var highIsGood: Bool
    public var iconID: Int?
    public var name: String
    public var published: Bool
    public var stackable: Bool
    public var tooltipDescriptionID: String?
    public var tooltipTitleID: String?
    public var unitID: Int?

    public init(id: UUID? = nil, attributeID: Int64, categoryID: Int64?, dataType: Int, defaultValue: Double, description: String?, displayNameID: String?, highIsGood: Bool, iconID: Int?, name: String, published: Bool, stackable: Bool, tooltipDescriptionID: String?, tooltipTitleID: String?, unitID: Int?) {
        self.attributeID = attributeID
        self.categoryID = categoryID
        self.dataType = dataType
        self.defaultValue = defaultValue
        self.attributeDescription = description
        self.displayNameID = displayNameID
        self.highIsGood = highIsGood
        self.iconID = iconID
        self.name = name
        self.published = published
        self.stackable = stackable
        self.tooltipDescriptionID = tooltipDescriptionID
        self.tooltipTitleID = tooltipTitleID
        self.unitID = unitID
    }
    
    public init(attributeId: Int64, data: DogmaAttributeData1) {
        self.attributeID = data.attributeID
        self.categoryID = data.categoryID
        self.dataType = data.dataType
        self.defaultValue = data.defaultValue
        self.attributeDescription = data.description
        self.displayNameID = data.displayNameID?.en
        self.highIsGood = data.highIsGood
        self.iconID = data.iconID
        self.name = data.name
        self.published = data.published
        self.stackable = data.stackable
        self.tooltipDescriptionID = data.tooltipDescriptionID?.en ?? ""
        self.tooltipTitleID = data.tooltipTitleID?.en ?? ""
        self.unitID = data.unitID
    }
    
    static func predicate(
        attributeId: Int64
    ) -> Predicate<DogmaAttributeModel> {
        return #Predicate<DogmaAttributeModel> {
            $0.attributeID == attributeId //&&
            //$0.categoryID != nil &&
            //$0.published == true
        }
    }
}

public struct DogmaAttributeData1: Codable {
    public let attributeID: Int64
    public let categoryID: Int64?
    public let dataType: Int
    public let defaultValue: Double
    public let description: String?
    public let displayNameID: ThingName?
    public let highIsGood: Bool
    public let iconID: Int?
    public let name: String
    public let published: Bool
    public let stackable: Bool
    public let tooltipDescriptionID: ThingName?
    public let tooltipTitleID: ThingName?
    public let unitID: Int?
    
    public init(attributeID: Int64,
         categoryID: Int64? = nil,
         dataType: Int = 0,
         defaultValue: Double,
         description: String?,
         displayNameID: ThingName? = nil,
         highIsGood: Bool = true,
         iconID: Int? = nil,
         name: String,
         published: Bool = false,
         stackable: Bool = false,
         tooltipDescriptionID: ThingName? = nil,
         tooltipTitleID: ThingName? = nil,
         unitID: Int? = nil
    ) {
        self.attributeID = attributeID
        self.categoryID = categoryID
        self.dataType = dataType
        self.defaultValue = defaultValue
        self.description = description
        self.displayNameID = displayNameID
        self.highIsGood = highIsGood
        self.iconID = iconID
        self.name = name
        self.published = published
        self.stackable = stackable
        self.tooltipDescriptionID = tooltipDescriptionID
        self.tooltipTitleID = tooltipTitleID
        self.unitID = unitID
    }
}
