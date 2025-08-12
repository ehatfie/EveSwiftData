//
//  ItemFlags.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/4/25.
//

public enum ItemFlagCategory: Int64 {
    case cargo = 5
    case droneBay = 87
    case fighterBay = 158
    
  public enum HiSlots: Int64, Codable, CaseIterable {
    case hiSlot0 = 27
    case hiSlot1 = 28
    case hiSlot2 = 29
    case hiSlot3 = 30
    case hiSlot4 = 31
    case hiSlot5 = 32
    case hiSlot6 = 33
    case hiSlot7 = 34
      
      init?(offset: Int) {
          if let value = HiSlots(rawValue: HiSlots.hiSlot0.rawValue + Int64(offset)) {
              self = value
          } else {
              return nil
          }
      }
  }
  
  public enum MidSlots: Int64, Codable, CaseIterable {
    case medSlot0 = 19
    case medSlot1 = 20
    case medSlot2 = 21
    case medSlot3 = 22
    case medSlot4 = 23
    case medSlot5 = 24
    case medSlot6 = 25
    case medSlot7 = 26
      
      init?(offset: Int) {
          if let value = MidSlots(rawValue: MidSlots.medSlot0.rawValue + Int64(offset)) {
              self = value
          } else {
              return nil
          }
      }
  }
  
  enum LowSlots: Int64, Codable, CaseIterable {
    case loSlot0 = 11
    case loSlot1 = 12
    case loSlot2 = 13
    case loSlot3 = 14
    case loSlot4 = 15
    case loSlot5 = 16
    case loSlot6 = 17
    case loSlot7 = 18
      
      init?(offset: Int) {
          if let value = LowSlots(rawValue: LowSlots.loSlot0.rawValue + Int64(offset)) {
              self = value
          } else {
              return nil
          }
      }
  }
  
  enum RigSlots: Int64, Codable, CaseIterable {
    case rigSlot0 = 92
    case rigSlot1 = 93
    case rigSlot2 = 94
      init?(offset: Int) {
          if let value = RigSlots(rawValue: RigSlots.rigSlot0.rawValue + Int64(offset)) {
              self = value
          } else {
              return nil
          }
      }
  }
  
  enum SubsystemSlots: Int64, Codable, CaseIterable {
    case subSystemSlot0 = 125
    case subSystemSlot1 = 126
    case subSystemSlot2 = 127
    case subSystemSlot3 = 128
      
      init?(offset: Int) {
          if let value = SubsystemSlots(rawValue: SubsystemSlots.subSystemSlot0.rawValue + Int64(offset)) {
              self = value
          } else {
              return nil
          }
      }
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
    
    var name: String {
        switch self {
        case .cargo: return ItemFlagName.cargo.rawValue
        case .droneBay: return ItemFlagName.droneBay.rawValue
        case .fighterBay: return ItemFlagName.fighterBay.rawValue
        case .loSlot0: return ItemFlagName.loSlot0.rawValue
        case .loSlot1: return ItemFlagName.loSlot1.rawValue
        case .loSlot2: return ItemFlagName.loSlot2.rawValue
        case .loSlot3: return ItemFlagName.loSlot3.rawValue
        case .loSlot4: return ItemFlagName.loSlot4.rawValue
            case .loSlot5: return ItemFlagName.loSlot5.rawValue
            case .loSlot6: return ItemFlagName.loSlot6.rawValue
            case .loSlot7: return ItemFlagName.loSlot7.rawValue
            case .medSlot0: return ItemFlagName.medSlot0.rawValue
            case .medSlot1: return ItemFlagName.medSlot1.rawValue
            case .medSlot2: return ItemFlagName.medSlot2.rawValue
            case .medSlot3: return ItemFlagName.medSlot3.rawValue
            case .medSlot4: return ItemFlagName.medSlot4.rawValue
            case .medSlot5: return ItemFlagName.medSlot5.rawValue
        case .medSlot6: return ItemFlagName.medSlot6.rawValue
            case .medSlot7: return ItemFlagName.medSlot7.rawValue
        case .hiSlot0: return ItemFlagName.hiSlot0.rawValue
            case .hiSlot1: return ItemFlagName.hiSlot1.rawValue
            case .hiSlot2: return ItemFlagName.hiSlot2.rawValue
            case .hiSlot3: return ItemFlagName.hiSlot3.rawValue
        case .hiSlot4: return ItemFlagName.hiSlot4.rawValue
            case .hiSlot5: return ItemFlagName.hiSlot5.rawValue
        case .hiSlot6: return ItemFlagName.hiSlot6.rawValue
        case .hiSlot7: return ItemFlagName.hiSlot7.rawValue
        case .rigSlot0: return ItemFlagName.rigSlot0.rawValue
        case .rigSlot1: return ItemFlagName.rigSlot1.rawValue
        case .rigSlot2: return ItemFlagName.rigSlot2.rawValue
        case .subSystemSlot0: return ItemFlagName.subSystemSlot0.rawValue
        case .subSystemSlot1: return ItemFlagName.subSystemSlot1.rawValue
        case .subSystemSlot2: return ItemFlagName.subSystemSlot2.rawValue
        case .subSystemSlot3: return ItemFlagName.subSystemSlot3.rawValue
        case .invalid: return "invalid"
        }
    }

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
