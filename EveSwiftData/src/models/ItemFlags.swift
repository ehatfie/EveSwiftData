//
//  ItemFlags.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/4/25.
//

public enum ItemFlagCategory {
  public enum HiSlots: Int64, Codable {
    case hiSlot0 = 27
    case hiSlot1 = 28
    case hiSlot2 = 29
    case hiSlot3 = 30
    case hiSlot4 = 31
    case hiSlot5 = 32
    case hiSlot6 = 33
    case hiSlot7 = 34
  }
  
  public enum MidSlots: Int64, Codable {
    case medSlot0 = 19
    case medSlot1 = 20
    case medSlot2 = 21
    case medSlot3 = 22
    case medSlot4 = 23
    case medSlot5 = 24
    case medSlot6 = 25
    case medSlot7 = 26
    case rigSlot0 = 92
    case rigSlot1 = 93
    case rigSlot2 = 94
  }
  
  enum LowSlots: Int64, Codable {
    case loSlot0 = 11
    case loSlot1 = 12
    case loSlot2 = 13
    case loSlot3 = 14
    case loSlot4 = 15
    case loSlot5 = 16
    case loSlot6 = 17
    case loSlot7 = 18
  }
  
  enum RigSlots: Int64, Codable {
    case rigSlot0 = 92
    case rigSlot1 = 93
    case rigSlot2 = 94
  }
  
  enum SubsystemSlots: Int64, Codable {
    case subSystemSlot0 = 125
    case subSystemSlot1 = 126
    case subSystemSlot2 = 127
    case subSystemSlot3 = 128
  }
  
}

public enum ItemFlag: Int64, Codable {
  case cargo = 5
  case droneBay = 87
  case fighterBay = 158
  case hiSlot0 = 27
  case hiSlot1 = 28
  case hiSlot2 = 29
  case hiSlot3 = 30
  case hiSlot4 = 31
  case hiSlot5 = 32
  case hiSlot6 = 33
  case hiSlot7 = 34
  case invalid = -1
  case loSlot0 = 11
  case loSlot1 = 12
  case loSlot2 = 13
  case loSlot3 = 14
  case loSlot4 = 15
  case loSlot5 = 16
  case loSlot6 = 17
  case loSlot7 = 18
  case medSlot0 = 19
  case medSlot1 = 20
  case medSlot2 = 21
  case medSlot3 = 22
  case medSlot4 = 23
  case medSlot5 = 24
  case medSlot6 = 25
  case medSlot7 = 26
  case rigSlot0 = 92
  case rigSlot1 = 93
  case rigSlot2 = 94
  case subSystemSlot0 = 125
  case subSystemSlot1 = 126
  case subSystemSlot2 = 127
  case subSystemSlot3 = 128

  //    case serviceSlot0 = "ServiceSlot0"
  //    case serviceSlot1 = "ServiceSlot1"
  //    case serviceSlot2 = "ServiceSlot2"
  //    case serviceSlot3 = "ServiceSlot3"
  //    case serviceSlot4 = "ServiceSlot4"
  //    case serviceSlot5 = "ServiceSlot5"
  //    case serviceSlot6 = "ServiceSlot6"
  //    case serviceSlot7 = "ServiceSlot7"
}

//
//  ItemFlags.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/4/25.
//

public enum ItemFlagName: String, Codable {
  case cargo = "Cargo"
  case droneBay = "DroneBay"
  case fighterBay = "FighterBay"
  case hiSlot0 = "HiSlot0"
  case hiSlot1 = "HiSlot1"
  case hiSlot2 = "HiSlot2"
  case hiSlot3 = "HiSlot3"
  case hiSlot4 = "HiSlot4"
  case hiSlot5 = "HiSlot5"
  case hiSlot6 = "HiSlot6"
  case hiSlot7 = "HiSlot7"
  case invalid = "Invalid"
  case loSlot0 = "LoSlot0"
  case loSlot1 = "LoSlot1"
  case loSlot2 = "LoSlot2"
  case loSlot3 = "LoSlot3"
  case loSlot4 = "LoSlot4"
  case loSlot5 = "LoSlot5"
  case loSlot6 = "LoSlot6"
  case loSlot7 = "LoSlot7"
  case medSlot0 = "MedSlot0"
  case medSlot1 = "MedSlot1"
  case medSlot2 = "MedSlot2"
  case medSlot3 = "MedSlot3"
  case medSlot4 = "MedSlot4"
  case medSlot5 = "MedSlot5"
  case medSlot6 = "MedSlot6"
  case medSlot7 = "MedSlot7"
  case rigSlot0 = "RigSlot0"
  case rigSlot1 = "RigSlot1"
  case rigSlot2 = "RigSlot2"
  case serviceSlot0 = "ServiceSlot0"
  case serviceSlot1 = "ServiceSlot1"
  case serviceSlot2 = "ServiceSlot2"
  case serviceSlot3 = "ServiceSlot3"
  case serviceSlot4 = "ServiceSlot4"
  case serviceSlot5 = "ServiceSlot5"
  case serviceSlot6 = "ServiceSlot6"
  case serviceSlot7 = "ServiceSlot7"
  case subSystemSlot0 = "SubSystemSlot0"
  case subSystemSlot1 = "SubSystemSlot1"
  case subSystemSlot2 = "SubSystemSlot2"
  case subSystemSlot3 = "SubSystemSlot3"
}
