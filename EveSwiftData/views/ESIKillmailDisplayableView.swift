//
//  ESIKillmailDisplayableView.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/20/25.
//

import SwiftUI

struct ESIKillmailDisplayableView: View {
  let killmail: ESIKillmailDisplayInfo

  let dateFormatter: DateFormatter = {
    let dateFormatter = DateFormatter()
    dateFormatter.locale = Locale(identifier: "en_US_POSIX")  // set locale to reliable US_POSIX
    dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    //          formatter.dateStyle = .long
    return dateFormatter
  }()

  var body: some View {
    VStack(alignment: .leading, spacing: 10) {
      Text("id \(killmail.esi.killmailId)")
      HStack {
        if let date = ISO8601DateFormatter().date(
          from: killmail.esi.killmailTime
        ) {
          Text("\(date, formatter: dateFormatter)")
          //Text("Time \(dateFormatter.string(from: date))")
        } else {
          Text("Weird Time \(killmail.esi.killmailTime)")
        }
      }

      victimSection()
      attackerSection()
    }.padding()
  }

  @ViewBuilder
  func victimSection() -> some View {
    VStack(alignment: .leading) {
      HStack(alignment: .top) {
        Rectangle()
          .frame(width: 100, height: 100)
        VStack(alignment: .leading, spacing: 10) {
          //Text(killmail.victimInfo.character!.value)
          if let character = killmail.victimInfo.character {
            Text(character.value)
          }
          //Text(killmail.victimInfo.corporation!.value)
          if let corporation = killmail.victimInfo.corporation {
            Text(corporation.value)
          }
          Text(killmail.victimShipName.value)
          Text("\(killmail.victimInfo.damageTaken)")
        }.fixedSize(horizontal: true, vertical: false)

      }

      
    }
  }

  @ViewBuilder
  func attackerSection() -> some View {
    VStack(alignment: .leading) {
      Text(
        "Attackers \(killmail.attackersIdentifiers.count)"
      )
      VStack(alignment: .leading, spacing: 10) {
        ForEach(killmail.attackersIdentifiers) { attacker in
          VStack(alignment: .leading) {
            if let character = attacker.character {
              Text(character.value)
            }

            if let corporation = attacker.corporation {
              Text(corporation.value)
            }

            //Text(attacker.alliance.value)

            Text(attacker.descriptionText)

            //Text("\(attacker)")
          }
        }
      }
    }
  }

}

#Preview {
  ESIKillmailDisplayableView(
    killmail: ESIKillmailDisplayInfo(
      esi: ESIKillmailModel(
        killmailId: 1,
        killmailTime: "2025-06-26T02:07-36Z",
        solarSystemId: 1
      ),
      systemName: IdentifiedString(typeId: 12, value: "system_name"),
      attackersIdentifiers: [
        .mockAttacker
      ],
      victimInfo: .mockVictim,
      victimShipName: .thorax
    )
  )
}

extension KillmailAttackerInfo {
  static var mockAttacker: KillmailAttackerInfo {
    KillmailAttackerInfo(
      killmailId: 1,
      character: .someName,
      corporation: .corporation,
      alliance: .alliance,
      damageDone: 100,
      finalBlow: true,
      ship: .vexor,
      weapon: .hobgoblin
    )
  }
}

extension KillmailVictimInfo {
  static var mockVictim: KillmailVictimInfo {
    KillmailVictimInfo(
      character: .victimName,
      corporation: .victimCorporation,
      alliance: .victimAlliance,
      damageTaken: 100,
      ship: .thorax
    )
  }
}

extension IdentifiedString {
  static var victimName = IdentifiedString(
    typeId: 22,
    value: "Victim Name"
  )
  static var victimCorporation = IdentifiedString(
    typeId: 33,
    value: "Victim Corp Name"
  )
  static var victimAlliance = IdentifiedString(
    typeId: 384,
    value: "Victim Alliance Name"
  )

  static var someName = IdentifiedString(typeId: 2, value: "Some Name")
  static var corporation = IdentifiedString(typeId: 3, value: "Corp Name")
  static var alliance = IdentifiedString(typeId: 38, value: "Alliance Name")

  static var vexor = IdentifiedString(typeId: 4, value: "Vexor")
  static var thorax = IdentifiedString(typeId: 44, value: "Thorax")

  static var hobgoblin = IdentifiedString(typeId: 5, value: "Hobgoblin II")
}
