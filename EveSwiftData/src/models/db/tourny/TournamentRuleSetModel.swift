//
//  TournamentRuleSetModel.swift
//  EveSwiftData
//
//  Created by Erik Hatfield on 8/30/25.
//

import SwiftData

@Model
final public class TournamentRuleSetModel: Sendable {
  public var banned: TournamentRulesBannedModel
  
  public var maximumPilotsMatch: Int
  public var maximumPointsMatch: Int
  
  public var points: TournamentRulesPointsModel
  
  @Attribute(.unique)
  public var ruleSetID: String
  public var ruleSetName: String
    
  public init(data: TournamentRulesData) {
    self.banned = TournamentRulesBannedModel(data: data.banned)
    self.maximumPilotsMatch = data.maximumPilotsMatch
    self.maximumPointsMatch = data.maximumPointsMatch
    self.points = TournamentRulesPointsModel(data: data.points)
    self.ruleSetName = data.ruleSetName
    self.ruleSetID = data.ruleSetID
  }
}


@Model
final public class TournamentRulesBannedModel: Sendable {
  public var groups: [TournamentRulesPointedGroupModel]
  public var types: [Int64]
  
  public init(data: TournamentRulesBannedData) {
    self.groups = data.groups.map { TournamentRulesPointedGroupModel(data: $0 )}
    self.types = data.types
  }
}

@Model
final public class TournamentRulesPointsModel: Sendable {
  public var groups: [TournamentRulesPointedGroupModel]
  public var types: [TournamentRulesPointedTypesModel]
  
  public init(data: TournamentRulesPointsCategoryData) {
    self.groups = data.groups.map { TournamentRulesPointedGroupModel(data: $0 )}
    self.types = data.types.map { TournamentRulesPointedTypesModel(data: $0 )}
  }
}


@Model
final public class TournamentRulesPointedGroupModel: Sendable {
  public var groupID: Int64
  public var points: Int64
  
  public init(data: TournamentRulesPointedGroupData) {
    self.groupID = data.groupID
    self.points = data.points
  }
}

@Model
final public class TournamentRulesPointedTypesModel: Sendable {
  public var points: Int64
  public var typeID: Int64
  
  public init(data: TournamentPointedTypesData) {
    points = data.points
    typeID = data.typeID
  }
}
