//
//  GroupModel.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/8/25.
//

import Foundation
import SwiftData

public struct GroupData: Codable {
  public let anchorable: Bool
  public let anchored: Bool
  public let categoryID: Int64
  public let fittableNonSingleton: Bool
  public let name: ThingName
  public let published: Bool
  public let useBasePrice: Bool

  public init(id: Int64, name: String) {
    self.init(
      anchorable: true,
      anchored: true,
      categoryID: id,
      fittableNonSingleton: true,
      name: ThingName(name: name),
      published: true,
      useBasePrice: true
    )
  }

  public init(
    anchorable: Bool,
    anchored: Bool,
    categoryID: Int64,
    fittableNonSingleton: Bool,
    name: ThingName,
    published: Bool,
    useBasePrice: Bool
  ) {
    self.anchorable = anchorable
    self.anchored = anchored
    self.categoryID = categoryID
    self.fittableNonSingleton = fittableNonSingleton
    self.name = name
    self.published = published
    self.useBasePrice = useBasePrice
  }
}

@Model
final public class GroupModel {
  //public static let schema = Schemas.groups.rawValue
  //@ID(key: .id) public var id: UUID?

  //@Parent(key: "categoryModel")var categoryModel: CategoryModel
  @Attribute(.unique)
  public var groupId: Int64
  public var anchorable: Bool
  public var anchored: Bool
  public var categoryID: Int64
  public var fittableNonSingleton: Bool
  public var name: String
  public var published: Bool
  public var useBasePrice: Bool

  public init(groupId: Int64, groupData: GroupData) {
    //self.id = UUID()
    self.groupId = groupId
    self.anchorable = groupData.anchorable
    self.anchored = groupData.anchored
    self.categoryID = groupData.categoryID
    self.fittableNonSingleton = groupData.fittableNonSingleton
    self.name = groupData.name.en ?? ""
    self.published = groupData.published
    self.useBasePrice = groupData.useBasePrice
  }

  static func predicate(
    categoryId: Int64
  ) -> Predicate<GroupModel> {
    return #Predicate<GroupModel> { $0.categoryID == categoryId }
  }
}

extension GroupModel: Equatable, Hashable {
  static public func == (lhs: GroupModel, rhs: GroupModel) -> Bool {
    lhs.groupId < rhs.groupId
  }

  public func hash(into hasher: inout Hasher) {
    hasher.combine(groupId)
    //hasher.combine(label)
    //hasher.combine(command)
  }
}
