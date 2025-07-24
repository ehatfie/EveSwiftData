//
//  KillmailAttackerView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/20/25.
//

import SwiftUI

struct KillmailAttackerView: View {
  let attacker: KillmailAttackerInfo

  var body: some View {
    HStack(alignment: .top) {
      Rectangle()
        .frame(width: 50, height: 50)
      VStack(alignment: .leading) {
        if let character = attacker.character {
          Text(character.value)
        }
        
        if let corporation = attacker.corporation {
          Text(corporation.value)
        }
      }
      VStack(alignment: .trailing, spacing: 20) {
        VStack(alignment: .leading) {
          Text(attacker.ship.value)
          
          if let weapon = attacker.weapon {
            Text(weapon.value)
          }
        }

        Text("\(attacker.damageDone)")
      }
    }.fixedSize()
  }
}

#Preview {
  KillmailAttackerView(
    attacker: .mockAttacker
  ).padding()
}
