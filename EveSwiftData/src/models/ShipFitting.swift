//
//  ShipFitting.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/4/25.
//

import Foundation
import SwiftData

public struct ShipFitting: Codable {
  public let description: String
  public let fittingID: Int64
  public let items: [ShipFittingItem]
  public let name: String
  public let shipTypeID: Int64
  
//  init?(from values: [Int: [String]]) {
//    let description: String = ""
//    let fittingID: Int64 = 0
//    guard let name = values[EFTFitCategory.name.rawValue]?.first else {
//      return nil
//    }
//    let nameSplit = name.split(separator: ",").map { String( $0) }
//    self.name = nameSplit[0]
//    
//  }
}

public struct ShipFittingItem: Codable {
  public let typeID: Int64
  public let flagID: Int64
  public let flag: String
  public let quantity: Int
  public let charge: ShipFittingCharge?
}

// Contains the typeID and quantity of a charge
public struct ShipFittingCharge: Codable {
  public let typeID: Int64
  public let quantity: Int
}

@Model
final public class ShipFittingModel: Sendable {
  public var fittingDescription: String
  @Attribute(.unique)
  public var fittingID: Int64
  public var items: [ShipFittingItem]
  @Attribute(.unique)
  public var name: String
  public var shipTypeID: Int64
  
  public init(description: String, fittingID: Int64, items: [ShipFittingItem], name: String, shipTypeID: Int64) {
    self.fittingDescription = description
    self.fittingID = fittingID
    self.items = items
    self.name = name
    self.shipTypeID = shipTypeID
  }
  
  public init(fitting: ShipFitting) {
    self.fittingDescription = fitting.description
    self.fittingID = fitting.fittingID
    self.items = fitting.items
    self.name = fitting.name
    self.shipTypeID = fitting.shipTypeID
  }
  
  static func predicate(
      typeId: Int64
  ) -> Predicate<ShipFittingModel> {
    return #Predicate<ShipFittingModel> { $0.shipTypeID == typeId }
  }
  static func predicate() -> Predicate<ShipFittingModel> {
    return #Predicate<ShipFittingModel> { _ in true }
  }
}
