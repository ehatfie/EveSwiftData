//
//  ShipFitting.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/4/25.
//

import Foundation

struct ShipFitting: Codable {
  let description: String
  let fittingID: Int64
  let items: [ShipFittingItem]
  let name: String
  let shipTypeID: Int64
}

struct ShipFittingItem: Codable {
  let typeID: Int64
  let flagID: Int64
  let flag: String
  let quantity: Int
}
