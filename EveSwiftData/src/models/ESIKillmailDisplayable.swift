//
//  ESIKillmailDisplayable.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/20/25.
//
import Foundation
import SwiftUI

struct ESIKillmailDisplayInfo: Identifiable {
  var id: Int64 {
    return esi.killmailId
  }

  //let zkill: ZKillmailModel
  let esi: ESIKillmailModel
  let systemName: IdentifiedString
  let attackersIdentifiers: [KillmailAttackerInfo]
  let victimInfo: KillmailVictimInfo
  let victimShipName: IdentifiedString
}


struct KillmailAttackerInfo: Identifiable {
  var id: Int64 {
      (character?.typeId ?? ship.typeId) + killmailId
    //(character?.id ?? ship.id) + killmailId + damageDone
  }
  let killmailId: Int64
  let character: IdentifiedString?
  let corporation: IdentifiedString?
  let alliance: IdentifiedString?
  let damageDone: Int64
  let finalBlow: Bool
  let ship: IdentifiedString
  let weapon: IdentifiedString?
  
  var descriptionText: String {
    var returnString = ""
    returnString += ship.value
    if let weapon {
      returnString += " - \(weapon.value) "
    }
    returnString += "- " + "\(damageDone) "
    
    return returnString
  }

  init(
    killmailId: Int64,
    character: IdentifiedString?,
    corporation: IdentifiedString?,
    alliance: IdentifiedString?,
    damageDone: Int64,
    finalBlow: Bool,
    ship: IdentifiedString,
    weapon: IdentifiedString?
  ) {
    self.killmailId = killmailId
    self.character = character
    self.corporation = corporation
    self.alliance = alliance
    self.damageDone = damageDone
    self.finalBlow = finalBlow
    self.ship = ship
    self.weapon = weapon
  }
}
/*
 @Parent(key: "killmail_id") public var killmailModel: ESIKillmailModel
 
 @Field(key: "alliance_id") public var allianceId: Int64?
 @Field(key: "character_id") public var characterId: Int64?
 @Field(key: "corporation_id") public var corporationId: Int64?
 @Field(key: "damage_taken") public var damageTaken: Int64
 @Field(key: "faction_id") public var factionId: Int64?
 //@Field(key: "items") public var items: [ESIKmVictimItems]
 @Field(key: "ship_type_id") public var shipTypeId: Int64?
 */

struct KillmailVictimInfo: Identifiable {
  var id: AnyHashable {
    character?.typeId ?? (ship.typeId + damageTaken)
  }
  let character: IdentifiedString?
  let corporation: IdentifiedString?
  let alliance: IdentifiedString?
  let damageTaken: Int64
  // let factionId: Int64?
  let ship: IdentifiedString

  init(
    character: IdentifiedString?,
    corporation: IdentifiedString?,
    alliance: IdentifiedString?,
    damageTaken: Int64,
    ship: IdentifiedString
  ) {
    self.character = character
    self.corporation = corporation
    self.alliance = alliance
    self.damageTaken = damageTaken
    self.ship = ship
  }
}
