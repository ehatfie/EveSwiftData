//
//  TypeTraitsView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/31/25.
//

import SwiftUI

struct TypeTraitsView: View {
  let typeTraits: TypeTraits

  init(typeTraits: TypeTraits) {
    self.typeTraits = typeTraits
  }

  var body: some View {
    VStack {
      GroupBox {
        VStack(alignment: .leading, spacing: 15) {
          Text("Ship Bonuses")
          HStack(alignment:.top, spacing: 10) {
            types()
              .border(.blue)
            rollBonuses()
              .border(.yellow)
          }
        }
      }
    }

  }

  @ViewBuilder
  func types() -> some View {
    if let types = typeTraits.types {
      ForEach(types.map { $0 }, id: \.key) { key, rollBonuses in
        VStack(alignment: .leading) {
          TypeInfo(typeId: Int64(key)!)
          Grid(alignment: .leading) {
            ForEach(rollBonuses, id: \.hashValue) { rollBonus in
              GridRow {
                if let bonusText = rollBonus.bonusText.en {
                  if let bonus = rollBonus.bonus {
                    Text(String(format: "%.2f", bonus.magnitude) + "%")
                    Text(bonusText.removeHTMLTagsRegex().capitalized)
                  }
                }
                if let unitID = rollBonus.unitID {
                  VStack {
                    Text("UnitID: \(unitID)")
                  }
                  
                }

              }
            }
          }
        }
      }
    }
  }

  @ViewBuilder
  func rollBonuses() -> some View {
    if let rollBonuses = typeTraits.roleBonuses {
      VStack(alignment: .leading) {
        Text("Roll Bonuses")
          .font(.title3)
        Grid(alignment: .leading) {
          ForEach(rollBonuses, id: \.hashValue) { rollBonus in
            GridRow {
              if let bonusText = rollBonus.bonusText.en {
                Text(bonusText.removeHTMLTagsRegex().capitalized)
              }
              if let bonus = rollBonus.bonus {
                Text(String(format: "%.2f", bonus) + "%")
              }
            }
          }
        }
      }.textSelection(.enabled)
    }
  }
}

#Preview {
  TypeTraitsView(typeTraits: TypeTraits())
}

extension String {
  func removeHTMLTagsRegex() -> String {
    let htmlRegex = "<[^>]+>"
    return self.replacingOccurrences(
      of: htmlRegex,
      with: "",
      options: .regularExpression
    )
  }
}
