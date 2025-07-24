//
//  CategoryModel.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/11/25.
//

import SwiftData

public struct CategoryData: Codable {
    public let name: ThingName
    public let published: Bool

    public init(name: ThingName, published: Bool) {
        self.name = name
        self.published = published
    }
}

@Model
public final class CategoryModel {
    @Attribute(.unique)
    public var categoryId: Int64
    public var name: String
    public var published: Bool
    //@Children(for: \.$categoryModel) var groups: [GroupModel]

    public init(id: Int64, data: CategoryData) {
        self.categoryId = id
        self.name = data.name.en ?? ""
        self.published = data.published
    }
}
