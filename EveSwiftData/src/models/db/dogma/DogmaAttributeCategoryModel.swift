//
//  DogmaAttributeCategoryModel.swift
//  EveApp
//
//  Created by Erik Hatfield on 9/30/23.
//

import Foundation
import SwiftData

@Model
final public class DogmaAttributeCategoryModel: Sendable {
    
    @Attribute(.unique)
    public var categoryId: Int64
    public var categoryDescription: String
    public var name: String
    
    public init(categoryId: Int64, data: TypeDogmaAttributeCategoryData) {
        self.categoryId = categoryId
        self.categoryDescription = data.description ?? ""
        self.name = data.name
    }
    
    static func predicate(
        categoryId: Int64
    ) -> Predicate<DogmaAttributeCategoryModel> {
        return #Predicate<DogmaAttributeCategoryModel> { $0.categoryId == categoryId }
    }
}

public struct TypeDogmaAttributeCategoryData: Codable {
    let description: String?
    let name: String
}

