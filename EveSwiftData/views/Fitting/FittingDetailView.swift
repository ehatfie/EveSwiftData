//
//  FittingDetailView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/6/25.
//

import SwiftUI

enum FittingRowAttribute: Int64, CaseIterable {
  case pg = 30 //1
  case cpu = 50 //10
  case cap = 6 //12
  case range = 158 //23
  case tracking = 160 //25
}

struct FittingItemDisplayable: Identifiable {
  var id: Int64 { flagId }
  let typeId: Int64
  let itemState: ItemState
  let chargeIcon: String
  let itemIcon: String
  let name: String
  let attributes: [Int64: AttributeValue]
  let flagId: Int64
}

struct FittingSectionDisplayable: Identifiable {
  var id: String { title }
  
  let title: String
  let content: [FittingItemDisplayable]
}

struct FittingDetailView: View {
   var data: ShipFittingDisplayable
  
    var body: some View {
      VStack {
        Text(data.name)
        HStack {
          Grid(alignment: .leading) {
            GridRow {
              Text("") // isActive
              Text("") // charge icon
              Text("") // item icon
              Text("Name")
              Text("PG")
              Text("CPU")
              Text("Cap")
              Text("Range")
              Text("Tracking")
            }
            ForEach(data.sections) { fittingSection in
              makeSection(
                text: fittingSection.title,
                data: fittingSection.content
              )
            }
          }
        }
      }.padding()
    }
  
  @ViewBuilder
  func makeFittingRow(data: FittingItemDisplayable) -> some View {
    
    GridRow {

      
      Image(systemName: data.itemState.iconName)
      
      Text("") // data.chargeIcon
      Text("") // data.itemIcon
      // for array of enums of PG CPU Cap Range Tracking
      Text(data.name) // data.name
       // data.pg
      
      ForEach(FittingRowAttribute.allCases, id: \.rawValue) { attribute in
        if let value = data.attributes[attribute.rawValue] {
          Text(String(format: "%.1f", value.value))
        }
      }
    }
  }
  
  func makeSection(
    text: String,
    data: [FittingItemDisplayable]
  ) -> some View {
    Section {
      Text(text)
      ForEach(data) { value in
        makeFittingRow(data: value)
      }
    }
  }
}

#Preview {
  FittingDetailView(
    data: ShipFittingDisplayable(
      name: "Name",
      shipName: "Ship Name",
      shipId: 1111,
      sections: [
        .hiSlots,
        .midSlots,
        .lowSlots,
        .rigSlots
      ]
    )
  )
}

extension FittingSectionDisplayable {
  static var hiSlots: Self {
    FittingSectionDisplayable(
      title: "High Slots",
      content: [
        .hOne,
        .hTwo
      ]
    )
  }
  
  static var midSlots: Self {
    FittingSectionDisplayable(
      title: "Mid Slots",
      content: [
        .mOne,
        .mTwo
      ]
    )
  }
  
  static var lowSlots: Self {
    FittingSectionDisplayable(
      title: "Low Slots",
      content: [
        .lOne,
        .lTwo,
        .lThree
      ]
    )
  }
  static var rigSlots: Self {
    FittingSectionDisplayable(
      title: "Rig Slots",
      content: [
        .rOne
      ]
    )
  }
}



extension FittingItemDisplayable {
  static var hOne: Self {
    .init(
      typeId: 1,
      itemState: .overheated,
      chargeIcon: "",
      itemIcon: "",
      name: "Name",
      attributes: [:],
      flagId: ItemFlag.hiSlot0.rawValue
    )
  }
  static var hTwo: Self {
    .init(
      typeId: 2,
      itemState: .active,
      chargeIcon: "",
      itemIcon: "",
      name: "Name",
      attributes: [:],
      flagId: ItemFlag.hiSlot1.rawValue
    )
  }
  static var mOne: Self {
    .init(
      typeId: 3,
      itemState: .online,
      chargeIcon: "",
      itemIcon: "",
      name: "Name",
      attributes: [:],
      flagId: ItemFlag.medSlot0.rawValue
    )
  }
  static var mTwo: Self {
    .init(
      typeId: 4,
      itemState: .overheated,
      chargeIcon: "",
      itemIcon: "",
      name: "Name",
      attributes: [:],
      flagId: ItemFlag.medSlot1.rawValue
    )
  }
  static var lOne: Self {
    .init(
      typeId: 5,
      itemState: .online,
      chargeIcon: "",
      itemIcon: "",
      name: "Name",
      attributes: [:],
      flagId: ItemFlag.loSlot0.rawValue
    )
  }
  static var lTwo: Self {
    .init(
      typeId: -1,
      itemState: .none,
      chargeIcon: "",
      itemIcon: "",
      name: "-",
      attributes: [:],
      flagId: ItemFlag.loSlot1.rawValue
    )
  }
  static var lThree: Self {
    .init(
      typeId: -1,
      itemState: .none,
      chargeIcon: "",
      itemIcon: "",
      name: "-",
      attributes: [:],
      flagId: ItemFlag.loSlot2.rawValue
    )
  }
  static var rOne: Self {
    .init(
      typeId: 6,
      itemState: .online,
      chargeIcon: "",
      itemIcon: "",
      name: "Name",
      attributes: [:],
      flagId: ItemFlag.rigSlot0.rawValue
    )
  }
  
}

//let mockAttributes: [Int64: IdentifiedString] = [
//  FittingRowAttribute.pg.rawValue: IdentifiedString(
//    typeId: FittingRowAttribute.pg.rawValue,
//    value: String(format: "%.2f", 100.00)
//  ),
//  FittingRowAttribute.cpu.rawValue: IdentifiedString(
//    typeId: FittingRowAttribute.cpu.rawValue,
//    value: String(format: "%.2f", 10.00)
//  ),
//  FittingRowAttribute.cap.rawValue: IdentifiedString(
//    typeId: FittingRowAttribute.cap.rawValue,
//    value: String(format: "%.2f", -1.00)
//  ),
//  FittingRowAttribute.range.rawValue: IdentifiedString(
//    typeId: FittingRowAttribute.range.rawValue,
//    value: "10.10 + 15.20"
//  ),
//  FittingRowAttribute.tracking.rawValue: IdentifiedString(
//    typeId: FittingRowAttribute.tracking.rawValue,
//    value: String(format: "%.2f", 1.55)
//  ),
//]

enum ItemState {
  case active
  case online
  case overheated
  case offline
  case none
  
  var iconName: String {
    switch self {
    case .active: "checkmark.circle.fill"
    case .online: "circle"
    case .overheated: "flame.circle.fill"
    case .offline: "x.circle.fill"
    case .none: ""
    }
  }
}
