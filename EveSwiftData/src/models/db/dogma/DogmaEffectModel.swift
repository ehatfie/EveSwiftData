import Foundation
import SwiftData

@Model
final public class DogmaEffectModel: Sendable {

    public var descriptionID: String?
    public var disallowAutoRepeat: Bool
    public var displayNameID: String?
    public var dischargeAttributeID: Int64?
    public var distribution: Int64?
    public var durationAttributeID: Int64?
    public var effectCategory: Int64

    @Attribute(.unique)
    public var effectID: Int64
    public var effectName: String
    public var electronicChance: Bool
    public var guid: String?

    public var iconID: Int?
    public var isAssistance: Bool
    public var isOffensive: Bool
    public var isWarpSafe: Bool
    public var modifierInfo: [ModifierInfo]
    public var propulsionChance: Bool
    public var published: Bool
    public var rangeChance: Bool
    
    public init(dogmaEffectId: Int64, dogmaEffectData: DogmaEffectData) {
        print("++ effect name \(dogmaEffectData.effectName) \(dogmaEffectId)")
        if let displayNameID = dogmaEffectData.displayNameID?.en {
            print("++ displayNameID \(displayNameID)")
        }
        if let descriptionID = dogmaEffectData.descriptionID?.en, descriptionID != "Automatically generated effect" {
            print("++ descriptionID \(descriptionID)")
        }
        descriptionID = dogmaEffectData.descriptionID?.en
        disallowAutoRepeat = dogmaEffectData.disallowAutoRepeat
        displayNameID = dogmaEffectData.displayNameID?.en
        dischargeAttributeID = dogmaEffectData.dischargeAttributeID
        distribution = dogmaEffectData.distribution
        durationAttributeID = dogmaEffectData.durationAttributeID
        effectCategory = dogmaEffectData.effectCategory
        effectID = dogmaEffectData.effectID
        effectName = dogmaEffectData.effectName
        electronicChance = dogmaEffectData.electronicChance
        guid = dogmaEffectData.guid
        iconID = dogmaEffectData.iconID
        isAssistance = dogmaEffectData.isAssistance
        isOffensive = dogmaEffectData.isOffensive
        isWarpSafe = dogmaEffectData.isWarpSafe
        self.modifierInfo = (dogmaEffectData.modifierInfo ?? []).map { ModifierInfo($0)}
        propulsionChance = dogmaEffectData.propulsionChance
        published = dogmaEffectData.published
        rangeChance = dogmaEffectData.rangeChance
    }
    
    static func predicate(
        effectId: Int64
    ) -> Predicate<DogmaEffectModel> {
        return #Predicate<DogmaEffectModel> { $0.effectID == effectId }
    }
}

@Model
final public class ModifierInfo: Sendable {
    public var domain: String
    public var function: String
    public var modifiedAttributeID: Int64
    public var modifiyingAttributeID: Int64
    public var operation: Int64
    public var skillTypeID: Int64
    
    public init(_ modifierData: ModifierData) {
        self.domain = modifierData.domain
        self.function = modifierData.func
        self.modifiedAttributeID = modifierData.modifiedAttributeID ?? -1
        self.modifiyingAttributeID = modifierData.modifyingAttributeID ?? -1
        self.operation = modifierData.operation ?? -1
        self.skillTypeID = modifierData.skillTypeID ?? -1
    }
}

public struct DogmaEffectData: Codable {
    public let descriptionID: ThingName?
    public let disallowAutoRepeat: Bool
    public let displayNameID: ThingName?
    public let dischargeAttributeID: Int64?
    public let distribution: Int64?
    public let durationAttributeID: Int64?
    public let effectCategory: Int64
    public let effectID: Int64
    public let effectName: String
    public let electronicChance: Bool
    public let guid: String?
    public let iconID: Int?
    public let isAssistance: Bool
    public let isOffensive: Bool
    public let isWarpSafe: Bool
    public let modifierInfo: [ModifierData]?
    public let propulsionChance: Bool
    public let published: Bool
    public let rangeChance: Bool
}


public struct ModifierData: Codable {
    public let domain: String
    public let `func`: String
    public let modifiedAttributeID: Int64?
    public let modifyingAttributeID: Int64?
    public let operation: Int64?
    public let skillTypeID: Int64?
    
//    enum CodingKeys: String, CodingKey {
//        case domain, name, `func`, modifiedAttributeId, modifyingAttributeID, operation, skillTypeID
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//
//        id = try container.decode(String.self, forKey: .id)
//        name = (try? container.decode(String.self, forKey: .name)) ?? "Default Value"
//    }
    //public var LocationRequiredSkillModifier: () -> Void
}
