//
//  ESIKillmailModel.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 7/20/25.
//

import SwiftData
@Model
public class ESIKillmailModel {
    
    //@Field(key: "skills") public var skills: [CharacterSkillModel]
    
    //@ID(custom: "foo") var id: Int?
    // @Children
    //@Field(key: "attackers") public var attackers: [ESIKmAttacker]
    @Attribute(.unique) public var killmailId: Int64
    //@Children(for: \.$killmailModel) public var attackers: [ESIKmAttackerModel]
    public var killmailTime: String
    public var moonId: Int64?
    public var solarSystemId: Int64
    //@Children(for: \.$killmailModel) public var victim: [ESIKmVictimModel]
    public var warId: Int64?
    
    public init(
        //attackers: [ESIKmAttackerModel],
        killmailId: Int64,
        killmailTime: String,
        moonId: Int64? = nil,
        solarSystemId: Int64,
        //victim: ESIKmVictim,
        warId: Int64? = nil
    ) {
        //self.id = id
        //self.attackers = attackers
        self.killmailId = killmailId
        self.killmailTime = killmailTime
        self.moonId = moonId
        self.solarSystemId = solarSystemId
        //self.victim = [victim]
        self.warId = warId
    }
}
