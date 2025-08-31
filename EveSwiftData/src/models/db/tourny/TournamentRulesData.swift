//
//  TournamentRules.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/30/25.
//

public struct TournamentRulesSetData: Codable {
  public let TournamnetRules: [TournamentRulesData]
}

public struct TournamentRulesData: Codable {
    public let banned: TournamentRulesBannedData
    public let maximumPilotsMatch: Int
    public let maximumPointsMatch: Int
    public let points: TournamentRulesPointsCategoryData
    public let ruleSetID: String
    public let ruleSetName: String
}

public struct TournamentRulesBannedData: Codable {
  public let groups: [TournamentRulesPointedGroupData]
  public let types: [Int64]
}

public struct TournamentRulesPointsCategoryData: Codable {
  public let groups: [TournamentRulesPointedGroupData]
  public let types: [TournamentPointedTypesData]
}

public struct TournamentRulesPointedGroupData: Codable {
  public let groupID: Int64
  public let points: Int64
}

public struct TournamentPointedTypesData: Codable {
  public let points: Int64
  public let typeID: Int64
}
