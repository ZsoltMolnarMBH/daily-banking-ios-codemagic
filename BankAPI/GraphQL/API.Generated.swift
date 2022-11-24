// @generated
//  This file was automatically generated and should not be edited.

import Apollo
import Foundation

public struct CloseAccountInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - accountId
  ///   - disbursementAccountNumber
  ///   - feedback
  public init(accountId: String, disbursementAccountNumber: String, feedback: Swift.Optional<ClosureFeedbackInput?> = nil) {
    graphQLMap = ["accountId": accountId, "disbursementAccountNumber": disbursementAccountNumber, "feedback": feedback]
  }

  public var accountId: String {
    get {
      return graphQLMap["accountId"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "accountId")
    }
  }

  public var disbursementAccountNumber: String {
    get {
      return graphQLMap["disbursementAccountNumber"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "disbursementAccountNumber")
    }
  }

  public var feedback: Swift.Optional<ClosureFeedbackInput?> {
    get {
      return graphQLMap["feedback"] as? Swift.Optional<ClosureFeedbackInput?> ?? Swift.Optional<ClosureFeedbackInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "feedback")
    }
  }
}

public struct ClosureFeedbackInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - code
  ///   - comment
  public init(code: Swift.Optional<ClosureFeedbackCode?> = nil, comment: Swift.Optional<String?> = nil) {
    graphQLMap = ["code": code, "comment": comment]
  }

  public var code: Swift.Optional<ClosureFeedbackCode?> {
    get {
      return graphQLMap["code"] as? Swift.Optional<ClosureFeedbackCode?> ?? Swift.Optional<ClosureFeedbackCode?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "code")
    }
  }

  public var comment: Swift.Optional<String?> {
    get {
      return graphQLMap["comment"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "comment")
    }
  }
}

public enum ClosureFeedbackCode: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case tooExpensive
  case dissatisfied
  case betterAlternaitve
  case poorSupport
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "TOO_EXPENSIVE": self = .tooExpensive
      case "DISSATISFIED": self = .dissatisfied
      case "BETTER_ALTERNAITVE": self = .betterAlternaitve
      case "POOR_SUPPORT": self = .poorSupport
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .tooExpensive: return "TOO_EXPENSIVE"
      case .dissatisfied: return "DISSATISFIED"
      case .betterAlternaitve: return "BETTER_ALTERNAITVE"
      case .poorSupport: return "POOR_SUPPORT"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ClosureFeedbackCode, rhs: ClosureFeedbackCode) -> Bool {
    switch (lhs, rhs) {
      case (.tooExpensive, .tooExpensive): return true
      case (.dissatisfied, .dissatisfied): return true
      case (.betterAlternaitve, .betterAlternaitve): return true
      case (.poorSupport, .poorSupport): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [ClosureFeedbackCode] {
    return [
      .tooExpensive,
      .dissatisfied,
      .betterAlternaitve,
      .poorSupport,
    ]
  }
}

public struct CreateAccountClosureStatementInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - accountId
  public init(accountId: String) {
    graphQLMap = ["accountId": accountId]
  }

  public var accountId: String {
    get {
      return graphQLMap["accountId"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "accountId")
    }
  }
}

public enum Status: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case ok
  case error
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "OK": self = .ok
      case "ERROR": self = .error
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .ok: return "OK"
      case .error: return "ERROR"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Status, rhs: Status) -> Bool {
    switch (lhs, rhs) {
      case (.ok, .ok): return true
      case (.error, .error): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [Status] {
    return [
      .ok,
      .error,
    ]
  }
}

public enum LimitType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case dailyTransferLimit
  case temporaryTransferLimit
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "DAILY_TRANSFER_LIMIT": self = .dailyTransferLimit
      case "TEMPORARY_TRANSFER_LIMIT": self = .temporaryTransferLimit
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .dailyTransferLimit: return "DAILY_TRANSFER_LIMIT"
      case .temporaryTransferLimit: return "TEMPORARY_TRANSFER_LIMIT"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: LimitType, rhs: LimitType) -> Bool {
    switch (lhs, rhs) {
      case (.dailyTransferLimit, .dailyTransferLimit): return true
      case (.temporaryTransferLimit, .temporaryTransferLimit): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [LimitType] {
    return [
      .dailyTransferLimit,
      .temporaryTransferLimit,
    ]
  }
}

public struct ChangeCardLimitInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - amount
  ///   - limitType
  public init(amount: Double, limitType: CardLimitType) {
    graphQLMap = ["amount": amount, "limitType": limitType]
  }

  public var amount: Double {
    get {
      return graphQLMap["amount"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "amount")
    }
  }

  public var limitType: CardLimitType {
    get {
      return graphQLMap["limitType"] as! CardLimitType
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "limitType")
    }
  }
}

public enum CardLimitType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case cashWithdrawalDaily
  case posDaily
  case vposDaily
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CASH_WITHDRAWAL_DAILY": self = .cashWithdrawalDaily
      case "POS_DAILY": self = .posDaily
      case "VPOS_DAILY": self = .vposDaily
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .cashWithdrawalDaily: return "CASH_WITHDRAWAL_DAILY"
      case .posDaily: return "POS_DAILY"
      case .vposDaily: return "VPOS_DAILY"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: CardLimitType, rhs: CardLimitType) -> Bool {
    switch (lhs, rhs) {
      case (.cashWithdrawalDaily, .cashWithdrawalDaily): return true
      case (.posDaily, .posDaily): return true
      case (.vposDaily, .vposDaily): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [CardLimitType] {
    return [
      .cashWithdrawalDaily,
      .posDaily,
      .vposDaily,
    ]
  }
}

public enum PollingResult: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case pending
  case successful
  case success
  case error
  case reorderFailed
  case queued
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "PENDING": self = .pending
      case "SUCCESSFUL": self = .successful
      case "SUCCESS": self = .success
      case "ERROR": self = .error
      case "REORDER_FAILED": self = .reorderFailed
      case "QUEUED": self = .queued
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .pending: return "PENDING"
      case .successful: return "SUCCESSFUL"
      case .success: return "SUCCESS"
      case .error: return "ERROR"
      case .reorderFailed: return "REORDER_FAILED"
      case .queued: return "QUEUED"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: PollingResult, rhs: PollingResult) -> Bool {
    switch (lhs, rhs) {
      case (.pending, .pending): return true
      case (.successful, .successful): return true
      case (.success, .success): return true
      case (.error, .error): return true
      case (.reorderFailed, .reorderFailed): return true
      case (.queued, .queued): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [PollingResult] {
    return [
      .pending,
      .successful,
      .success,
      .error,
      .reorderFailed,
      .queued,
    ]
  }
}

public struct Epin: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - pin
  ///   - iv
  public init(pin: String, iv: String) {
    graphQLMap = ["pin": pin, "iv": iv]
  }

  public var pin: String {
    get {
      return graphQLMap["pin"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "pin")
    }
  }

  public var iv: String {
    get {
      return graphQLMap["iv"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "iv")
    }
  }
}

public enum CardStatus: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case frozen
  case fullyOperational
  case expired
  case referToIssuer
  case captureCard
  case declineAllTxns
  case honourWithId
  case lostCard
  case stolenCard
  case void
  case blocked
  case unknown
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "FROZEN": self = .frozen
      case "FULLY_OPERATIONAL": self = .fullyOperational
      case "EXPIRED": self = .expired
      case "REFER_TO_ISSUER": self = .referToIssuer
      case "CAPTURE_CARD": self = .captureCard
      case "DECLINE_ALL_TXNS": self = .declineAllTxns
      case "HONOUR_WITH_ID": self = .honourWithId
      case "LOST_CARD": self = .lostCard
      case "STOLEN_CARD": self = .stolenCard
      case "VOID": self = .void
      case "BLOCKED": self = .blocked
      case "UNKNOWN": self = .unknown
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .frozen: return "FROZEN"
      case .fullyOperational: return "FULLY_OPERATIONAL"
      case .expired: return "EXPIRED"
      case .referToIssuer: return "REFER_TO_ISSUER"
      case .captureCard: return "CAPTURE_CARD"
      case .declineAllTxns: return "DECLINE_ALL_TXNS"
      case .honourWithId: return "HONOUR_WITH_ID"
      case .lostCard: return "LOST_CARD"
      case .stolenCard: return "STOLEN_CARD"
      case .void: return "VOID"
      case .blocked: return "BLOCKED"
      case .unknown: return "UNKNOWN"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: CardStatus, rhs: CardStatus) -> Bool {
    switch (lhs, rhs) {
      case (.frozen, .frozen): return true
      case (.fullyOperational, .fullyOperational): return true
      case (.expired, .expired): return true
      case (.referToIssuer, .referToIssuer): return true
      case (.captureCard, .captureCard): return true
      case (.declineAllTxns, .declineAllTxns): return true
      case (.honourWithId, .honourWithId): return true
      case (.lostCard, .lostCard): return true
      case (.stolenCard, .stolenCard): return true
      case (.void, .void): return true
      case (.blocked, .blocked): return true
      case (.unknown, .unknown): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [CardStatus] {
    return [
      .frozen,
      .fullyOperational,
      .expired,
      .referToIssuer,
      .captureCard,
      .declineAllTxns,
      .honourWithId,
      .lostCard,
      .stolenCard,
      .void,
      .blocked,
      .unknown,
    ]
  }
}

public enum OnboardingNextStepType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  /// The customer chooses the right product for him.
  case accountPackageSelection
  /// The customer provides their details.
  case personalData
  /// The customer makes declarations.
  case consents
  /// The personalized contract is being generated.
  case generateContract
  /// The customer signs the contract.
  case signContract
  /// The customer signs the contract.
  case accountOpening
  /// Bank signature and account opening in progress.
  case finalize
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ACCOUNT_PACKAGE_SELECTION": self = .accountPackageSelection
      case "PERSONAL_DATA": self = .personalData
      case "CONSENTS": self = .consents
      case "GENERATE_CONTRACT": self = .generateContract
      case "SIGN_CONTRACT": self = .signContract
      case "ACCOUNT_OPENING": self = .accountOpening
      case "FINALIZE": self = .finalize
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .accountPackageSelection: return "ACCOUNT_PACKAGE_SELECTION"
      case .personalData: return "PERSONAL_DATA"
      case .consents: return "CONSENTS"
      case .generateContract: return "GENERATE_CONTRACT"
      case .signContract: return "SIGN_CONTRACT"
      case .accountOpening: return "ACCOUNT_OPENING"
      case .finalize: return "FINALIZE"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: OnboardingNextStepType, rhs: OnboardingNextStepType) -> Bool {
    switch (lhs, rhs) {
      case (.accountPackageSelection, .accountPackageSelection): return true
      case (.personalData, .personalData): return true
      case (.consents, .consents): return true
      case (.generateContract, .generateContract): return true
      case (.signContract, .signContract): return true
      case (.accountOpening, .accountOpening): return true
      case (.finalize, .finalize): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [OnboardingNextStepType] {
    return [
      .accountPackageSelection,
      .personalData,
      .consents,
      .generateContract,
      .signContract,
      .accountOpening,
      .finalize,
    ]
  }
}

public struct ApplicationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - selectedProduct
  ///   - individual
  ///   - consentInfo
  ///   - kycSurvey
  ///   - signInfo
  ///   - dmStatement
  public init(selectedProduct: Swift.Optional<String?> = nil, individual: Swift.Optional<IndividualInput?> = nil, consentInfo: Swift.Optional<ConsentInfoInput?> = nil, kycSurvey: Swift.Optional<KycSurveyInput?> = nil, signInfo: Swift.Optional<SignInfoInput?> = nil, dmStatement: Swift.Optional<DmStatementInput?> = nil) {
    graphQLMap = ["selectedProduct": selectedProduct, "individual": individual, "consentInfo": consentInfo, "kycSurvey": kycSurvey, "signInfo": signInfo, "dmStatement": dmStatement]
  }

  public var selectedProduct: Swift.Optional<String?> {
    get {
      return graphQLMap["selectedProduct"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "selectedProduct")
    }
  }

  public var individual: Swift.Optional<IndividualInput?> {
    get {
      return graphQLMap["individual"] as? Swift.Optional<IndividualInput?> ?? Swift.Optional<IndividualInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "individual")
    }
  }

  public var consentInfo: Swift.Optional<ConsentInfoInput?> {
    get {
      return graphQLMap["consentInfo"] as? Swift.Optional<ConsentInfoInput?> ?? Swift.Optional<ConsentInfoInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "consentInfo")
    }
  }

  public var kycSurvey: Swift.Optional<KycSurveyInput?> {
    get {
      return graphQLMap["kycSurvey"] as? Swift.Optional<KycSurveyInput?> ?? Swift.Optional<KycSurveyInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "kycSurvey")
    }
  }

  public var signInfo: Swift.Optional<SignInfoInput?> {
    get {
      return graphQLMap["signInfo"] as? Swift.Optional<SignInfoInput?> ?? Swift.Optional<SignInfoInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "signInfo")
    }
  }

  public var dmStatement: Swift.Optional<DmStatementInput?> {
    get {
      return graphQLMap["dmStatement"] as? Swift.Optional<DmStatementInput?> ?? Swift.Optional<DmStatementInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dmStatement")
    }
  }
}

/// Customer's personal data
public struct IndividualInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - dateOfBirth
  ///   - gender
  ///   - email
  ///   - birthData
  ///   - legalName
  ///   - birthName
  ///   - nameList
  ///   - legalAddress
  ///   - correspondenceAddress
  ///   - addressList
  ///   - mobilePhone
  ///   - phoneList
  ///   - documentList
  ///   - identityCardDocument
  ///   - addressCardDocument
  ///   - emailList
  ///   - mainEmail
  public init(dateOfBirth: Swift.Optional<String?> = nil, gender: Swift.Optional<String?> = nil, email: Swift.Optional<String?> = nil, birthData: Swift.Optional<BirthDataInput?> = nil, legalName: Swift.Optional<NameInput?> = nil, birthName: Swift.Optional<NameInput?> = nil, nameList: Swift.Optional<[NameItemInput]?> = nil, legalAddress: Swift.Optional<AddressInput?> = nil, correspondenceAddress: Swift.Optional<AddressInput?> = nil, addressList: Swift.Optional<[AddressItemInput]?> = nil, mobilePhone: Swift.Optional<PhoneInput?> = nil, phoneList: Swift.Optional<[PhoneItemInput]?> = nil, documentList: Swift.Optional<[DocumentItemInput]?> = nil, identityCardDocument: Swift.Optional<DocumentInput?> = nil, addressCardDocument: Swift.Optional<DocumentInput?> = nil, emailList: Swift.Optional<[EmailItemInput]?> = nil, mainEmail: Swift.Optional<EmailInput?> = nil) {
    graphQLMap = ["dateOfBirth": dateOfBirth, "gender": gender, "email": email, "birthData": birthData, "legalName": legalName, "birthName": birthName, "nameList": nameList, "legalAddress": legalAddress, "correspondenceAddress": correspondenceAddress, "addressList": addressList, "mobilePhone": mobilePhone, "phoneList": phoneList, "documentList": documentList, "identityCardDocument": identityCardDocument, "addressCardDocument": addressCardDocument, "emailList": emailList, "mainEmail": mainEmail]
  }

  public var dateOfBirth: Swift.Optional<String?> {
    get {
      return graphQLMap["dateOfBirth"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dateOfBirth")
    }
  }

  public var gender: Swift.Optional<String?> {
    get {
      return graphQLMap["gender"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gender")
    }
  }

  public var email: Swift.Optional<String?> {
    get {
      return graphQLMap["email"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var birthData: Swift.Optional<BirthDataInput?> {
    get {
      return graphQLMap["birthData"] as? Swift.Optional<BirthDataInput?> ?? Swift.Optional<BirthDataInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "birthData")
    }
  }

  public var legalName: Swift.Optional<NameInput?> {
    get {
      return graphQLMap["legalName"] as? Swift.Optional<NameInput?> ?? Swift.Optional<NameInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "legalName")
    }
  }

  public var birthName: Swift.Optional<NameInput?> {
    get {
      return graphQLMap["birthName"] as? Swift.Optional<NameInput?> ?? Swift.Optional<NameInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "birthName")
    }
  }

  public var nameList: Swift.Optional<[NameItemInput]?> {
    get {
      return graphQLMap["nameList"] as? Swift.Optional<[NameItemInput]?> ?? Swift.Optional<[NameItemInput]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameList")
    }
  }

  public var legalAddress: Swift.Optional<AddressInput?> {
    get {
      return graphQLMap["legalAddress"] as? Swift.Optional<AddressInput?> ?? Swift.Optional<AddressInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "legalAddress")
    }
  }

  public var correspondenceAddress: Swift.Optional<AddressInput?> {
    get {
      return graphQLMap["correspondenceAddress"] as? Swift.Optional<AddressInput?> ?? Swift.Optional<AddressInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "correspondenceAddress")
    }
  }

  public var addressList: Swift.Optional<[AddressItemInput]?> {
    get {
      return graphQLMap["addressList"] as? Swift.Optional<[AddressItemInput]?> ?? Swift.Optional<[AddressItemInput]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "addressList")
    }
  }

  public var mobilePhone: Swift.Optional<PhoneInput?> {
    get {
      return graphQLMap["mobilePhone"] as? Swift.Optional<PhoneInput?> ?? Swift.Optional<PhoneInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mobilePhone")
    }
  }

  public var phoneList: Swift.Optional<[PhoneItemInput]?> {
    get {
      return graphQLMap["phoneList"] as? Swift.Optional<[PhoneItemInput]?> ?? Swift.Optional<[PhoneItemInput]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "phoneList")
    }
  }

  public var documentList: Swift.Optional<[DocumentItemInput]?> {
    get {
      return graphQLMap["documentList"] as? Swift.Optional<[DocumentItemInput]?> ?? Swift.Optional<[DocumentItemInput]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "documentList")
    }
  }

  public var identityCardDocument: Swift.Optional<DocumentInput?> {
    get {
      return graphQLMap["identityCardDocument"] as? Swift.Optional<DocumentInput?> ?? Swift.Optional<DocumentInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "identityCardDocument")
    }
  }

  public var addressCardDocument: Swift.Optional<DocumentInput?> {
    get {
      return graphQLMap["addressCardDocument"] as? Swift.Optional<DocumentInput?> ?? Swift.Optional<DocumentInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "addressCardDocument")
    }
  }

  public var emailList: Swift.Optional<[EmailItemInput]?> {
    get {
      return graphQLMap["emailList"] as? Swift.Optional<[EmailItemInput]?> ?? Swift.Optional<[EmailItemInput]?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "emailList")
    }
  }

  public var mainEmail: Swift.Optional<EmailInput?> {
    get {
      return graphQLMap["mainEmail"] as? Swift.Optional<EmailInput?> ?? Swift.Optional<EmailInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mainEmail")
    }
  }
}

public struct BirthDataInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - countryOfBirth
  ///   - placeOfBirth
  ///   - dateOfBirth
  ///   - motherName
  ///   - gender
  public init(countryOfBirth: Swift.Optional<String?> = nil, placeOfBirth: Swift.Optional<String?> = nil, dateOfBirth: Swift.Optional<String?> = nil, motherName: Swift.Optional<String?> = nil, gender: Swift.Optional<Gender?> = nil) {
    graphQLMap = ["countryOfBirth": countryOfBirth, "placeOfBirth": placeOfBirth, "dateOfBirth": dateOfBirth, "motherName": motherName, "gender": gender]
  }

  public var countryOfBirth: Swift.Optional<String?> {
    get {
      return graphQLMap["countryOfBirth"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "countryOfBirth")
    }
  }

  public var placeOfBirth: Swift.Optional<String?> {
    get {
      return graphQLMap["placeOfBirth"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "placeOfBirth")
    }
  }

  public var dateOfBirth: Swift.Optional<String?> {
    get {
      return graphQLMap["dateOfBirth"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "dateOfBirth")
    }
  }

  public var motherName: Swift.Optional<String?> {
    get {
      return graphQLMap["motherName"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "motherName")
    }
  }

  public var gender: Swift.Optional<Gender?> {
    get {
      return graphQLMap["gender"] as? Swift.Optional<Gender?> ?? Swift.Optional<Gender?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "gender")
    }
  }
}

public enum Gender: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case female
  case male
  case unknown
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "FEMALE": self = .female
      case "MALE": self = .male
      case "UNKNOWN": self = .unknown
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .female: return "FEMALE"
      case .male: return "MALE"
      case .unknown: return "UNKNOWN"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: Gender, rhs: Gender) -> Bool {
    switch (lhs, rhs) {
      case (.female, .female): return true
      case (.male, .male): return true
      case (.unknown, .unknown): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [Gender] {
    return [
      .female,
      .male,
      .unknown,
    ]
  }
}

public struct NameInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - firstName
  ///   - lastName
  public init(firstName: String, lastName: String) {
    graphQLMap = ["firstName": firstName, "lastName": lastName]
  }

  public var firstName: String {
    get {
      return graphQLMap["firstName"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: String {
    get {
      return graphQLMap["lastName"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }
}

public struct NameItemInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - firstName
  ///   - lastName
  ///   - nameType
  ///   - type
  public init(firstName: String, lastName: String, nameType: Swift.Optional<NameType?> = nil, type: Swift.Optional<NameType?> = nil) {
    graphQLMap = ["firstName": firstName, "lastName": lastName, "nameType": nameType, "type": type]
  }

  public var firstName: String {
    get {
      return graphQLMap["firstName"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: String {
    get {
      return graphQLMap["lastName"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "lastName")
    }
  }

  public var nameType: Swift.Optional<NameType?> {
    get {
      return graphQLMap["nameType"] as? Swift.Optional<NameType?> ?? Swift.Optional<NameType?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "nameType")
    }
  }

  public var type: Swift.Optional<NameType?> {
    get {
      return graphQLMap["type"] as? Swift.Optional<NameType?> ?? Swift.Optional<NameType?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }
}

public enum NameType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case legal
  case birth
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "LEGAL": self = .legal
      case "BIRTH": self = .birth
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .legal: return "LEGAL"
      case .birth: return "BIRTH"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: NameType, rhs: NameType) -> Bool {
    switch (lhs, rhs) {
      case (.legal, .legal): return true
      case (.birth, .birth): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [NameType] {
    return [
      .legal,
      .birth,
    ]
  }
}

public struct AddressInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - country
  ///   - city
  ///   - postCode
  ///   - streetName
  ///   - houseNumber
  public init(country: String, city: String, postCode: String, streetName: String, houseNumber: String) {
    graphQLMap = ["country": country, "city": city, "postCode": postCode, "streetName": streetName, "houseNumber": houseNumber]
  }

  public var country: String {
    get {
      return graphQLMap["country"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "country")
    }
  }

  public var city: String {
    get {
      return graphQLMap["city"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "city")
    }
  }

  public var postCode: String {
    get {
      return graphQLMap["postCode"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "postCode")
    }
  }

  public var streetName: String {
    get {
      return graphQLMap["streetName"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "streetName")
    }
  }

  public var houseNumber: String {
    get {
      return graphQLMap["houseNumber"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "houseNumber")
    }
  }
}

public struct AddressItemInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - country
  ///   - city
  ///   - postCode
  ///   - streetName
  ///   - houseNumber
  ///   - addressType
  ///   - type
  public init(country: String, city: String, postCode: String, streetName: String, houseNumber: String, addressType: Swift.Optional<AddressType?> = nil, type: Swift.Optional<AddressType?> = nil) {
    graphQLMap = ["country": country, "city": city, "postCode": postCode, "streetName": streetName, "houseNumber": houseNumber, "addressType": addressType, "type": type]
  }

  public var country: String {
    get {
      return graphQLMap["country"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "country")
    }
  }

  public var city: String {
    get {
      return graphQLMap["city"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "city")
    }
  }

  public var postCode: String {
    get {
      return graphQLMap["postCode"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "postCode")
    }
  }

  public var streetName: String {
    get {
      return graphQLMap["streetName"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "streetName")
    }
  }

  public var houseNumber: String {
    get {
      return graphQLMap["houseNumber"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "houseNumber")
    }
  }

  public var addressType: Swift.Optional<AddressType?> {
    get {
      return graphQLMap["addressType"] as? Swift.Optional<AddressType?> ?? Swift.Optional<AddressType?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "addressType")
    }
  }

  public var type: Swift.Optional<AddressType?> {
    get {
      return graphQLMap["type"] as? Swift.Optional<AddressType?> ?? Swift.Optional<AddressType?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }
}

public enum AddressType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case legal
  case correspondence
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "LEGAL": self = .legal
      case "CORRESPONDENCE": self = .correspondence
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .legal: return "LEGAL"
      case .correspondence: return "CORRESPONDENCE"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: AddressType, rhs: AddressType) -> Bool {
    switch (lhs, rhs) {
      case (.legal, .legal): return true
      case (.correspondence, .correspondence): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [AddressType] {
    return [
      .legal,
      .correspondence,
    ]
  }
}

public struct PhoneInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - fullPhoneNumber
  public init(fullPhoneNumber: String) {
    graphQLMap = ["fullPhoneNumber": fullPhoneNumber]
  }

  public var fullPhoneNumber: String {
    get {
      return graphQLMap["fullPhoneNumber"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fullPhoneNumber")
    }
  }
}

public struct PhoneItemInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - fullPhoneNumber
  ///   - mediumType
  ///   - type
  public init(fullPhoneNumber: String, mediumType: Swift.Optional<PhoneType?> = nil, type: Swift.Optional<PhoneType?> = nil) {
    graphQLMap = ["fullPhoneNumber": fullPhoneNumber, "mediumType": mediumType, "type": type]
  }

  public var fullPhoneNumber: String {
    get {
      return graphQLMap["fullPhoneNumber"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "fullPhoneNumber")
    }
  }

  public var mediumType: Swift.Optional<PhoneType?> {
    get {
      return graphQLMap["mediumType"] as? Swift.Optional<PhoneType?> ?? Swift.Optional<PhoneType?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "mediumType")
    }
  }

  public var type: Swift.Optional<PhoneType?> {
    get {
      return graphQLMap["type"] as? Swift.Optional<PhoneType?> ?? Swift.Optional<PhoneType?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }
}

public enum PhoneType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case mobile
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "MOBILE": self = .mobile
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .mobile: return "MOBILE"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: PhoneType, rhs: PhoneType) -> Bool {
    switch (lhs, rhs) {
      case (.mobile, .mobile): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [PhoneType] {
    return [
      .mobile,
    ]
  }
}

public struct DocumentItemInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - serial
  ///   - validUntil
  ///   - type
  public init(serial: String, validUntil: Swift.Optional<String?> = nil, type: DocumentType) {
    graphQLMap = ["serial": serial, "validUntil": validUntil, "type": type]
  }

  public var serial: String {
    get {
      return graphQLMap["serial"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "serial")
    }
  }

  public var validUntil: Swift.Optional<String?> {
    get {
      return graphQLMap["validUntil"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "validUntil")
    }
  }

  public var type: DocumentType {
    get {
      return graphQLMap["type"] as! DocumentType
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }
}

public enum DocumentType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case passport
  case drivingLicense
  case identityCard
  case addressCard
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "PASSPORT": self = .passport
      case "DRIVING_LICENSE": self = .drivingLicense
      case "IDENTITY_CARD": self = .identityCard
      case "ADDRESS_CARD": self = .addressCard
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .passport: return "PASSPORT"
      case .drivingLicense: return "DRIVING_LICENSE"
      case .identityCard: return "IDENTITY_CARD"
      case .addressCard: return "ADDRESS_CARD"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: DocumentType, rhs: DocumentType) -> Bool {
    switch (lhs, rhs) {
      case (.passport, .passport): return true
      case (.drivingLicense, .drivingLicense): return true
      case (.identityCard, .identityCard): return true
      case (.addressCard, .addressCard): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [DocumentType] {
    return [
      .passport,
      .drivingLicense,
      .identityCard,
      .addressCard,
    ]
  }
}

public struct DocumentInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - serial
  ///   - validUntil
  public init(serial: String, validUntil: Swift.Optional<String?> = nil) {
    graphQLMap = ["serial": serial, "validUntil": validUntil]
  }

  public var serial: String {
    get {
      return graphQLMap["serial"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "serial")
    }
  }

  public var validUntil: Swift.Optional<String?> {
    get {
      return graphQLMap["validUntil"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "validUntil")
    }
  }
}

public struct EmailItemInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - address
  ///   - type
  public init(address: String, type: EmailType) {
    graphQLMap = ["address": address, "type": type]
  }

  public var address: String {
    get {
      return graphQLMap["address"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "address")
    }
  }

  public var type: EmailType {
    get {
      return graphQLMap["type"] as! EmailType
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "type")
    }
  }
}

public enum EmailType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case main
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "MAIN": self = .main
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .main: return "MAIN"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: EmailType, rhs: EmailType) -> Bool {
    switch (lhs, rhs) {
      case (.main, .main): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [EmailType] {
    return [
      .main,
    ]
  }
}

public struct EmailInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - address
  public init(address: String) {
    graphQLMap = ["address": address]
  }

  public var address: String {
    get {
      return graphQLMap["address"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "address")
    }
  }
}

public struct ConsentInfoInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - isPep
  ///   - taxation
  ///   - acceptTerms
  ///   - acceptConditions
  ///   - acceptPrivacyPolicy
  public init(isPep: Bool, taxation: [TaxationInput], acceptTerms: Swift.Optional<Bool?> = nil, acceptConditions: Swift.Optional<Bool?> = nil, acceptPrivacyPolicy: Swift.Optional<Bool?> = nil) {
    graphQLMap = ["isPep": isPep, "taxation": taxation, "acceptTerms": acceptTerms, "acceptConditions": acceptConditions, "acceptPrivacyPolicy": acceptPrivacyPolicy]
  }

  public var isPep: Bool {
    get {
      return graphQLMap["isPep"] as! Bool
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isPep")
    }
  }

  public var taxation: [TaxationInput] {
    get {
      return graphQLMap["taxation"] as! [TaxationInput]
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "taxation")
    }
  }

  public var acceptTerms: Swift.Optional<Bool?> {
    get {
      return graphQLMap["acceptTerms"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "acceptTerms")
    }
  }

  public var acceptConditions: Swift.Optional<Bool?> {
    get {
      return graphQLMap["acceptConditions"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "acceptConditions")
    }
  }

  public var acceptPrivacyPolicy: Swift.Optional<Bool?> {
    get {
      return graphQLMap["acceptPrivacyPolicy"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "acceptPrivacyPolicy")
    }
  }
}

public struct TaxationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - country
  ///   - taxNumber
  public init(country: String, taxNumber: Swift.Optional<String?> = nil) {
    graphQLMap = ["country": country, "taxNumber": taxNumber]
  }

  public var country: String {
    get {
      return graphQLMap["country"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "country")
    }
  }

  public var taxNumber: Swift.Optional<String?> {
    get {
      return graphQLMap["taxNumber"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "taxNumber")
    }
  }
}

public struct KycSurveyInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - incomingSources
  ///   - depositPlan
  ///   - transferPlan
  public init(incomingSources: Swift.Optional<IncomingSourcesInput?> = nil, depositPlan: Swift.Optional<PlanInput?> = nil, transferPlan: Swift.Optional<PlanInput?> = nil) {
    graphQLMap = ["incomingSources": incomingSources, "depositPlan": depositPlan, "transferPlan": transferPlan]
  }

  public var incomingSources: Swift.Optional<IncomingSourcesInput?> {
    get {
      return graphQLMap["incomingSources"] as? Swift.Optional<IncomingSourcesInput?> ?? Swift.Optional<IncomingSourcesInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "incomingSources")
    }
  }

  public var depositPlan: Swift.Optional<PlanInput?> {
    get {
      return graphQLMap["depositPlan"] as? Swift.Optional<PlanInput?> ?? Swift.Optional<PlanInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "depositPlan")
    }
  }

  public var transferPlan: Swift.Optional<PlanInput?> {
    get {
      return graphQLMap["transferPlan"] as? Swift.Optional<PlanInput?> ?? Swift.Optional<PlanInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "transferPlan")
    }
  }
}

public struct IncomingSourcesInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - salary
  ///   - other
  public init(salary: Bool, other: Swift.Optional<String?> = nil) {
    graphQLMap = ["salary": salary, "other": other]
  }

  public var salary: Bool {
    get {
      return graphQLMap["salary"] as! Bool
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "salary")
    }
  }

  public var other: Swift.Optional<String?> {
    get {
      return graphQLMap["other"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "other")
    }
  }
}

public struct PlanInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - amountFrom
  ///   - amountTo
  ///   - currency
  public init(amountFrom: Swift.Optional<Int?> = nil, amountTo: Swift.Optional<Int?> = nil, currency: Swift.Optional<String?> = nil) {
    graphQLMap = ["amountFrom": amountFrom, "amountTo": amountTo, "currency": currency]
  }

  public var amountFrom: Swift.Optional<Int?> {
    get {
      return graphQLMap["amountFrom"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "amountFrom")
    }
  }

  public var amountTo: Swift.Optional<Int?> {
    get {
      return graphQLMap["amountTo"] as? Swift.Optional<Int?> ?? Swift.Optional<Int?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "amountTo")
    }
  }

  public var currency: Swift.Optional<String?> {
    get {
      return graphQLMap["currency"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "currency")
    }
  }
}

public struct SignInfoInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - isSigned
  ///   - signedAt: UTC DateTime example: 2018-12-31T10:37:43.937Z
  public init(isSigned: Bool, signedAt: Swift.Optional<String?> = nil) {
    graphQLMap = ["isSigned": isSigned, "signedAt": signedAt]
  }

  public var isSigned: Bool {
    get {
      return graphQLMap["isSigned"] as! Bool
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "isSigned")
    }
  }

  /// UTC DateTime example: 2018-12-31T10:37:43.937Z
  public var signedAt: Swift.Optional<String?> {
    get {
      return graphQLMap["signedAt"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "signedAt")
    }
  }
}

public struct DmStatementInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - push
  ///   - email
  ///   - robinson
  public init(push: Swift.Optional<Bool?> = nil, email: Swift.Optional<Bool?> = nil, robinson: Swift.Optional<Bool?> = nil) {
    graphQLMap = ["push": push, "email": email, "robinson": robinson]
  }

  public var push: Swift.Optional<Bool?> {
    get {
      return graphQLMap["push"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "push")
    }
  }

  public var email: Swift.Optional<Bool?> {
    get {
      return graphQLMap["email"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "email")
    }
  }

  public var robinson: Swift.Optional<Bool?> {
    get {
      return graphQLMap["robinson"] as? Swift.Optional<Bool?> ?? Swift.Optional<Bool?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "robinson")
    }
  }
}

/// data input for getting transaction fee
public struct TransactionFeeInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - amount
  ///   - currencyCode
  public init(amount: Double, currencyCode: CurrenyCode) {
    graphQLMap = ["amount": amount, "currencyCode": currencyCode]
  }

  public var amount: Double {
    get {
      return graphQLMap["amount"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "amount")
    }
  }

  public var currencyCode: CurrenyCode {
    get {
      return graphQLMap["currencyCode"] as! CurrenyCode
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "currencyCode")
    }
  }
}

/// basic currency code
public enum CurrenyCode: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case huf
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "HUF": self = .huf
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .huf: return "HUF"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: CurrenyCode, rhs: CurrenyCode) -> Bool {
    switch (lhs, rhs) {
      case (.huf, .huf): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [CurrenyCode] {
    return [
      .huf,
    ]
  }
}

/// data input for initiating new transfer ~ payment instruction
public struct InitiateNewTransferInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - debtor
  ///   - creditor
  ///   - creditInstruction
  public init(debtor: DebtorInput, creditor: CreditorInput, creditInstruction: CreditInstructionInput) {
    graphQLMap = ["debtor": debtor, "creditor": creditor, "creditInstruction": creditInstruction]
  }

  public var debtor: DebtorInput {
    get {
      return graphQLMap["debtor"] as! DebtorInput
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "debtor")
    }
  }

  public var creditor: CreditorInput {
    get {
      return graphQLMap["creditor"] as! CreditorInput
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "creditor")
    }
  }

  public var creditInstruction: CreditInstructionInput {
    get {
      return graphQLMap["creditInstruction"] as! CreditInstructionInput
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "creditInstruction")
    }
  }
}

/// debtor specific input for a payment participant
public struct DebtorInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - identification
  ///   - identificationType
  public init(identification: String, identificationType: IdentificationType) {
    graphQLMap = ["identification": identification, "identificationType": identificationType]
  }

  public var identification: String {
    get {
      return graphQLMap["identification"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "identification")
    }
  }

  public var identificationType: IdentificationType {
    get {
      return graphQLMap["identificationType"] as! IdentificationType
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "identificationType")
    }
  }
}

/// way of identifing a payment participant
public enum IdentificationType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case iban
  case bban
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "IBAN": self = .iban
      case "BBAN": self = .bban
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .iban: return "IBAN"
      case .bban: return "BBAN"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: IdentificationType, rhs: IdentificationType) -> Bool {
    switch (lhs, rhs) {
      case (.iban, .iban): return true
      case (.bban, .bban): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [IdentificationType] {
    return [
      .iban,
      .bban,
    ]
  }
}

/// creditor specific input for a payment participant
public struct CreditorInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - name
  ///   - account
  public init(name: String, account: AccountInput) {
    graphQLMap = ["name": name, "account": account]
  }

  public var name: String {
    get {
      return graphQLMap["name"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "name")
    }
  }

  public var account: AccountInput {
    get {
      return graphQLMap["account"] as! AccountInput
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "account")
    }
  }
}

/// generic input for a payment participant's account details
public struct AccountInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - identificationType
  ///   - identification: identification input, eg.: iban or bban number
  public init(identificationType: IdentificationType, identification: String) {
    graphQLMap = ["identificationType": identificationType, "identification": identification]
  }

  public var identificationType: IdentificationType {
    get {
      return graphQLMap["identificationType"] as! IdentificationType
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "identificationType")
    }
  }

  /// identification input, eg.: iban or bban number
  public var identification: String {
    get {
      return graphQLMap["identification"] as! String
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "identification")
    }
  }
}

/// credit input for a payment initiation
public struct CreditInstructionInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - money
  ///   - remittanceInformation
  public init(money: MoneyInput, remittanceInformation: Swift.Optional<RemittanceInformationInput?> = nil) {
    graphQLMap = ["money": money, "remittanceInformation": remittanceInformation]
  }

  public var money: MoneyInput {
    get {
      return graphQLMap["money"] as! MoneyInput
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "money")
    }
  }

  public var remittanceInformation: Swift.Optional<RemittanceInformationInput?> {
    get {
      return graphQLMap["remittanceInformation"] as? Swift.Optional<RemittanceInformationInput?> ?? Swift.Optional<RemittanceInformationInput?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "remittanceInformation")
    }
  }
}

/// money input for the credit instruction
public struct MoneyInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - amount
  ///   - currencyCode
  public init(amount: Double, currencyCode: CurrenyCode) {
    graphQLMap = ["amount": amount, "currencyCode": currencyCode]
  }

  public var amount: Double {
    get {
      return graphQLMap["amount"] as! Double
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "amount")
    }
  }

  public var currencyCode: CurrenyCode {
    get {
      return graphQLMap["currencyCode"] as! CurrenyCode
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "currencyCode")
    }
  }
}

/// additional input for a payment initiation, eg.: reference text
public struct RemittanceInformationInput: GraphQLMapConvertible {
  public var graphQLMap: GraphQLMap

  /// - Parameters:
  ///   - reference
  public init(reference: Swift.Optional<String?> = nil) {
    graphQLMap = ["reference": reference]
  }

  public var reference: Swift.Optional<String?> {
    get {
      return graphQLMap["reference"] as? Swift.Optional<String?> ?? Swift.Optional<String?>.none
    }
    set {
      graphQLMap.updateValue(newValue, forKey: "reference")
    }
  }
}

public enum PdfDocumentType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case contract
  case statement
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CONTRACT": self = .contract
      case "STATEMENT": self = .statement
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .contract: return "CONTRACT"
      case .statement: return "STATEMENT"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: PdfDocumentType, rhs: PdfDocumentType) -> Bool {
    switch (lhs, rhs) {
      case (.contract, .contract): return true
      case (.statement, .statement): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [PdfDocumentType] {
    return [
      .contract,
      .statement,
    ]
  }
}

public enum ScaChallengeStatus: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case approved
  case declined
  case pending
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "APPROVED": self = .approved
      case "DECLINED": self = .declined
      case "PENDING": self = .pending
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .approved: return "APPROVED"
      case .declined: return "DECLINED"
      case .pending: return "PENDING"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ScaChallengeStatus, rhs: ScaChallengeStatus) -> Bool {
    switch (lhs, rhs) {
      case (.approved, .approved): return true
      case (.declined, .declined): return true
      case (.pending, .pending): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [ScaChallengeStatus] {
    return [
      .approved,
      .declined,
      .pending,
    ]
  }
}

public enum AccountingUnitType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case credit
  case debit
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "CREDIT": self = .credit
      case "DEBIT": self = .debit
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .credit: return "CREDIT"
      case .debit: return "DEBIT"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: AccountingUnitType, rhs: AccountingUnitType) -> Bool {
    switch (lhs, rhs) {
      case (.credit, .credit): return true
      case (.debit, .debit): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [AccountingUnitType] {
    return [
      .credit,
      .debit,
    ]
  }
}

public enum AccountingUnitSubType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case fizsz
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "FIZSZ": self = .fizsz
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .fizsz: return "FIZSZ"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: AccountingUnitSubType, rhs: AccountingUnitSubType) -> Bool {
    switch (lhs, rhs) {
      case (.fizsz, .fizsz): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [AccountingUnitSubType] {
    return [
      .fizsz,
    ]
  }
}

public enum LifecycleStatus: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case active
  case frozen
  case blocked
  case closing
  case closed
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ACTIVE": self = .active
      case "FROZEN": self = .frozen
      case "BLOCKED": self = .blocked
      case "CLOSING": self = .closing
      case "CLOSED": self = .closed
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .active: return "ACTIVE"
      case .frozen: return "FROZEN"
      case .blocked: return "BLOCKED"
      case .closing: return "CLOSING"
      case .closed: return "CLOSED"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: LifecycleStatus, rhs: LifecycleStatus) -> Bool {
    switch (lhs, rhs) {
      case (.active, .active): return true
      case (.frozen, .frozen): return true
      case (.blocked, .blocked): return true
      case (.closing, .closing): return true
      case (.closed, .closed): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [LifecycleStatus] {
    return [
      .active,
      .frozen,
      .blocked,
      .closing,
      .closed,
    ]
  }
}

public enum SourceSystem: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case mtb
  case mkb
  case bb
  @available(*, deprecated, message: "Replaced with FOUNDATION")
  case mbh
  case foundation
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "MTB": self = .mtb
      case "MKB": self = .mkb
      case "BB": self = .bb
      case "MBH": self = .mbh
      case "FOUNDATION": self = .foundation
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .mtb: return "MTB"
      case .mkb: return "MKB"
      case .bb: return "BB"
      case .mbh: return "MBH"
      case .foundation: return "FOUNDATION"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: SourceSystem, rhs: SourceSystem) -> Bool {
    switch (lhs, rhs) {
      case (.mtb, .mtb): return true
      case (.mkb, .mkb): return true
      case (.bb, .bb): return true
      case (.mbh, .mbh): return true
      case (.foundation, .foundation): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [SourceSystem] {
    return [
      .mtb,
      .mkb,
      .bb,
      .mbh,
      .foundation,
    ]
  }
}

public enum AccountFlag: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case limitedAccount
  case accountClosing
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "LIMITED_ACCOUNT": self = .limitedAccount
      case "ACCOUNT_CLOSING": self = .accountClosing
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .limitedAccount: return "LIMITED_ACCOUNT"
      case .accountClosing: return "ACCOUNT_CLOSING"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: AccountFlag, rhs: AccountFlag) -> Bool {
    switch (lhs, rhs) {
      case (.limitedAccount, .limitedAccount): return true
      case (.accountClosing, .accountClosing): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [AccountFlag] {
    return [
      .limitedAccount,
      .accountClosing,
    ]
  }
}

public enum ProxyIdStatus: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case active
  case pending
  case deleted
  case expired
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "ACTIVE": self = .active
      case "PENDING": self = .pending
      case "DELETED": self = .deleted
      case "EXPIRED": self = .expired
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .active: return "ACTIVE"
      case .pending: return "PENDING"
      case .deleted: return "DELETED"
      case .expired: return "EXPIRED"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ProxyIdStatus, rhs: ProxyIdStatus) -> Bool {
    switch (lhs, rhs) {
      case (.active, .active): return true
      case (.pending, .pending): return true
      case (.deleted, .deleted): return true
      case (.expired, .expired): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [ProxyIdStatus] {
    return [
      .active,
      .pending,
      .deleted,
      .expired,
    ]
  }
}

public enum ProxyIdType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case mobNb
  case emailAdr
  case othr
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "MobNb": self = .mobNb
      case "EmailAdr": self = .emailAdr
      case "Othr": self = .othr
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .mobNb: return "MobNb"
      case .emailAdr: return "EmailAdr"
      case .othr: return "Othr"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: ProxyIdType, rhs: ProxyIdType) -> Bool {
    switch (lhs, rhs) {
      case (.mobNb, .mobNb): return true
      case (.emailAdr, .emailAdr): return true
      case (.othr, .othr): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [ProxyIdType] {
    return [
      .mobNb,
      .emailAdr,
      .othr,
    ]
  }
}

/// card transaction type
public enum CardTransactionCardTransactionType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case purchase
  case purchaseWithCashback
  case refund
  case cashWithdrawal
  case balanceInquiry
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "PURCHASE": self = .purchase
      case "PURCHASE_WITH_CASHBACK": self = .purchaseWithCashback
      case "REFUND": self = .refund
      case "CASH_WITHDRAWAL": self = .cashWithdrawal
      case "BALANCE_INQUIRY": self = .balanceInquiry
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .purchase: return "PURCHASE"
      case .purchaseWithCashback: return "PURCHASE_WITH_CASHBACK"
      case .refund: return "REFUND"
      case .cashWithdrawal: return "CASH_WITHDRAWAL"
      case .balanceInquiry: return "BALANCE_INQUIRY"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: CardTransactionCardTransactionType, rhs: CardTransactionCardTransactionType) -> Bool {
    switch (lhs, rhs) {
      case (.purchase, .purchase): return true
      case (.purchaseWithCashback, .purchaseWithCashback): return true
      case (.refund, .refund): return true
      case (.cashWithdrawal, .cashWithdrawal): return true
      case (.balanceInquiry, .balanceInquiry): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [CardTransactionCardTransactionType] {
    return [
      .purchase,
      .purchaseWithCashback,
      .refund,
      .cashWithdrawal,
      .balanceInquiry,
    ]
  }
}

/// card transaction decline reason
public enum CardTransactionDeclineReason: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case pinInvalid
  case cardExpired
  case cardSuspended
  case cardBlocked
  case cardFrozen
  case expirationIncorrect
  case cvvIncorrect
  case pinTriesExceed
  case accountLimit
  case balanceLow
  case internalError
  case internalErrorDowntime
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "PIN_INVALID": self = .pinInvalid
      case "CARD_EXPIRED": self = .cardExpired
      case "CARD_SUSPENDED": self = .cardSuspended
      case "CARD_BLOCKED": self = .cardBlocked
      case "CARD_FROZEN": self = .cardFrozen
      case "EXPIRATION_INCORRECT": self = .expirationIncorrect
      case "CVV_INCORRECT": self = .cvvIncorrect
      case "PIN_TRIES_EXCEED": self = .pinTriesExceed
      case "ACCOUNT_LIMIT": self = .accountLimit
      case "BALANCE_LOW": self = .balanceLow
      case "INTERNAL_ERROR": self = .internalError
      case "INTERNAL_ERROR_DOWNTIME": self = .internalErrorDowntime
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .pinInvalid: return "PIN_INVALID"
      case .cardExpired: return "CARD_EXPIRED"
      case .cardSuspended: return "CARD_SUSPENDED"
      case .cardBlocked: return "CARD_BLOCKED"
      case .cardFrozen: return "CARD_FROZEN"
      case .expirationIncorrect: return "EXPIRATION_INCORRECT"
      case .cvvIncorrect: return "CVV_INCORRECT"
      case .pinTriesExceed: return "PIN_TRIES_EXCEED"
      case .accountLimit: return "ACCOUNT_LIMIT"
      case .balanceLow: return "BALANCE_LOW"
      case .internalError: return "INTERNAL_ERROR"
      case .internalErrorDowntime: return "INTERNAL_ERROR_DOWNTIME"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: CardTransactionDeclineReason, rhs: CardTransactionDeclineReason) -> Bool {
    switch (lhs, rhs) {
      case (.pinInvalid, .pinInvalid): return true
      case (.cardExpired, .cardExpired): return true
      case (.cardSuspended, .cardSuspended): return true
      case (.cardBlocked, .cardBlocked): return true
      case (.cardFrozen, .cardFrozen): return true
      case (.expirationIncorrect, .expirationIncorrect): return true
      case (.cvvIncorrect, .cvvIncorrect): return true
      case (.pinTriesExceed, .pinTriesExceed): return true
      case (.accountLimit, .accountLimit): return true
      case (.balanceLow, .balanceLow): return true
      case (.internalError, .internalError): return true
      case (.internalErrorDowntime, .internalErrorDowntime): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [CardTransactionDeclineReason] {
    return [
      .pinInvalid,
      .cardExpired,
      .cardSuspended,
      .cardBlocked,
      .cardFrozen,
      .expirationIncorrect,
      .cvvIncorrect,
      .pinTriesExceed,
      .accountLimit,
      .balanceLow,
      .internalError,
      .internalErrorDowntime,
    ]
  }
}

/// PaymentTransactionDirection
public enum PaymentTransactionDirection: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case incoming
  case outgoing
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "INCOMING": self = .incoming
      case "OUTGOING": self = .outgoing
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .incoming: return "INCOMING"
      case .outgoing: return "OUTGOING"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: PaymentTransactionDirection, rhs: PaymentTransactionDirection) -> Bool {
    switch (lhs, rhs) {
      case (.incoming, .incoming): return true
      case (.outgoing, .outgoing): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [PaymentTransactionDirection] {
    return [
      .incoming,
      .outgoing,
    ]
  }
}

/// PaymentTransactionStatus
public enum PaymentTransactionStatus: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case initiated
  case pending
  case rejected
  case completed
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "INITIATED": self = .initiated
      case "PENDING": self = .pending
      case "REJECTED": self = .rejected
      case "COMPLETED": self = .completed
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .initiated: return "INITIATED"
      case .pending: return "PENDING"
      case .rejected: return "REJECTED"
      case .completed: return "COMPLETED"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: PaymentTransactionStatus, rhs: PaymentTransactionStatus) -> Bool {
    switch (lhs, rhs) {
      case (.initiated, .initiated): return true
      case (.pending, .pending): return true
      case (.rejected, .rejected): return true
      case (.completed, .completed): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [PaymentTransactionStatus] {
    return [
      .initiated,
      .pending,
      .rejected,
      .completed,
    ]
  }
}

/// card transaction limit type
public enum CardTransactionCardLimitType: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case posDaily
  case vposDaily
  case cashWithdrawalDaily
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "POS_DAILY": self = .posDaily
      case "VPOS_DAILY": self = .vposDaily
      case "CASH_WITHDRAWAL_DAILY": self = .cashWithdrawalDaily
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .posDaily: return "POS_DAILY"
      case .vposDaily: return "VPOS_DAILY"
      case .cashWithdrawalDaily: return "CASH_WITHDRAWAL_DAILY"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: CardTransactionCardLimitType, rhs: CardTransactionCardLimitType) -> Bool {
    switch (lhs, rhs) {
      case (.posDaily, .posDaily): return true
      case (.vposDaily, .vposDaily): return true
      case (.cashWithdrawalDaily, .cashWithdrawalDaily): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [CardTransactionCardLimitType] {
    return [
      .posDaily,
      .vposDaily,
      .cashWithdrawalDaily,
    ]
  }
}

public enum TaxResidency: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case hungary
  case hungaryAbroad
  case abroad
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "HUNGARY": self = .hungary
      case "HUNGARY_ABROAD": self = .hungaryAbroad
      case "ABROAD": self = .abroad
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .hungary: return "HUNGARY"
      case .hungaryAbroad: return "HUNGARY_ABROAD"
      case .abroad: return "ABROAD"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: TaxResidency, rhs: TaxResidency) -> Bool {
    switch (lhs, rhs) {
      case (.hungary, .hungary): return true
      case (.hungaryAbroad, .hungaryAbroad): return true
      case (.abroad, .abroad): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [TaxResidency] {
    return [
      .hungary,
      .hungaryAbroad,
      .abroad,
    ]
  }
}

/// Rejection reason
public enum RejectionReason: RawRepresentable, Equatable, Hashable, CaseIterable, Apollo.JSONDecodable, Apollo.JSONEncodable {
  public typealias RawValue = String
  case invalidCreditorIban
  case invalidDebtorIban
  case invalidCreditorBban
  case invalidDebtorBban
  case noBalanceCoverage
  case creditorAndDebtorIdentificationsAreTheSame
  case creditorAccountNotIntrabank
  case creditorAccountClosed
  case dailyLimitReached
  case invalidReference
  case invalidCreditorName
  case breachTermsAndConditions
  case coreBankingSystemViolation
  /// Auto generated constant for unknown enum values
  case __unknown(RawValue)

  public init?(rawValue: RawValue) {
    switch rawValue {
      case "INVALID_CREDITOR_IBAN": self = .invalidCreditorIban
      case "INVALID_DEBTOR_IBAN": self = .invalidDebtorIban
      case "INVALID_CREDITOR_BBAN": self = .invalidCreditorBban
      case "INVALID_DEBTOR_BBAN": self = .invalidDebtorBban
      case "NO_BALANCE_COVERAGE": self = .noBalanceCoverage
      case "CREDITOR_AND_DEBTOR_IDENTIFICATIONS_ARE_THE_SAME": self = .creditorAndDebtorIdentificationsAreTheSame
      case "CREDITOR_ACCOUNT_NOT_INTRABANK": self = .creditorAccountNotIntrabank
      case "CREDITOR_ACCOUNT_CLOSED": self = .creditorAccountClosed
      case "DAILY_LIMIT_REACHED": self = .dailyLimitReached
      case "INVALID_REFERENCE": self = .invalidReference
      case "INVALID_CREDITOR_NAME": self = .invalidCreditorName
      case "BREACH_TERMS_AND_CONDITIONS": self = .breachTermsAndConditions
      case "CORE_BANKING_SYSTEM_VIOLATION": self = .coreBankingSystemViolation
      default: self = .__unknown(rawValue)
    }
  }

  public var rawValue: RawValue {
    switch self {
      case .invalidCreditorIban: return "INVALID_CREDITOR_IBAN"
      case .invalidDebtorIban: return "INVALID_DEBTOR_IBAN"
      case .invalidCreditorBban: return "INVALID_CREDITOR_BBAN"
      case .invalidDebtorBban: return "INVALID_DEBTOR_BBAN"
      case .noBalanceCoverage: return "NO_BALANCE_COVERAGE"
      case .creditorAndDebtorIdentificationsAreTheSame: return "CREDITOR_AND_DEBTOR_IDENTIFICATIONS_ARE_THE_SAME"
      case .creditorAccountNotIntrabank: return "CREDITOR_ACCOUNT_NOT_INTRABANK"
      case .creditorAccountClosed: return "CREDITOR_ACCOUNT_CLOSED"
      case .dailyLimitReached: return "DAILY_LIMIT_REACHED"
      case .invalidReference: return "INVALID_REFERENCE"
      case .invalidCreditorName: return "INVALID_CREDITOR_NAME"
      case .breachTermsAndConditions: return "BREACH_TERMS_AND_CONDITIONS"
      case .coreBankingSystemViolation: return "CORE_BANKING_SYSTEM_VIOLATION"
      case .__unknown(let value): return value
    }
  }

  public static func == (lhs: RejectionReason, rhs: RejectionReason) -> Bool {
    switch (lhs, rhs) {
      case (.invalidCreditorIban, .invalidCreditorIban): return true
      case (.invalidDebtorIban, .invalidDebtorIban): return true
      case (.invalidCreditorBban, .invalidCreditorBban): return true
      case (.invalidDebtorBban, .invalidDebtorBban): return true
      case (.noBalanceCoverage, .noBalanceCoverage): return true
      case (.creditorAndDebtorIdentificationsAreTheSame, .creditorAndDebtorIdentificationsAreTheSame): return true
      case (.creditorAccountNotIntrabank, .creditorAccountNotIntrabank): return true
      case (.creditorAccountClosed, .creditorAccountClosed): return true
      case (.dailyLimitReached, .dailyLimitReached): return true
      case (.invalidReference, .invalidReference): return true
      case (.invalidCreditorName, .invalidCreditorName): return true
      case (.breachTermsAndConditions, .breachTermsAndConditions): return true
      case (.coreBankingSystemViolation, .coreBankingSystemViolation): return true
      case (.__unknown(let lhsValue), .__unknown(let rhsValue)): return lhsValue == rhsValue
      default: return false
    }
  }

  public static var allCases: [RejectionReason] {
    return [
      .invalidCreditorIban,
      .invalidDebtorIban,
      .invalidCreditorBban,
      .invalidDebtorBban,
      .noBalanceCoverage,
      .creditorAndDebtorIdentificationsAreTheSame,
      .creditorAccountNotIntrabank,
      .creditorAccountClosed,
      .dailyLimitReached,
      .invalidReference,
      .invalidCreditorName,
      .breachTermsAndConditions,
      .coreBankingSystemViolation,
    ]
  }
}

public final class AccountListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query accountList {
      accountsList {
        __typename
        ...AccountFragment
      }
    }
    """

  public let operationName: String = "accountList"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + AccountFragment.fragmentDefinition)
    document.append("\n" + BalanceFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("accountsList", type: .nonNull(.list(.nonNull(.object(AccountsList.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(accountsList: [AccountsList]) {
      self.init(unsafeResultMap: ["__typename": "Query", "accountsList": accountsList.map { (value: AccountsList) -> ResultMap in value.resultMap }])
    }

    public var accountsList: [AccountsList] {
      get {
        return (resultMap["accountsList"] as! [ResultMap]).map { (value: ResultMap) -> AccountsList in AccountsList(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: AccountsList) -> ResultMap in value.resultMap }, forKey: "accountsList")
      }
    }

    public struct AccountsList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Account"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(AccountFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var accountFragment: AccountFragment {
          get {
            return AccountFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CloseAccountMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation closeAccount($input: CloseAccountInput!) {
      closeAccount(input: $input) {
        __typename
        ...AccountFragment
      }
    }
    """

  public let operationName: String = "closeAccount"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + AccountFragment.fragmentDefinition)
    document.append("\n" + BalanceFragment.fragmentDefinition)
    return document
  }

  public var input: CloseAccountInput

  public init(input: CloseAccountInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("closeAccount", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(CloseAccount.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(closeAccount: CloseAccount) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "closeAccount": closeAccount.resultMap])
    }

    public var closeAccount: CloseAccount {
      get {
        return CloseAccount(unsafeResultMap: resultMap["closeAccount"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "closeAccount")
      }
    }

    public struct CloseAccount: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Account"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(AccountFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var accountFragment: AccountFragment {
          get {
            return AccountFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CreateAccountClosureStatementMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation createAccountClosureStatement($input: CreateAccountClosureStatementInput!) {
      createAccountClosureStatement(input: $input) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "createAccountClosureStatement"

  public var input: CreateAccountClosureStatementInput

  public init(input: CreateAccountClosureStatementInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("createAccountClosureStatement", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(CreateAccountClosureStatement.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(createAccountClosureStatement: CreateAccountClosureStatement) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "createAccountClosureStatement": createAccountClosureStatement.resultMap])
    }

    public var createAccountClosureStatement: CreateAccountClosureStatement {
      get {
        return CreateAccountClosureStatement(unsafeResultMap: resultMap["createAccountClosureStatement"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "createAccountClosureStatement")
      }
    }

    public struct CreateAccountClosureStatement: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["StatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(Status.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: Status) {
        self.init(unsafeResultMap: ["__typename": "StatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: Status {
        get {
          return resultMap["status"]! as! Status
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class GetAccountClosureStatementQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getAccountClosureStatement($accountId: String!) {
      getAccountClosureStatement(accountId: $accountId) {
        __typename
        expiresAt
        contractInfo {
          __typename
          ...AccountClosureStatementInfoFragment
        }
      }
    }
    """

  public let operationName: String = "getAccountClosureStatement"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + AccountClosureStatementInfoFragment.fragmentDefinition)
    return document
  }

  public var accountId: String

  public init(accountId: String) {
    self.accountId = accountId
  }

  public var variables: GraphQLMap? {
    return ["accountId": accountId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getAccountClosureStatement", arguments: ["accountId": GraphQLVariable("accountId")], type: .nonNull(.object(GetAccountClosureStatement.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getAccountClosureStatement: GetAccountClosureStatement) {
      self.init(unsafeResultMap: ["__typename": "Query", "getAccountClosureStatement": getAccountClosureStatement.resultMap])
    }

    public var getAccountClosureStatement: GetAccountClosureStatement {
      get {
        return GetAccountClosureStatement(unsafeResultMap: resultMap["getAccountClosureStatement"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getAccountClosureStatement")
      }
    }

    public struct GetAccountClosureStatement: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["AccountClosureStatement"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("expiresAt", type: .nonNull(.scalar(String.self))),
          GraphQLField("contractInfo", type: .nonNull(.object(ContractInfo.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(expiresAt: String, contractInfo: ContractInfo) {
        self.init(unsafeResultMap: ["__typename": "AccountClosureStatement", "expiresAt": expiresAt, "contractInfo": contractInfo.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var expiresAt: String {
        get {
          return resultMap["expiresAt"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "expiresAt")
        }
      }

      public var contractInfo: ContractInfo {
        get {
          return ContractInfo(unsafeResultMap: resultMap["contractInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "contractInfo")
        }
      }

      public struct ContractInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["AccountClosureStatementInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(AccountClosureStatementInfoFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(polling: Double, contractId: String? = nil, successful: Bool, error: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "AccountClosureStatementInfo", "polling": polling, "contractId": contractId, "successful": successful, "error": error])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var accountClosureStatementInfoFragment: AccountClosureStatementInfoFragment {
            get {
              return AccountClosureStatementInfoFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class ListStatementsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query listStatements {
      listStatements {
        __typename
        ...StatementFragment
      }
    }
    """

  public let operationName: String = "listStatements"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + StatementFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("listStatements", type: .nonNull(.list(.nonNull(.object(ListStatement.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(listStatements: [ListStatement]) {
      self.init(unsafeResultMap: ["__typename": "Query", "listStatements": listStatements.map { (value: ListStatement) -> ResultMap in value.resultMap }])
    }

    public var listStatements: [ListStatement] {
      get {
        return (resultMap["listStatements"] as! [ResultMap]).map { (value: ResultMap) -> ListStatement in ListStatement(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: ListStatement) -> ResultMap in value.resultMap }, forKey: "listStatements")
      }
    }

    public struct ListStatement: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Statement"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(StatementFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(statementId: String, periodStart: String, periodEnd: String) {
        self.init(unsafeResultMap: ["__typename": "Statement", "statementId": statementId, "periodStart": periodStart, "periodEnd": periodEnd])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var statementFragment: StatementFragment {
          get {
            return StatementFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class ProxyIdCreateMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation proxyIdCreate($alias: String!, $bic: String!, $iban: String!) {
      proxyIdCreate(alias: $alias, bic: $bic, iban: $iban) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "proxyIdCreate"

  public var alias: String
  public var bic: String
  public var iban: String

  public init(alias: String, bic: String, iban: String) {
    self.alias = alias
    self.bic = bic
    self.iban = iban
  }

  public var variables: GraphQLMap? {
    return ["alias": alias, "bic": bic, "iban": iban]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("proxyIdCreate", arguments: ["alias": GraphQLVariable("alias"), "bic": GraphQLVariable("bic"), "iban": GraphQLVariable("iban")], type: .nonNull(.object(ProxyIdCreate.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(proxyIdCreate: ProxyIdCreate) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "proxyIdCreate": proxyIdCreate.resultMap])
    }

    public var proxyIdCreate: ProxyIdCreate {
      get {
        return ProxyIdCreate(unsafeResultMap: resultMap["proxyIdCreate"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "proxyIdCreate")
      }
    }

    public struct ProxyIdCreate: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["StatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(Status.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: Status) {
        self.init(unsafeResultMap: ["__typename": "StatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: Status {
        get {
          return resultMap["status"]! as! Status
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class ProxyIdDeleteMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation proxyIdDelete($iban: String!, $bic: String!, $alias: String!) {
      proxyIdDelete(iban: $iban, bic: $bic, alias: $alias) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "proxyIdDelete"

  public var iban: String
  public var bic: String
  public var alias: String

  public init(iban: String, bic: String, alias: String) {
    self.iban = iban
    self.bic = bic
    self.alias = alias
  }

  public var variables: GraphQLMap? {
    return ["iban": iban, "bic": bic, "alias": alias]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("proxyIdDelete", arguments: ["iban": GraphQLVariable("iban"), "bic": GraphQLVariable("bic"), "alias": GraphQLVariable("alias")], type: .nonNull(.object(ProxyIdDelete.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(proxyIdDelete: ProxyIdDelete) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "proxyIdDelete": proxyIdDelete.resultMap])
    }

    public var proxyIdDelete: ProxyIdDelete {
      get {
        return ProxyIdDelete(unsafeResultMap: resultMap["proxyIdDelete"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "proxyIdDelete")
      }
    }

    public struct ProxyIdDelete: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["StatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(Status.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: Status) {
        self.init(unsafeResultMap: ["__typename": "StatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: Status {
        get {
          return resultMap["status"]! as! Status
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class SetLimitMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation setLimit($accountId: String!, $limitName: LimitType!, $limitValue: Int!) {
      setLimit(accountId: $accountId, limitName: $limitName, limitValue: $limitValue) {
        __typename
        ...AccountFragment
      }
    }
    """

  public let operationName: String = "setLimit"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + AccountFragment.fragmentDefinition)
    document.append("\n" + BalanceFragment.fragmentDefinition)
    return document
  }

  public var accountId: String
  public var limitName: LimitType
  public var limitValue: Int

  public init(accountId: String, limitName: LimitType, limitValue: Int) {
    self.accountId = accountId
    self.limitName = limitName
    self.limitValue = limitValue
  }

  public var variables: GraphQLMap? {
    return ["accountId": accountId, "limitName": limitName, "limitValue": limitValue]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("setLimit", arguments: ["accountId": GraphQLVariable("accountId"), "limitName": GraphQLVariable("limitName"), "limitValue": GraphQLVariable("limitValue")], type: .nonNull(.object(SetLimit.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(setLimit: SetLimit) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "setLimit": setLimit.resultMap])
    }

    public var setLimit: SetLimit {
      get {
        return SetLimit(unsafeResultMap: resultMap["setLimit"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "setLimit")
      }
    }

    public struct SetLimit: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Account"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(AccountFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var accountFragment: AccountFragment {
          get {
            return AccountFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CardDetailsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query cardDetails($encryptedKey: String!, $cardToken: String!) {
      cardDetails(encryptedKey: $encryptedKey, cardToken: $cardToken) {
        __typename
        encryptedPan {
          __typename
          ...SecureFlowFragment
        }
        encryptedCvc {
          __typename
          ...SecureFlowFragment
        }
        expDate
        nameOnCard
      }
    }
    """

  public let operationName: String = "cardDetails"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + SecureFlowFragment.fragmentDefinition)
    return document
  }

  public var encryptedKey: String
  public var cardToken: String

  public init(encryptedKey: String, cardToken: String) {
    self.encryptedKey = encryptedKey
    self.cardToken = cardToken
  }

  public var variables: GraphQLMap? {
    return ["encryptedKey": encryptedKey, "cardToken": cardToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("cardDetails", arguments: ["encryptedKey": GraphQLVariable("encryptedKey"), "cardToken": GraphQLVariable("cardToken")], type: .nonNull(.object(CardDetail.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(cardDetails: CardDetail) {
      self.init(unsafeResultMap: ["__typename": "Query", "cardDetails": cardDetails.resultMap])
    }

    public var cardDetails: CardDetail {
      get {
        return CardDetail(unsafeResultMap: resultMap["cardDetails"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "cardDetails")
      }
    }

    public struct CardDetail: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["CardDetailsResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("encryptedPan", type: .nonNull(.object(EncryptedPan.selections))),
          GraphQLField("encryptedCvc", type: .nonNull(.object(EncryptedCvc.selections))),
          GraphQLField("expDate", type: .nonNull(.scalar(String.self))),
          GraphQLField("nameOnCard", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(encryptedPan: EncryptedPan, encryptedCvc: EncryptedCvc, expDate: String, nameOnCard: String) {
        self.init(unsafeResultMap: ["__typename": "CardDetailsResponse", "encryptedPan": encryptedPan.resultMap, "encryptedCvc": encryptedCvc.resultMap, "expDate": expDate, "nameOnCard": nameOnCard])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var encryptedPan: EncryptedPan {
        get {
          return EncryptedPan(unsafeResultMap: resultMap["encryptedPan"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "encryptedPan")
        }
      }

      public var encryptedCvc: EncryptedCvc {
        get {
          return EncryptedCvc(unsafeResultMap: resultMap["encryptedCvc"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "encryptedCvc")
        }
      }

      public var expDate: String {
        get {
          return resultMap["expDate"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "expDate")
        }
      }

      public var nameOnCard: String {
        get {
          return resultMap["nameOnCard"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "nameOnCard")
        }
      }

      public struct EncryptedPan: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SecureFlowResponse"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(SecureFlowFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(iv: String, data: String) {
          self.init(unsafeResultMap: ["__typename": "SecureFlowResponse", "iv": iv, "data": data])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var secureFlowFragment: SecureFlowFragment {
            get {
              return SecureFlowFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }

      public struct EncryptedCvc: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SecureFlowResponse"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(SecureFlowFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(iv: String, data: String) {
          self.init(unsafeResultMap: ["__typename": "SecureFlowResponse", "iv": iv, "data": data])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var secureFlowFragment: SecureFlowFragment {
            get {
              return SecureFlowFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class CardPinQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query cardPin($encryptedKey: String!, $cardToken: String!) {
      cardPin(encryptedKey: $encryptedKey, cardToken: $cardToken) {
        __typename
        encryptedPin {
          __typename
          ...SecureFlowFragment
        }
      }
    }
    """

  public let operationName: String = "cardPin"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + SecureFlowFragment.fragmentDefinition)
    return document
  }

  public var encryptedKey: String
  public var cardToken: String

  public init(encryptedKey: String, cardToken: String) {
    self.encryptedKey = encryptedKey
    self.cardToken = cardToken
  }

  public var variables: GraphQLMap? {
    return ["encryptedKey": encryptedKey, "cardToken": cardToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("cardPin", arguments: ["encryptedKey": GraphQLVariable("encryptedKey"), "cardToken": GraphQLVariable("cardToken")], type: .nonNull(.object(CardPin.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(cardPin: CardPin) {
      self.init(unsafeResultMap: ["__typename": "Query", "cardPin": cardPin.resultMap])
    }

    public var cardPin: CardPin {
      get {
        return CardPin(unsafeResultMap: resultMap["cardPin"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "cardPin")
      }
    }

    public struct CardPin: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["CardPinResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("encryptedPin", type: .nonNull(.object(EncryptedPin.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(encryptedPin: EncryptedPin) {
        self.init(unsafeResultMap: ["__typename": "CardPinResponse", "encryptedPin": encryptedPin.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var encryptedPin: EncryptedPin {
        get {
          return EncryptedPin(unsafeResultMap: resultMap["encryptedPin"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "encryptedPin")
        }
      }

      public struct EncryptedPin: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SecureFlowResponse"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(SecureFlowFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(iv: String, data: String) {
          self.init(unsafeResultMap: ["__typename": "SecureFlowResponse", "iv": iv, "data": data])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var secureFlowFragment: SecureFlowFragment {
            get {
              return SecureFlowFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class CardsGetQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query cardsGet($accountId: String!) {
      cardsGet(accountId: $accountId) {
        __typename
        cardToken
        nameOnCard
        lastNumbers
        type
        imageName
        status
        limits {
          __typename
          cashWithdrawalLimit {
            __typename
            ...CardLimitFragment
          }
          posLimit {
            __typename
            ...CardLimitFragment
          }
          vposLimit {
            __typename
            ...CardLimitFragment
          }
        }
        cardErrors {
          __typename
          ...UserTransactionErrorFragment
        }
        reordered
      }
    }
    """

  public let operationName: String = "cardsGet"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + CardLimitFragment.fragmentDefinition)
    document.append("\n" + UserTransactionErrorFragment.fragmentDefinition)
    return document
  }

  public var accountId: String

  public init(accountId: String) {
    self.accountId = accountId
  }

  public var variables: GraphQLMap? {
    return ["accountId": accountId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("cardsGet", arguments: ["accountId": GraphQLVariable("accountId")], type: .nonNull(.list(.nonNull(.object(CardsGet.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(cardsGet: [CardsGet]) {
      self.init(unsafeResultMap: ["__typename": "Query", "cardsGet": cardsGet.map { (value: CardsGet) -> ResultMap in value.resultMap }])
    }

    public var cardsGet: [CardsGet] {
      get {
        return (resultMap["cardsGet"] as! [ResultMap]).map { (value: ResultMap) -> CardsGet in CardsGet(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: CardsGet) -> ResultMap in value.resultMap }, forKey: "cardsGet")
      }
    }

    public struct CardsGet: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Card"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("cardToken", type: .nonNull(.scalar(String.self))),
          GraphQLField("nameOnCard", type: .nonNull(.scalar(String.self))),
          GraphQLField("lastNumbers", type: .nonNull(.scalar(String.self))),
          GraphQLField("type", type: .nonNull(.scalar(String.self))),
          GraphQLField("imageName", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(String.self))),
          GraphQLField("limits", type: .nonNull(.object(Limit.selections))),
          GraphQLField("cardErrors", type: .nonNull(.list(.nonNull(.object(CardError.selections))))),
          GraphQLField("reordered", type: .nonNull(.scalar(Bool.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(cardToken: String, nameOnCard: String, lastNumbers: String, type: String, imageName: String, status: String, limits: Limit, cardErrors: [CardError], reordered: Bool) {
        self.init(unsafeResultMap: ["__typename": "Card", "cardToken": cardToken, "nameOnCard": nameOnCard, "lastNumbers": lastNumbers, "type": type, "imageName": imageName, "status": status, "limits": limits.resultMap, "cardErrors": cardErrors.map { (value: CardError) -> ResultMap in value.resultMap }, "reordered": reordered])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var cardToken: String {
        get {
          return resultMap["cardToken"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "cardToken")
        }
      }

      public var nameOnCard: String {
        get {
          return resultMap["nameOnCard"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "nameOnCard")
        }
      }

      public var lastNumbers: String {
        get {
          return resultMap["lastNumbers"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "lastNumbers")
        }
      }

      public var type: String {
        get {
          return resultMap["type"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "type")
        }
      }

      public var imageName: String {
        get {
          return resultMap["imageName"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "imageName")
        }
      }

      public var status: String {
        get {
          return resultMap["status"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }

      public var limits: Limit {
        get {
          return Limit(unsafeResultMap: resultMap["limits"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "limits")
        }
      }

      public var cardErrors: [CardError] {
        get {
          return (resultMap["cardErrors"] as! [ResultMap]).map { (value: ResultMap) -> CardError in CardError(unsafeResultMap: value) }
        }
        set {
          resultMap.updateValue(newValue.map { (value: CardError) -> ResultMap in value.resultMap }, forKey: "cardErrors")
        }
      }

      public var reordered: Bool {
        get {
          return resultMap["reordered"]! as! Bool
        }
        set {
          resultMap.updateValue(newValue, forKey: "reordered")
        }
      }

      public struct Limit: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["CardLimits"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("cashWithdrawalLimit", type: .nonNull(.object(CashWithdrawalLimit.selections))),
            GraphQLField("posLimit", type: .nonNull(.object(PosLimit.selections))),
            GraphQLField("vposLimit", type: .nonNull(.object(VposLimit.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(cashWithdrawalLimit: CashWithdrawalLimit, posLimit: PosLimit, vposLimit: VposLimit) {
          self.init(unsafeResultMap: ["__typename": "CardLimits", "cashWithdrawalLimit": cashWithdrawalLimit.resultMap, "posLimit": posLimit.resultMap, "vposLimit": vposLimit.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var cashWithdrawalLimit: CashWithdrawalLimit {
          get {
            return CashWithdrawalLimit(unsafeResultMap: resultMap["cashWithdrawalLimit"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "cashWithdrawalLimit")
          }
        }

        public var posLimit: PosLimit {
          get {
            return PosLimit(unsafeResultMap: resultMap["posLimit"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "posLimit")
          }
        }

        public var vposLimit: VposLimit {
          get {
            return VposLimit(unsafeResultMap: resultMap["vposLimit"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "vposLimit")
          }
        }

        public struct CashWithdrawalLimit: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["CardLimit"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(CardLimitFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(total: Double, remaining: Double, min: Double, max: Double) {
            self.init(unsafeResultMap: ["__typename": "CardLimit", "total": total, "remaining": remaining, "min": min, "max": max])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var cardLimitFragment: CardLimitFragment {
              get {
                return CardLimitFragment(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }

        public struct PosLimit: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["CardLimit"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(CardLimitFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(total: Double, remaining: Double, min: Double, max: Double) {
            self.init(unsafeResultMap: ["__typename": "CardLimit", "total": total, "remaining": remaining, "min": min, "max": max])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var cardLimitFragment: CardLimitFragment {
              get {
                return CardLimitFragment(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }

        public struct VposLimit: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["CardLimit"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(CardLimitFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(total: Double, remaining: Double, min: Double, max: Double) {
            self.init(unsafeResultMap: ["__typename": "CardLimit", "total": total, "remaining": remaining, "min": min, "max": max])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var cardLimitFragment: CardLimitFragment {
              get {
                return CardLimitFragment(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }
      }

      public struct CardError: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["UserTransactionError"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(UserTransactionErrorFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(code: String? = nil, error: String? = nil, message: String? = nil, name: String? = nil, sourceService: String, stack: String? = nil, statusCode: Double? = nil, type: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "UserTransactionError", "code": code, "error": error, "message": message, "name": name, "sourceService": sourceService, "stack": stack, "statusCode": statusCode, "type": type])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var userTransactionErrorFragment: UserTransactionErrorFragment {
            get {
              return UserTransactionErrorFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class ChangeCardLimitMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation changeCardLimit($limits: [ChangeCardLimitInput!]!, $cardToken: String!) {
      changeCardLimit(limits: $limits, cardToken: $cardToken) {
        __typename
        cardLimits {
          __typename
          cashWithdrawalLimit {
            __typename
            ...CardLimitFragment
          }
          posLimit {
            __typename
            ...CardLimitFragment
          }
          vposLimit {
            __typename
            ...CardLimitFragment
          }
        }
      }
    }
    """

  public let operationName: String = "changeCardLimit"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + CardLimitFragment.fragmentDefinition)
    return document
  }

  public var limits: [ChangeCardLimitInput]
  public var cardToken: String

  public init(limits: [ChangeCardLimitInput], cardToken: String) {
    self.limits = limits
    self.cardToken = cardToken
  }

  public var variables: GraphQLMap? {
    return ["limits": limits, "cardToken": cardToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("changeCardLimit", arguments: ["limits": GraphQLVariable("limits"), "cardToken": GraphQLVariable("cardToken")], type: .nonNull(.object(ChangeCardLimit.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(changeCardLimit: ChangeCardLimit) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "changeCardLimit": changeCardLimit.resultMap])
    }

    public var changeCardLimit: ChangeCardLimit {
      get {
        return ChangeCardLimit(unsafeResultMap: resultMap["changeCardLimit"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "changeCardLimit")
      }
    }

    public struct ChangeCardLimit: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["GetCardLimits"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("cardLimits", type: .nonNull(.object(CardLimit.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(cardLimits: CardLimit) {
        self.init(unsafeResultMap: ["__typename": "GetCardLimits", "cardLimits": cardLimits.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var cardLimits: CardLimit {
        get {
          return CardLimit(unsafeResultMap: resultMap["cardLimits"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "cardLimits")
        }
      }

      public struct CardLimit: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["CardLimits"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("cashWithdrawalLimit", type: .nonNull(.object(CashWithdrawalLimit.selections))),
            GraphQLField("posLimit", type: .nonNull(.object(PosLimit.selections))),
            GraphQLField("vposLimit", type: .nonNull(.object(VposLimit.selections))),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(cashWithdrawalLimit: CashWithdrawalLimit, posLimit: PosLimit, vposLimit: VposLimit) {
          self.init(unsafeResultMap: ["__typename": "CardLimits", "cashWithdrawalLimit": cashWithdrawalLimit.resultMap, "posLimit": posLimit.resultMap, "vposLimit": vposLimit.resultMap])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var cashWithdrawalLimit: CashWithdrawalLimit {
          get {
            return CashWithdrawalLimit(unsafeResultMap: resultMap["cashWithdrawalLimit"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "cashWithdrawalLimit")
          }
        }

        public var posLimit: PosLimit {
          get {
            return PosLimit(unsafeResultMap: resultMap["posLimit"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "posLimit")
          }
        }

        public var vposLimit: VposLimit {
          get {
            return VposLimit(unsafeResultMap: resultMap["vposLimit"]! as! ResultMap)
          }
          set {
            resultMap.updateValue(newValue.resultMap, forKey: "vposLimit")
          }
        }

        public struct CashWithdrawalLimit: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["CardLimit"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(CardLimitFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(total: Double, remaining: Double, min: Double, max: Double) {
            self.init(unsafeResultMap: ["__typename": "CardLimit", "total": total, "remaining": remaining, "min": min, "max": max])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var cardLimitFragment: CardLimitFragment {
              get {
                return CardLimitFragment(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }

        public struct PosLimit: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["CardLimit"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(CardLimitFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(total: Double, remaining: Double, min: Double, max: Double) {
            self.init(unsafeResultMap: ["__typename": "CardLimit", "total": total, "remaining": remaining, "min": min, "max": max])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var cardLimitFragment: CardLimitFragment {
              get {
                return CardLimitFragment(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }

        public struct VposLimit: GraphQLSelectionSet {
          public static let possibleTypes: [String] = ["CardLimit"]

          public static var selections: [GraphQLSelection] {
            return [
              GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
              GraphQLFragmentSpread(CardLimitFragment.self),
            ]
          }

          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public init(total: Double, remaining: Double, min: Double, max: Double) {
            self.init(unsafeResultMap: ["__typename": "CardLimit", "total": total, "remaining": remaining, "min": min, "max": max])
          }

          public var __typename: String {
            get {
              return resultMap["__typename"]! as! String
            }
            set {
              resultMap.updateValue(newValue, forKey: "__typename")
            }
          }

          public var fragments: Fragments {
            get {
              return Fragments(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }

          public struct Fragments {
            public private(set) var resultMap: ResultMap

            public init(unsafeResultMap: ResultMap) {
              self.resultMap = unsafeResultMap
            }

            public var cardLimitFragment: CardLimitFragment {
              get {
                return CardLimitFragment(unsafeResultMap: resultMap)
              }
              set {
                resultMap += newValue.resultMap
              }
            }
          }
        }
      }
    }
  }
}

public final class GetCardTransactionStatusQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getCardTransactionStatus($transactionId: String!) {
      getCardTransactionStatus(transactionId: $transactionId) {
        __typename
        result
        error {
          __typename
          ...UserTransactionErrorFragment
        }
      }
    }
    """

  public let operationName: String = "getCardTransactionStatus"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + UserTransactionErrorFragment.fragmentDefinition)
    return document
  }

  public var transactionId: String

  public init(transactionId: String) {
    self.transactionId = transactionId
  }

  public var variables: GraphQLMap? {
    return ["transactionId": transactionId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getCardTransactionStatus", arguments: ["transactionId": GraphQLVariable("transactionId")], type: .nonNull(.object(GetCardTransactionStatus.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getCardTransactionStatus: GetCardTransactionStatus) {
      self.init(unsafeResultMap: ["__typename": "Query", "getCardTransactionStatus": getCardTransactionStatus.resultMap])
    }

    public var getCardTransactionStatus: GetCardTransactionStatus {
      get {
        return GetCardTransactionStatus(unsafeResultMap: resultMap["getCardTransactionStatus"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getCardTransactionStatus")
      }
    }

    public struct GetCardTransactionStatus: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["CardStatusPoll"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("result", type: .nonNull(.scalar(PollingResult.self))),
          GraphQLField("error", type: .list(.nonNull(.object(Error.selections)))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(result: PollingResult, error: [Error]? = nil) {
        self.init(unsafeResultMap: ["__typename": "CardStatusPoll", "result": result, "error": error.flatMap { (value: [Error]) -> [ResultMap] in value.map { (value: Error) -> ResultMap in value.resultMap } }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var result: PollingResult {
        get {
          return resultMap["result"]! as! PollingResult
        }
        set {
          resultMap.updateValue(newValue, forKey: "result")
        }
      }

      public var error: [Error]? {
        get {
          return (resultMap["error"] as? [ResultMap]).flatMap { (value: [ResultMap]) -> [Error] in value.map { (value: ResultMap) -> Error in Error(unsafeResultMap: value) } }
        }
        set {
          resultMap.updateValue(newValue.flatMap { (value: [Error]) -> [ResultMap] in value.map { (value: Error) -> ResultMap in value.resultMap } }, forKey: "error")
        }
      }

      public struct Error: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["UserTransactionError"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(UserTransactionErrorFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(code: String? = nil, error: String? = nil, message: String? = nil, name: String? = nil, sourceService: String, stack: String? = nil, statusCode: Double? = nil, type: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "UserTransactionError", "code": code, "error": error, "message": message, "name": name, "sourceService": sourceService, "stack": stack, "statusCode": statusCode, "type": type])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var userTransactionErrorFragment: UserTransactionErrorFragment {
            get {
              return UserTransactionErrorFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class ReorderCardMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation ReorderCard($cardToken: String!, $encryptedKey: String!, $epin: Epin!) {
      reorderCard(cardToken: $cardToken, encryptedKey: $encryptedKey, epin: $epin) {
        __typename
        transactionId
      }
    }
    """

  public let operationName: String = "ReorderCard"

  public var cardToken: String
  public var encryptedKey: String
  public var epin: Epin

  public init(cardToken: String, encryptedKey: String, epin: Epin) {
    self.cardToken = cardToken
    self.encryptedKey = encryptedKey
    self.epin = epin
  }

  public var variables: GraphQLMap? {
    return ["cardToken": cardToken, "encryptedKey": encryptedKey, "epin": epin]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("reorderCard", arguments: ["cardToken": GraphQLVariable("cardToken"), "encryptedKey": GraphQLVariable("encryptedKey"), "epin": GraphQLVariable("epin")], type: .nonNull(.object(ReorderCard.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(reorderCard: ReorderCard) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "reorderCard": reorderCard.resultMap])
    }

    public var reorderCard: ReorderCard {
      get {
        return ReorderCard(unsafeResultMap: resultMap["reorderCard"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "reorderCard")
      }
    }

    public struct ReorderCard: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["CardStatusChange"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("transactionId", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(transactionId: String) {
        self.init(unsafeResultMap: ["__typename": "CardStatusChange", "transactionId": transactionId])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var transactionId: String {
        get {
          return resultMap["transactionId"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "transactionId")
        }
      }
    }
  }
}

public final class SetCardStatusMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation setCardStatus($cardStatus: CardStatus!, $cardToken: String!) {
      setCardStatus(cardStatus: $cardStatus, cardToken: $cardToken) {
        __typename
        transactionId
      }
    }
    """

  public let operationName: String = "setCardStatus"

  public var cardStatus: CardStatus
  public var cardToken: String

  public init(cardStatus: CardStatus, cardToken: String) {
    self.cardStatus = cardStatus
    self.cardToken = cardToken
  }

  public var variables: GraphQLMap? {
    return ["cardStatus": cardStatus, "cardToken": cardToken]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("setCardStatus", arguments: ["cardStatus": GraphQLVariable("cardStatus"), "cardToken": GraphQLVariable("cardToken")], type: .nonNull(.object(SetCardStatus.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(setCardStatus: SetCardStatus) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "setCardStatus": setCardStatus.resultMap])
    }

    public var setCardStatus: SetCardStatus {
      get {
        return SetCardStatus(unsafeResultMap: resultMap["setCardStatus"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "setCardStatus")
      }
    }

    public struct SetCardStatus: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["CardStatusChange"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("transactionId", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(transactionId: String) {
        self.init(unsafeResultMap: ["__typename": "CardStatusChange", "transactionId": transactionId])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var transactionId: String {
        get {
          return resultMap["transactionId"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "transactionId")
        }
      }
    }
  }
}

public final class DepositMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation deposit($accountId: String!, $amount: Float!) {
      deposit(accountId: $accountId, amount: $amount) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "deposit"

  public var accountId: String
  public var amount: Double

  public init(accountId: String, amount: Double) {
    self.accountId = accountId
    self.amount = amount
  }

  public var variables: GraphQLMap? {
    return ["accountId": accountId, "amount": amount]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deposit", arguments: ["accountId": GraphQLVariable("accountId"), "amount": GraphQLVariable("amount")], type: .nonNull(.object(Deposit.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deposit: Deposit) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deposit": deposit.resultMap])
    }

    /// We will delete this endpoint before MVP(friends and family).
    public var deposit: Deposit {
      get {
        return Deposit(unsafeResultMap: resultMap["deposit"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "deposit")
      }
    }

    public struct Deposit: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["StatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(Status.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: Status) {
        self.init(unsafeResultMap: ["__typename": "StatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: Status {
        get {
          return resultMap["status"]! as! Status
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class GetKycEnvironmentQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getKycEnvironment {
      getKycTokenV2 {
        __typename
        sdkToken
        sdkUrl
      }
    }
    """

  public let operationName: String = "getKycEnvironment"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getKycTokenV2", type: .nonNull(.object(GetKycTokenV2.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getKycTokenV2: GetKycTokenV2) {
      self.init(unsafeResultMap: ["__typename": "Query", "getKycTokenV2": getKycTokenV2.resultMap])
    }

    public var getKycTokenV2: GetKycTokenV2 {
      get {
        return GetKycTokenV2(unsafeResultMap: resultMap["getKycTokenV2"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getKycTokenV2")
      }
    }

    public struct GetKycTokenV2: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["KycTokenV2Response"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("sdkToken", type: .nonNull(.scalar(String.self))),
          GraphQLField("sdkUrl", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sdkToken: String, sdkUrl: String) {
        self.init(unsafeResultMap: ["__typename": "KycTokenV2Response", "sdkToken": sdkToken, "sdkUrl": sdkUrl])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var sdkToken: String {
        get {
          return resultMap["sdkToken"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "sdkToken")
        }
      }

      public var sdkUrl: String {
        get {
          return resultMap["sdkUrl"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "sdkUrl")
        }
      }
    }
  }
}

public final class GetKycTokenQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getKycToken {
      getKycToken {
        __typename
        sdkToken
      }
    }
    """

  public let operationName: String = "getKycToken"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getKycToken", type: .nonNull(.object(GetKycToken.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getKycToken: GetKycToken) {
      self.init(unsafeResultMap: ["__typename": "Query", "getKycToken": getKycToken.resultMap])
    }

    public var getKycToken: GetKycToken {
      get {
        return GetKycToken(unsafeResultMap: resultMap["getKycToken"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getKycToken")
      }
    }

    public struct GetKycToken: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["KycTokenResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("sdkToken", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(sdkToken: String) {
        self.init(unsafeResultMap: ["__typename": "KycTokenResponse", "sdkToken": sdkToken])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var sdkToken: String {
        get {
          return resultMap["sdkToken"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "sdkToken")
        }
      }
    }
  }
}

public final class LoginQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query login($otp: String!, $phoneNumber: String!, $deviceId: String!) {
      login(otp: $otp, phoneNumber: $phoneNumber, deviceId: $deviceId) {
        __typename
        ...TokenFragment
      }
    }
    """

  public let operationName: String = "login"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + TokenFragment.fragmentDefinition)
    return document
  }

  public var otp: String
  public var phoneNumber: String
  public var deviceId: String

  public init(otp: String, phoneNumber: String, deviceId: String) {
    self.otp = otp
    self.phoneNumber = phoneNumber
    self.deviceId = deviceId
  }

  public var variables: GraphQLMap? {
    return ["otp": otp, "phoneNumber": phoneNumber, "deviceId": deviceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("login", arguments: ["otp": GraphQLVariable("otp"), "phoneNumber": GraphQLVariable("phoneNumber"), "deviceId": GraphQLVariable("deviceId")], type: .nonNull(.object(Login.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(login: Login) {
      self.init(unsafeResultMap: ["__typename": "Query", "login": login.resultMap])
    }

    public var login: Login {
      get {
        return Login(unsafeResultMap: resultMap["login"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "login")
      }
    }

    public struct Login: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["LoginResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(TokenFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(accessToken: String, refreshToken: String) {
        self.init(unsafeResultMap: ["__typename": "LoginResponse", "accessToken": accessToken, "refreshToken": refreshToken])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var tokenFragment: TokenFragment {
          get {
            return TokenFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class LoginV2Query: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query loginV2($otp: String!, $phoneNumber: String!, $deviceId: String!) {
      loginV2(otp: $otp, phoneNumber: $phoneNumber, deviceId: $deviceId) {
        __typename
        ...TokenFragment
      }
    }
    """

  public let operationName: String = "loginV2"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + TokenFragment.fragmentDefinition)
    return document
  }

  public var otp: String
  public var phoneNumber: String
  public var deviceId: String

  public init(otp: String, phoneNumber: String, deviceId: String) {
    self.otp = otp
    self.phoneNumber = phoneNumber
    self.deviceId = deviceId
  }

  public var variables: GraphQLMap? {
    return ["otp": otp, "phoneNumber": phoneNumber, "deviceId": deviceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("loginV2", arguments: ["otp": GraphQLVariable("otp"), "phoneNumber": GraphQLVariable("phoneNumber"), "deviceId": GraphQLVariable("deviceId")], type: .nonNull(.object(LoginV2.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(loginV2: LoginV2) {
      self.init(unsafeResultMap: ["__typename": "Query", "loginV2": loginV2.resultMap])
    }

    public var loginV2: LoginV2 {
      get {
        return LoginV2(unsafeResultMap: resultMap["loginV2"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "loginV2")
      }
    }

    public struct LoginV2: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["LoginResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(TokenFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(accessToken: String, refreshToken: String) {
        self.init(unsafeResultMap: ["__typename": "LoginResponse", "accessToken": accessToken, "refreshToken": refreshToken])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var tokenFragment: TokenFragment {
          get {
            return TokenFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class RefreshTokensQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query refreshTokens {
      getTokens {
        __typename
        ...TokenFragment
      }
    }
    """

  public let operationName: String = "refreshTokens"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + TokenFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getTokens", type: .nonNull(.object(GetToken.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getTokens: GetToken) {
      self.init(unsafeResultMap: ["__typename": "Query", "getTokens": getTokens.resultMap])
    }

    public var getTokens: GetToken {
      get {
        return GetToken(unsafeResultMap: resultMap["getTokens"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getTokens")
      }
    }

    public struct GetToken: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["LoginResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(TokenFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(accessToken: String, refreshToken: String) {
        self.init(unsafeResultMap: ["__typename": "LoginResponse", "accessToken": accessToken, "refreshToken": refreshToken])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var tokenFragment: TokenFragment {
          get {
            return TokenFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class RenewSessionQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query renewSession($otp: String!, $phoneNumber: String!, $deviceId: String!) {
      renewSession(otp: $otp, phoneNumber: $phoneNumber, deviceId: $deviceId) {
        __typename
        ...TokenFragment
      }
    }
    """

  public let operationName: String = "renewSession"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + TokenFragment.fragmentDefinition)
    return document
  }

  public var otp: String
  public var phoneNumber: String
  public var deviceId: String

  public init(otp: String, phoneNumber: String, deviceId: String) {
    self.otp = otp
    self.phoneNumber = phoneNumber
    self.deviceId = deviceId
  }

  public var variables: GraphQLMap? {
    return ["otp": otp, "phoneNumber": phoneNumber, "deviceId": deviceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("renewSession", arguments: ["otp": GraphQLVariable("otp"), "phoneNumber": GraphQLVariable("phoneNumber"), "deviceId": GraphQLVariable("deviceId")], type: .nonNull(.object(RenewSession.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(renewSession: RenewSession) {
      self.init(unsafeResultMap: ["__typename": "Query", "renewSession": renewSession.resultMap])
    }

    public var renewSession: RenewSession {
      get {
        return RenewSession(unsafeResultMap: resultMap["renewSession"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "renewSession")
      }
    }

    public struct RenewSession: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["LoginResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(TokenFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(accessToken: String, refreshToken: String) {
        self.init(unsafeResultMap: ["__typename": "LoginResponse", "accessToken": accessToken, "refreshToken": refreshToken])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var tokenFragment: TokenFragment {
          get {
            return TokenFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class ResetDeviceMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation resetDevice($deviceId: String!) {
      resetDevice(deviceId: $deviceId) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "resetDevice"

  public var deviceId: String

  public init(deviceId: String) {
    self.deviceId = deviceId
  }

  public var variables: GraphQLMap? {
    return ["deviceId": deviceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("resetDevice", arguments: ["deviceId": GraphQLVariable("deviceId")], type: .nonNull(.object(ResetDevice.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(resetDevice: ResetDevice) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "resetDevice": resetDevice.resultMap])
    }

    /// Device activation reset
    public var resetDevice: ResetDevice {
      get {
        return ResetDevice(unsafeResultMap: resultMap["resetDevice"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "resetDevice")
      }
    }

    public struct ResetDevice: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["StatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(Status.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: Status) {
        self.init(unsafeResultMap: ["__typename": "StatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: Status {
        get {
          return resultMap["status"]! as! Status
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class SetPushTokenMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation setPushToken($token: String) {
      setPushToken(pushToken: $token) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "setPushToken"

  public var token: String?

  public init(token: String? = nil) {
    self.token = token
  }

  public var variables: GraphQLMap? {
    return ["token": token]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("setPushToken", arguments: ["pushToken": GraphQLVariable("token")], type: .nonNull(.object(SetPushToken.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(setPushToken: SetPushToken) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "setPushToken": setPushToken.resultMap])
    }

    public var setPushToken: SetPushToken {
      get {
        return SetPushToken(unsafeResultMap: resultMap["setPushToken"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "setPushToken")
      }
    }

    public struct SetPushToken: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["StatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(Status.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: Status) {
        self.init(unsafeResultMap: ["__typename": "StatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: Status {
        get {
          return resultMap["status"]! as! Status
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class ChangeEmailMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation changeEmail($email: String!) {
      changeEmail(email: $email) {
        __typename
        nextRequestInterval
      }
    }
    """

  public let operationName: String = "changeEmail"

  public var email: String

  public init(email: String) {
    self.email = email
  }

  public var variables: GraphQLMap? {
    return ["email": email]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("changeEmail", arguments: ["email": GraphQLVariable("email")], type: .nonNull(.object(ChangeEmail.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(changeEmail: ChangeEmail) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "changeEmail": changeEmail.resultMap])
    }

    public var changeEmail: ChangeEmail {
      get {
        return ChangeEmail(unsafeResultMap: resultMap["changeEmail"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "changeEmail")
      }
    }

    public struct ChangeEmail: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ChangeEmailResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextRequestInterval", type: .nonNull(.scalar(Double.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(nextRequestInterval: Double) {
        self.init(unsafeResultMap: ["__typename": "ChangeEmailResponse", "nextRequestInterval": nextRequestInterval])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var nextRequestInterval: Double {
        get {
          return resultMap["nextRequestInterval"]! as! Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "nextRequestInterval")
        }
      }
    }
  }
}

public final class GetAccountInfoQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getAccountInfo {
      getApplication {
        __typename
        accountInfo {
          __typename
          ...AccountInfoFragment
        }
      }
    }
    """

  public let operationName: String = "getAccountInfo"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + AccountInfoFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getApplication", type: .nonNull(.object(GetApplication.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getApplication: GetApplication) {
      self.init(unsafeResultMap: ["__typename": "Query", "getApplication": getApplication.resultMap])
    }

    /// Get application data
    public var getApplication: GetApplication {
      get {
        return GetApplication(unsafeResultMap: resultMap["getApplication"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getApplication")
      }
    }

    public struct GetApplication: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Application"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("accountInfo", type: .object(AccountInfo.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(accountInfo: AccountInfo? = nil) {
        self.init(unsafeResultMap: ["__typename": "Application", "accountInfo": accountInfo.flatMap { (value: AccountInfo) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var accountInfo: AccountInfo? {
        get {
          return (resultMap["accountInfo"] as? ResultMap).flatMap { AccountInfo(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "accountInfo")
        }
      }

      public struct AccountInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["AccountInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(AccountInfoFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(polling: Double, successful: Bool, accountId: String? = nil, error: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "AccountInfo", "polling": polling, "successful": successful, "accountId": accountId, "error": error])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var accountInfoFragment: AccountInfoFragment {
            get {
              return AccountInfoFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class GetApplicationQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getApplication {
      getApplication {
        __typename
        nextStep
        selectedProduct
        individual {
          __typename
          ...IndividualFragment
        }
        consentInfo {
          __typename
          ...ConsentFragment
        }
        kycSurvey {
          __typename
          ...KycSurveyFragment
        }
        contractInfo {
          __typename
          ...ContractInfoFragment
        }
        signInfo {
          __typename
          signedAt
        }
        dmStatement {
          __typename
          push
          email
          robinson
        }
      }
    }
    """

  public let operationName: String = "getApplication"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + IndividualFragment.fragmentDefinition)
    document.append("\n" + NameFragment.fragmentDefinition)
    document.append("\n" + AddressFragment.fragmentDefinition)
    document.append("\n" + DocumentFragment.fragmentDefinition)
    document.append("\n" + EmailFragment.fragmentDefinition)
    document.append("\n" + PhoneFragment.fragmentDefinition)
    document.append("\n" + ConsentFragment.fragmentDefinition)
    document.append("\n" + TaxationFragment.fragmentDefinition)
    document.append("\n" + KycSurveyFragment.fragmentDefinition)
    document.append("\n" + IncomingSourcesFragment.fragmentDefinition)
    document.append("\n" + PlanFragment.fragmentDefinition)
    document.append("\n" + ContractInfoFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getApplication", type: .nonNull(.object(GetApplication.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getApplication: GetApplication) {
      self.init(unsafeResultMap: ["__typename": "Query", "getApplication": getApplication.resultMap])
    }

    /// Get application data
    public var getApplication: GetApplication {
      get {
        return GetApplication(unsafeResultMap: resultMap["getApplication"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getApplication")
      }
    }

    public struct GetApplication: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Application"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextStep", type: .nonNull(.scalar(OnboardingNextStepType.self))),
          GraphQLField("selectedProduct", type: .scalar(String.self)),
          GraphQLField("individual", type: .object(Individual.selections)),
          GraphQLField("consentInfo", type: .object(ConsentInfo.selections)),
          GraphQLField("kycSurvey", type: .object(KycSurvey.selections)),
          GraphQLField("contractInfo", type: .object(ContractInfo.selections)),
          GraphQLField("signInfo", type: .object(SignInfo.selections)),
          GraphQLField("dmStatement", type: .object(DmStatement.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(nextStep: OnboardingNextStepType, selectedProduct: String? = nil, individual: Individual? = nil, consentInfo: ConsentInfo? = nil, kycSurvey: KycSurvey? = nil, contractInfo: ContractInfo? = nil, signInfo: SignInfo? = nil, dmStatement: DmStatement? = nil) {
        self.init(unsafeResultMap: ["__typename": "Application", "nextStep": nextStep, "selectedProduct": selectedProduct, "individual": individual.flatMap { (value: Individual) -> ResultMap in value.resultMap }, "consentInfo": consentInfo.flatMap { (value: ConsentInfo) -> ResultMap in value.resultMap }, "kycSurvey": kycSurvey.flatMap { (value: KycSurvey) -> ResultMap in value.resultMap }, "contractInfo": contractInfo.flatMap { (value: ContractInfo) -> ResultMap in value.resultMap }, "signInfo": signInfo.flatMap { (value: SignInfo) -> ResultMap in value.resultMap }, "dmStatement": dmStatement.flatMap { (value: DmStatement) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var nextStep: OnboardingNextStepType {
        get {
          return resultMap["nextStep"]! as! OnboardingNextStepType
        }
        set {
          resultMap.updateValue(newValue, forKey: "nextStep")
        }
      }

      public var selectedProduct: String? {
        get {
          return resultMap["selectedProduct"] as? String
        }
        set {
          resultMap.updateValue(newValue, forKey: "selectedProduct")
        }
      }

      public var individual: Individual? {
        get {
          return (resultMap["individual"] as? ResultMap).flatMap { Individual(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "individual")
        }
      }

      public var consentInfo: ConsentInfo? {
        get {
          return (resultMap["consentInfo"] as? ResultMap).flatMap { ConsentInfo(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "consentInfo")
        }
      }

      public var kycSurvey: KycSurvey? {
        get {
          return (resultMap["kycSurvey"] as? ResultMap).flatMap { KycSurvey(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "kycSurvey")
        }
      }

      public var contractInfo: ContractInfo? {
        get {
          return (resultMap["contractInfo"] as? ResultMap).flatMap { ContractInfo(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "contractInfo")
        }
      }

      public var signInfo: SignInfo? {
        get {
          return (resultMap["signInfo"] as? ResultMap).flatMap { SignInfo(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "signInfo")
        }
      }

      public var dmStatement: DmStatement? {
        get {
          return (resultMap["dmStatement"] as? ResultMap).flatMap { DmStatement(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "dmStatement")
        }
      }

      public struct Individual: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Individual"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(IndividualFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var individualFragment: IndividualFragment {
            get {
              return IndividualFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }

      public struct ConsentInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ConsentInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(ConsentFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var consentFragment: ConsentFragment {
            get {
              return ConsentFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }

      public struct KycSurvey: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["KycSurvey"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(KycSurveyFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var kycSurveyFragment: KycSurveyFragment {
            get {
              return KycSurveyFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }

      public struct ContractInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ContractInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(ContractInfoFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(polling: Double, successful: Bool, contractId: String? = nil, error: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "ContractInfo", "polling": polling, "successful": successful, "contractId": contractId, "error": error])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var contractInfoFragment: ContractInfoFragment {
            get {
              return ContractInfoFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }

      public struct SignInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["SignInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("signedAt", type: .scalar(String.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(signedAt: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "SignInfo", "signedAt": signedAt])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        /// UTC DateTime example: 2021-12-01T10:37:43.937Z
        public var signedAt: String? {
          get {
            return resultMap["signedAt"] as? String
          }
          set {
            resultMap.updateValue(newValue, forKey: "signedAt")
          }
        }
      }

      public struct DmStatement: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["DmStatement"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("push", type: .scalar(Bool.self)),
            GraphQLField("email", type: .scalar(Bool.self)),
            GraphQLField("robinson", type: .scalar(Bool.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(push: Bool? = nil, email: Bool? = nil, robinson: Bool? = nil) {
          self.init(unsafeResultMap: ["__typename": "DmStatement", "push": push, "email": email, "robinson": robinson])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var push: Bool? {
          get {
            return resultMap["push"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "push")
          }
        }

        public var email: Bool? {
          get {
            return resultMap["email"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "email")
          }
        }

        public var robinson: Bool? {
          get {
            return resultMap["robinson"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "robinson")
          }
        }
      }
    }
  }
}

public final class GetContractQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getContract($contractId: String!) {
      getContract(contractId: $contractId)
    }
    """

  public let operationName: String = "getContract"

  public var contractId: String

  public init(contractId: String) {
    self.contractId = contractId
  }

  public var variables: GraphQLMap? {
    return ["contractId": contractId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getContract", arguments: ["contractId": GraphQLVariable("contractId")], type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getContract: String) {
      self.init(unsafeResultMap: ["__typename": "Query", "getContract": getContract])
    }

    public var getContract: String {
      get {
        return resultMap["getContract"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "getContract")
      }
    }
  }
}

public final class GetContractInfoQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getContractInfo {
      getApplication {
        __typename
        contractInfo {
          __typename
          ...ContractInfoFragment
        }
      }
    }
    """

  public let operationName: String = "getContractInfo"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ContractInfoFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getApplication", type: .nonNull(.object(GetApplication.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getApplication: GetApplication) {
      self.init(unsafeResultMap: ["__typename": "Query", "getApplication": getApplication.resultMap])
    }

    /// Get application data
    public var getApplication: GetApplication {
      get {
        return GetApplication(unsafeResultMap: resultMap["getApplication"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getApplication")
      }
    }

    public struct GetApplication: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Application"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("contractInfo", type: .object(ContractInfo.selections)),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(contractInfo: ContractInfo? = nil) {
        self.init(unsafeResultMap: ["__typename": "Application", "contractInfo": contractInfo.flatMap { (value: ContractInfo) -> ResultMap in value.resultMap }])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var contractInfo: ContractInfo? {
        get {
          return (resultMap["contractInfo"] as? ResultMap).flatMap { ContractInfo(unsafeResultMap: $0) }
        }
        set {
          resultMap.updateValue(newValue?.resultMap, forKey: "contractInfo")
        }
      }

      public struct ContractInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["ContractInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(ContractInfoFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(polling: Double, successful: Bool, contractId: String? = nil, error: String? = nil) {
          self.init(unsafeResultMap: ["__typename": "ContractInfo", "polling": polling, "successful": successful, "contractId": contractId, "error": error])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var contractInfoFragment: ContractInfoFragment {
            get {
              return ContractInfoFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class ResendVerificationEmailQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query resendVerificationEmail {
      getVerificationEmail {
        __typename
        nextRequestInterval
      }
    }
    """

  public let operationName: String = "resendVerificationEmail"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getVerificationEmail", type: .nonNull(.object(GetVerificationEmail.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getVerificationEmail: GetVerificationEmail) {
      self.init(unsafeResultMap: ["__typename": "Query", "getVerificationEmail": getVerificationEmail.resultMap])
    }

    public var getVerificationEmail: GetVerificationEmail {
      get {
        return GetVerificationEmail(unsafeResultMap: resultMap["getVerificationEmail"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getVerificationEmail")
      }
    }

    public struct GetVerificationEmail: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["GetVerificationEmailResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("nextRequestInterval", type: .nonNull(.scalar(Double.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(nextRequestInterval: Double) {
        self.init(unsafeResultMap: ["__typename": "GetVerificationEmailResponse", "nextRequestInterval": nextRequestInterval])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var nextRequestInterval: Double {
        get {
          return resultMap["nextRequestInterval"]! as! Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "nextRequestInterval")
        }
      }
    }
  }
}

public final class UpdateApplicationMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation updateApplication($application: ApplicationInput!) {
      updateApplication(application: $application) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "updateApplication"

  public var application: ApplicationInput

  public init(application: ApplicationInput) {
    self.application = application
  }

  public var variables: GraphQLMap? {
    return ["application": application]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("updateApplication", arguments: ["application": GraphQLVariable("application")], type: .nonNull(.object(UpdateApplication.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(updateApplication: UpdateApplication) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "updateApplication": updateApplication.resultMap])
    }

    /// Update application data
    public var updateApplication: UpdateApplication {
      get {
        return UpdateApplication(unsafeResultMap: resultMap["updateApplication"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "updateApplication")
      }
    }

    public struct UpdateApplication: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["StatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(Status.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: Status) {
        self.init(unsafeResultMap: ["__typename": "StatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: Status {
        get {
          return resultMap["status"]! as! Status
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class GetDailyLimitRemainingQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getDailyLimitRemaining($iban: String!) {
      getDailyLimitRemaining(iban: $iban) {
        __typename
        ...MoneyFragment
      }
    }
    """

  public let operationName: String = "getDailyLimitRemaining"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MoneyFragment.fragmentDefinition)
    return document
  }

  public var iban: String

  public init(iban: String) {
    self.iban = iban
  }

  public var variables: GraphQLMap? {
    return ["iban": iban]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getDailyLimitRemaining", arguments: ["iban": GraphQLVariable("iban")], type: .nonNull(.object(GetDailyLimitRemaining.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getDailyLimitRemaining: GetDailyLimitRemaining) {
      self.init(unsafeResultMap: ["__typename": "Query", "getDailyLimitRemaining": getDailyLimitRemaining.resultMap])
    }

    public var getDailyLimitRemaining: GetDailyLimitRemaining {
      get {
        return GetDailyLimitRemaining(unsafeResultMap: resultMap["getDailyLimitRemaining"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getDailyLimitRemaining")
      }
    }

    public struct GetDailyLimitRemaining: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Money"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MoneyFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(amount: String, currencyCode: String) {
        self.init(unsafeResultMap: ["__typename": "Money", "amount": amount, "currencyCode": currencyCode])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var moneyFragment: MoneyFragment {
          get {
            return MoneyFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class GetPaymentTransactionsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getPaymentTransactions($transactionId: String!) {
      getPaymentTransaction(transactionId: $transactionId) {
        __typename
        ...PaymentTransactionFragment
      }
    }
    """

  public let operationName: String = "getPaymentTransactions"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + PaymentTransactionFragment.fragmentDefinition)
    document.append("\n" + MoneyFragment.fragmentDefinition)
    document.append("\n" + ParticipantFragment.fragmentDefinition)
    return document
  }

  public var transactionId: String

  public init(transactionId: String) {
    self.transactionId = transactionId
  }

  public var variables: GraphQLMap? {
    return ["transactionId": transactionId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getPaymentTransaction", arguments: ["transactionId": GraphQLVariable("transactionId")], type: .nonNull(.object(GetPaymentTransaction.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getPaymentTransaction: GetPaymentTransaction) {
      self.init(unsafeResultMap: ["__typename": "Query", "getPaymentTransaction": getPaymentTransaction.resultMap])
    }

    public var getPaymentTransaction: GetPaymentTransaction {
      get {
        return GetPaymentTransaction(unsafeResultMap: resultMap["getPaymentTransaction"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getPaymentTransaction")
      }
    }

    public struct GetPaymentTransaction: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PaymentTransaction", "CardTransaction"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(PaymentTransactionFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public static func makeCardTransaction() -> GetPaymentTransaction {
        return GetPaymentTransaction(unsafeResultMap: ["__typename": "CardTransaction"])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var paymentTransactionFragment: PaymentTransactionFragment? {
          get {
            if !PaymentTransactionFragment.possibleTypes.contains(resultMap["__typename"]! as! String) { return nil }
            return PaymentTransactionFragment(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class GetTransactionFeeQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getTransactionFee($input: TransactionFeeInput!) {
      getTransactionFee(input: $input) {
        __typename
        ...MoneyFragment
      }
    }
    """

  public let operationName: String = "getTransactionFee"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + MoneyFragment.fragmentDefinition)
    return document
  }

  public var input: TransactionFeeInput

  public init(input: TransactionFeeInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getTransactionFee", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(GetTransactionFee.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getTransactionFee: GetTransactionFee) {
      self.init(unsafeResultMap: ["__typename": "Query", "getTransactionFee": getTransactionFee.resultMap])
    }

    public var getTransactionFee: GetTransactionFee {
      get {
        return GetTransactionFee(unsafeResultMap: resultMap["getTransactionFee"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getTransactionFee")
      }
    }

    public struct GetTransactionFee: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Money"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(MoneyFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(amount: String, currencyCode: String) {
        self.init(unsafeResultMap: ["__typename": "Money", "amount": amount, "currencyCode": currencyCode])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var moneyFragment: MoneyFragment {
          get {
            return MoneyFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class InitiateNewTransferMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation initiateNewTransfer($input: InitiateNewTransferInput!) {
      initiateNewTransfer(input: $input) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "initiateNewTransfer"

  public var input: InitiateNewTransferInput

  public init(input: InitiateNewTransferInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("initiateNewTransfer", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(InitiateNewTransfer.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(initiateNewTransfer: InitiateNewTransfer) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "initiateNewTransfer": initiateNewTransfer.resultMap])
    }

    public var initiateNewTransfer: InitiateNewTransfer {
      get {
        return InitiateNewTransfer(unsafeResultMap: resultMap["initiateNewTransfer"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "initiateNewTransfer")
      }
    }

    public struct InitiateNewTransfer: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["InitiateNewTransferResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String) {
        self.init(unsafeResultMap: ["__typename": "InitiateNewTransferResponse", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class InitiateNewTransferV2Mutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation initiateNewTransferV2($input: InitiateNewTransferInput!) {
      initiateNewTransferV2(input: $input) {
        __typename
        id
      }
    }
    """

  public let operationName: String = "initiateNewTransferV2"

  public var input: InitiateNewTransferInput

  public init(input: InitiateNewTransferInput) {
    self.input = input
  }

  public var variables: GraphQLMap? {
    return ["input": input]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("initiateNewTransferV2", arguments: ["input": GraphQLVariable("input")], type: .nonNull(.object(InitiateNewTransferV2.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(initiateNewTransferV2: InitiateNewTransferV2) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "initiateNewTransferV2": initiateNewTransferV2.resultMap])
    }

    public var initiateNewTransferV2: InitiateNewTransferV2 {
      get {
        return InitiateNewTransferV2(unsafeResultMap: resultMap["initiateNewTransferV2"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "initiateNewTransferV2")
      }
    }

    public struct InitiateNewTransferV2: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["InitiateNewTransferResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("id", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String) {
        self.init(unsafeResultMap: ["__typename": "InitiateNewTransferResponse", "id": id])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var id: String {
        get {
          return resultMap["id"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "id")
        }
      }
    }
  }
}

public final class ListPaymentTransactionsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query listPaymentTransactions($accountId: String!) {
      listPaymentTransactions(accountId: $accountId) {
        __typename
        ...PaymentTransactionFragment
        ...CardTransactionFragment
      }
    }
    """

  public let operationName: String = "listPaymentTransactions"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + PaymentTransactionFragment.fragmentDefinition)
    document.append("\n" + MoneyFragment.fragmentDefinition)
    document.append("\n" + ParticipantFragment.fragmentDefinition)
    document.append("\n" + CardTransactionFragment.fragmentDefinition)
    return document
  }

  public var accountId: String

  public init(accountId: String) {
    self.accountId = accountId
  }

  public var variables: GraphQLMap? {
    return ["accountId": accountId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("listPaymentTransactions", arguments: ["accountId": GraphQLVariable("accountId")], type: .nonNull(.list(.nonNull(.object(ListPaymentTransaction.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(listPaymentTransactions: [ListPaymentTransaction]) {
      self.init(unsafeResultMap: ["__typename": "Query", "listPaymentTransactions": listPaymentTransactions.map { (value: ListPaymentTransaction) -> ResultMap in value.resultMap }])
    }

    public var listPaymentTransactions: [ListPaymentTransaction] {
      get {
        return (resultMap["listPaymentTransactions"] as! [ResultMap]).map { (value: ResultMap) -> ListPaymentTransaction in ListPaymentTransaction(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: ListPaymentTransaction) -> ResultMap in value.resultMap }, forKey: "listPaymentTransactions")
      }
    }

    public struct ListPaymentTransaction: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PaymentTransaction", "CardTransaction"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(PaymentTransactionFragment.self),
          GraphQLFragmentSpread(CardTransactionFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var paymentTransactionFragment: PaymentTransactionFragment? {
          get {
            if !PaymentTransactionFragment.possibleTypes.contains(resultMap["__typename"]! as! String) { return nil }
            return PaymentTransactionFragment(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap += newValue.resultMap
          }
        }

        public var cardTransactionFragment: CardTransactionFragment? {
          get {
            if !CardTransactionFragment.possibleTypes.contains(resultMap["__typename"]! as! String) { return nil }
            return CardTransactionFragment(unsafeResultMap: resultMap)
          }
          set {
            guard let newValue = newValue else { return }
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class ChangePinQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query changePin($otp: String!) {
      changePin(otp: $otp) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "changePin"

  public var otp: String

  public init(otp: String) {
    self.otp = otp
  }

  public var variables: GraphQLMap? {
    return ["otp": otp]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("changePin", arguments: ["otp": GraphQLVariable("otp")], type: .nonNull(.object(ChangePin.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(changePin: ChangePin) {
      self.init(unsafeResultMap: ["__typename": "Query", "changePin": changePin.resultMap])
    }

    public var changePin: ChangePin {
      get {
        return ChangePin(unsafeResultMap: resultMap["changePin"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "changePin")
      }
    }

    public struct ChangePin: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["StatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(Status.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: Status) {
        self.init(unsafeResultMap: ["__typename": "StatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: Status {
        get {
          return resultMap["status"]! as! Status
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class ChangePinV2Query: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query changePinV2($otp: String!) {
      changePinV2(otp: $otp) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "changePinV2"

  public var otp: String

  public init(otp: String) {
    self.otp = otp
  }

  public var variables: GraphQLMap? {
    return ["otp": otp]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("changePinV2", arguments: ["otp": GraphQLVariable("otp")], type: .nonNull(.object(ChangePinV2.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(changePinV2: ChangePinV2) {
      self.init(unsafeResultMap: ["__typename": "Query", "changePinV2": changePinV2.resultMap])
    }

    public var changePinV2: ChangePinV2 {
      get {
        return ChangePinV2(unsafeResultMap: resultMap["changePinV2"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "changePinV2")
      }
    }

    public struct ChangePinV2: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["StatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(Status.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: Status) {
        self.init(unsafeResultMap: ["__typename": "StatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: Status {
        get {
          return resultMap["status"]! as! Status
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class GetDocumentQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getDocument($type: PdfDocumentType!, $id: String!) {
      getPdfDocument(type: $type, id: $id)
    }
    """

  public let operationName: String = "getDocument"

  public var type: PdfDocumentType
  public var id: String

  public init(type: PdfDocumentType, id: String) {
    self.type = type
    self.id = id
  }

  public var variables: GraphQLMap? {
    return ["type": type, "id": id]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getPdfDocument", arguments: ["type": GraphQLVariable("type"), "id": GraphQLVariable("id")], type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getPdfDocument: String) {
      self.init(unsafeResultMap: ["__typename": "Query", "getPdfDocument": getPdfDocument])
    }

    /// PDF file in base64 encode
    public var getPdfDocument: String {
      get {
        return resultMap["getPdfDocument"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "getPdfDocument")
      }
    }
  }
}

public final class GetEmailVerifiedQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getEmailVerified {
      getIndividual {
        __typename
        mainEmail {
          __typename
          verified
        }
      }
    }
    """

  public let operationName: String = "getEmailVerified"

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getIndividual", type: .nonNull(.object(GetIndividual.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getIndividual: GetIndividual) {
      self.init(unsafeResultMap: ["__typename": "Query", "getIndividual": getIndividual.resultMap])
    }

    public var getIndividual: GetIndividual {
      get {
        return GetIndividual(unsafeResultMap: resultMap["getIndividual"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getIndividual")
      }
    }

    public struct GetIndividual: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Individual"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("mainEmail", type: .nonNull(.object(MainEmail.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(mainEmail: MainEmail) {
        self.init(unsafeResultMap: ["__typename": "Individual", "mainEmail": mainEmail.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var mainEmail: MainEmail {
        get {
          return MainEmail(unsafeResultMap: resultMap["mainEmail"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "mainEmail")
        }
      }

      public struct MainEmail: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["Email"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLField("verified", type: .scalar(Bool.self)),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(verified: Bool? = nil) {
          self.init(unsafeResultMap: ["__typename": "Email", "verified": verified])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var verified: Bool? {
          get {
            return resultMap["verified"] as? Bool
          }
          set {
            resultMap.updateValue(newValue, forKey: "verified")
          }
        }
      }
    }
  }
}

public final class GetIndividualQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getIndividual {
      getIndividual {
        __typename
        ...IndividualFragment
      }
    }
    """

  public let operationName: String = "getIndividual"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + IndividualFragment.fragmentDefinition)
    document.append("\n" + NameFragment.fragmentDefinition)
    document.append("\n" + AddressFragment.fragmentDefinition)
    document.append("\n" + DocumentFragment.fragmentDefinition)
    document.append("\n" + EmailFragment.fragmentDefinition)
    document.append("\n" + PhoneFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getIndividual", type: .nonNull(.object(GetIndividual.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getIndividual: GetIndividual) {
      self.init(unsafeResultMap: ["__typename": "Query", "getIndividual": getIndividual.resultMap])
    }

    public var getIndividual: GetIndividual {
      get {
        return GetIndividual(unsafeResultMap: resultMap["getIndividual"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getIndividual")
      }
    }

    public struct GetIndividual: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Individual"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(IndividualFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var individualFragment: IndividualFragment {
          get {
            return IndividualFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class ListContractsQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query listContracts {
      listContracts {
        __typename
        ...UserContractFragment
      }
    }
    """

  public let operationName: String = "listContracts"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + UserContractFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("listContracts", type: .nonNull(.list(.nonNull(.object(ListContract.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(listContracts: [ListContract]) {
      self.init(unsafeResultMap: ["__typename": "Query", "listContracts": listContracts.map { (value: ListContract) -> ResultMap in value.resultMap }])
    }

    public var listContracts: [ListContract] {
      get {
        return (resultMap["listContracts"] as! [ResultMap]).map { (value: ResultMap) -> ListContract in ListContract(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: ListContract) -> ResultMap in value.resultMap }, forKey: "listContracts")
      }
    }

    public struct ListContract: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Contract"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(UserContractFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: String, contractId: String, signedAt: String, acceptedAt: String, uploadedAt: String? = nil) {
        self.init(unsafeResultMap: ["__typename": "Contract", "name": name, "contractId": contractId, "signedAt": signedAt, "acceptedAt": acceptedAt, "uploadedAt": uploadedAt])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var userContractFragment: UserContractFragment {
          get {
            return UserContractFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class ApproveScaChallengeMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation approveScaChallenge($scaChallengeId: String!) {
      approveScaChallenge(scaChallengeId: $scaChallengeId) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "approveScaChallenge"

  public var scaChallengeId: String

  public init(scaChallengeId: String) {
    self.scaChallengeId = scaChallengeId
  }

  public var variables: GraphQLMap? {
    return ["scaChallengeId": scaChallengeId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("approveScaChallenge", arguments: ["scaChallengeId": GraphQLVariable("scaChallengeId")], type: .nonNull(.object(ApproveScaChallenge.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(approveScaChallenge: ApproveScaChallenge) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "approveScaChallenge": approveScaChallenge.resultMap])
    }

    public var approveScaChallenge: ApproveScaChallenge {
      get {
        return ApproveScaChallenge(unsafeResultMap: resultMap["approveScaChallenge"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "approveScaChallenge")
      }
    }

    public struct ApproveScaChallenge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SetScaChallengeStatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(ScaChallengeStatus.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: ScaChallengeStatus) {
        self.init(unsafeResultMap: ["__typename": "SetScaChallengeStatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: ScaChallengeStatus {
        get {
          return resultMap["status"]! as! ScaChallengeStatus
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class DeclineScaChallengeMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation declineScaChallenge($scaChallengeId: String!) {
      declineScaChallenge(scaChallengeId: $scaChallengeId) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "declineScaChallenge"

  public var scaChallengeId: String

  public init(scaChallengeId: String) {
    self.scaChallengeId = scaChallengeId
  }

  public var variables: GraphQLMap? {
    return ["scaChallengeId": scaChallengeId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("declineScaChallenge", arguments: ["scaChallengeId": GraphQLVariable("scaChallengeId")], type: .nonNull(.object(DeclineScaChallenge.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(declineScaChallenge: DeclineScaChallenge) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "declineScaChallenge": declineScaChallenge.resultMap])
    }

    public var declineScaChallenge: DeclineScaChallenge {
      get {
        return DeclineScaChallenge(unsafeResultMap: resultMap["declineScaChallenge"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "declineScaChallenge")
      }
    }

    public struct DeclineScaChallenge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["SetScaChallengeStatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(ScaChallengeStatus.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: ScaChallengeStatus) {
        self.init(unsafeResultMap: ["__typename": "SetScaChallengeStatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: ScaChallengeStatus {
        get {
          return resultMap["status"]! as! ScaChallengeStatus
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class GetScaChallengeQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getScaChallenge($scaChallengeId: String!) {
      getScaChallenge(scaChallengeId: $scaChallengeId) {
        __typename
        ...ScaChallengeFragment
      }
    }
    """

  public let operationName: String = "getScaChallenge"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ScaChallengeFragment.fragmentDefinition)
    return document
  }

  public var scaChallengeId: String

  public init(scaChallengeId: String) {
    self.scaChallengeId = scaChallengeId
  }

  public var variables: GraphQLMap? {
    return ["scaChallengeId": scaChallengeId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getScaChallenge", arguments: ["scaChallengeId": GraphQLVariable("scaChallengeId")], type: .nonNull(.object(GetScaChallenge.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getScaChallenge: GetScaChallenge) {
      self.init(unsafeResultMap: ["__typename": "Query", "getScaChallenge": getScaChallenge.resultMap])
    }

    public var getScaChallenge: GetScaChallenge {
      get {
        return GetScaChallenge(unsafeResultMap: resultMap["getScaChallenge"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getScaChallenge")
      }
    }

    public struct GetScaChallenge: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ScaChallenge"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(ScaChallengeFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String, userId: String, cardToken: String, merchant: String, amount: String, currency: String, challengedAt: String, expiresAfter: Double, status: ScaChallengeStatus, lastDigits: String) {
        self.init(unsafeResultMap: ["__typename": "ScaChallenge", "id": id, "userId": userId, "cardToken": cardToken, "merchant": merchant, "amount": amount, "currency": currency, "challengedAt": challengedAt, "expiresAfter": expiresAfter, "status": status, "lastDigits": lastDigits])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var scaChallengeFragment: ScaChallengeFragment {
          get {
            return ScaChallengeFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class GetScaChallengeListQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query getScaChallengeList {
      getScaChallengeList {
        __typename
        ...ScaChallengeFragment
      }
    }
    """

  public let operationName: String = "getScaChallengeList"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + ScaChallengeFragment.fragmentDefinition)
    return document
  }

  public init() {
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getScaChallengeList", type: .nonNull(.list(.nonNull(.object(GetScaChallengeList.selections))))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getScaChallengeList: [GetScaChallengeList]) {
      self.init(unsafeResultMap: ["__typename": "Query", "getScaChallengeList": getScaChallengeList.map { (value: GetScaChallengeList) -> ResultMap in value.resultMap }])
    }

    public var getScaChallengeList: [GetScaChallengeList] {
      get {
        return (resultMap["getScaChallengeList"] as! [ResultMap]).map { (value: ResultMap) -> GetScaChallengeList in GetScaChallengeList(unsafeResultMap: value) }
      }
      set {
        resultMap.updateValue(newValue.map { (value: GetScaChallengeList) -> ResultMap in value.resultMap }, forKey: "getScaChallengeList")
      }
    }

    public struct GetScaChallengeList: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["ScaChallenge"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLFragmentSpread(ScaChallengeFragment.self),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(id: String, userId: String, cardToken: String, merchant: String, amount: String, currency: String, challengedAt: String, expiresAfter: Double, status: ScaChallengeStatus, lastDigits: String) {
        self.init(unsafeResultMap: ["__typename": "ScaChallenge", "id": id, "userId": userId, "cardToken": cardToken, "merchant": merchant, "amount": amount, "currency": currency, "challengedAt": challengedAt, "expiresAfter": expiresAfter, "status": status, "lastDigits": lastDigits])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var fragments: Fragments {
        get {
          return Fragments(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }

      public struct Fragments {
        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public var scaChallengeFragment: ScaChallengeFragment {
          get {
            return ScaChallengeFragment(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }
      }
    }
  }
}

public final class CheckTokenQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query checkToken($otp: String!) {
      checkToken(otp: $otp) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "checkToken"

  public var otp: String

  public init(otp: String) {
    self.otp = otp
  }

  public var variables: GraphQLMap? {
    return ["otp": otp]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("checkToken", arguments: ["otp": GraphQLVariable("otp")], type: .nonNull(.object(CheckToken.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(checkToken: CheckToken) {
      self.init(unsafeResultMap: ["__typename": "Query", "checkToken": checkToken.resultMap])
    }

    public var checkToken: CheckToken {
      get {
        return CheckToken(unsafeResultMap: resultMap["checkToken"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "checkToken")
      }
    }

    public struct CheckToken: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["StatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(Status.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: Status) {
        self.init(unsafeResultMap: ["__typename": "StatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: Status {
        get {
          return resultMap["status"]! as! Status
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class CheckTokenV2Query: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query checkTokenV2($otp: String!) {
      checkTokenV2(otp: $otp) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "checkTokenV2"

  public var otp: String

  public init(otp: String) {
    self.otp = otp
  }

  public var variables: GraphQLMap? {
    return ["otp": otp]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("checkTokenV2", arguments: ["otp": GraphQLVariable("otp")], type: .nonNull(.object(CheckTokenV2.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(checkTokenV2: CheckTokenV2) {
      self.init(unsafeResultMap: ["__typename": "Query", "checkTokenV2": checkTokenV2.resultMap])
    }

    public var checkTokenV2: CheckTokenV2 {
      get {
        return CheckTokenV2(unsafeResultMap: resultMap["checkTokenV2"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "checkTokenV2")
      }
    }

    public struct CheckTokenV2: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["StatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(Status.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: Status) {
        self.init(unsafeResultMap: ["__typename": "StatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: Status {
        get {
          return resultMap["status"]! as! Status
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class DeviceActivationMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation deviceActivation($password: String!, $phoneNumber: String!, $device: String!, $deviceId: String!) {
      deviceActivation(
        password: $password
        phoneNumber: $phoneNumber
        device: $device
        deviceId: $deviceId
      ) {
        __typename
        temporaryToken
        otpInfo {
          __typename
          ...OtpInfoFragment
        }
      }
    }
    """

  public let operationName: String = "deviceActivation"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + OtpInfoFragment.fragmentDefinition)
    return document
  }

  public var password: String
  public var phoneNumber: String
  public var device: String
  public var deviceId: String

  public init(password: String, phoneNumber: String, device: String, deviceId: String) {
    self.password = password
    self.phoneNumber = phoneNumber
    self.device = device
    self.deviceId = deviceId
  }

  public var variables: GraphQLMap? {
    return ["password": password, "phoneNumber": phoneNumber, "device": device, "deviceId": deviceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("deviceActivation", arguments: ["password": GraphQLVariable("password"), "phoneNumber": GraphQLVariable("phoneNumber"), "device": GraphQLVariable("device"), "deviceId": GraphQLVariable("deviceId")], type: .nonNull(.object(DeviceActivation.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(deviceActivation: DeviceActivation) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "deviceActivation": deviceActivation.resultMap])
    }

    public var deviceActivation: DeviceActivation {
      get {
        return DeviceActivation(unsafeResultMap: resultMap["deviceActivation"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "deviceActivation")
      }
    }

    public struct DeviceActivation: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["RegisterResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("temporaryToken", type: .nonNull(.scalar(String.self))),
          GraphQLField("otpInfo", type: .nonNull(.object(OtpInfo.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(temporaryToken: String, otpInfo: OtpInfo) {
        self.init(unsafeResultMap: ["__typename": "RegisterResponse", "temporaryToken": temporaryToken, "otpInfo": otpInfo.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var temporaryToken: String {
        get {
          return resultMap["temporaryToken"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "temporaryToken")
        }
      }

      public var otpInfo: OtpInfo {
        get {
          return OtpInfo(unsafeResultMap: resultMap["otpInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "otpInfo")
        }
      }

      public struct OtpInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["OtpInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(OtpInfoFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(expireInterval: Double, nextRequestInterval: Double) {
          self.init(unsafeResultMap: ["__typename": "OtpInfo", "expireInterval": expireInterval, "nextRequestInterval": nextRequestInterval])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var otpInfoFragment: OtpInfoFragment {
            get {
              return OtpInfoFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class PrepareTokenMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation prepareToken($timestamp: String!, $device: String!, $deviceId: String!) {
      prepareToken(timestamp: $timestamp, device: $device, deviceId: $deviceId)
    }
    """

  public let operationName: String = "prepareToken"

  public var timestamp: String
  public var device: String
  public var deviceId: String

  public init(timestamp: String, device: String, deviceId: String) {
    self.timestamp = timestamp
    self.device = device
    self.deviceId = deviceId
  }

  public var variables: GraphQLMap? {
    return ["timestamp": timestamp, "device": device, "deviceId": deviceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("prepareToken", arguments: ["timestamp": GraphQLVariable("timestamp"), "device": GraphQLVariable("device"), "deviceId": GraphQLVariable("deviceId")], type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(prepareToken: String) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "prepareToken": prepareToken])
    }

    public var prepareToken: String {
      get {
        return resultMap["prepareToken"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "prepareToken")
      }
    }
  }
}

public final class PrepareTokenV2Mutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation prepareTokenV2($timestamp: String!, $dhParams: String!, $dhClient: String!, $device: String!, $deviceId: String!) {
      prepareTokenV2(
        timestamp: $timestamp
        dhParams: $dhParams
        dhClient: $dhClient
        device: $device
        deviceId: $deviceId
      ) {
        __typename
        token
        dhServer
      }
    }
    """

  public let operationName: String = "prepareTokenV2"

  public var timestamp: String
  public var dhParams: String
  public var dhClient: String
  public var device: String
  public var deviceId: String

  public init(timestamp: String, dhParams: String, dhClient: String, device: String, deviceId: String) {
    self.timestamp = timestamp
    self.dhParams = dhParams
    self.dhClient = dhClient
    self.device = device
    self.deviceId = deviceId
  }

  public var variables: GraphQLMap? {
    return ["timestamp": timestamp, "dhParams": dhParams, "dhClient": dhClient, "device": device, "deviceId": deviceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("prepareTokenV2", arguments: ["timestamp": GraphQLVariable("timestamp"), "dhParams": GraphQLVariable("dhParams"), "dhClient": GraphQLVariable("dhClient"), "device": GraphQLVariable("device"), "deviceId": GraphQLVariable("deviceId")], type: .nonNull(.object(PrepareTokenV2.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(prepareTokenV2: PrepareTokenV2) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "prepareTokenV2": prepareTokenV2.resultMap])
    }

    public var prepareTokenV2: PrepareTokenV2 {
      get {
        return PrepareTokenV2(unsafeResultMap: resultMap["prepareTokenV2"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "prepareTokenV2")
      }
    }

    public struct PrepareTokenV2: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["PrepareTokenV2Response"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("token", type: .nonNull(.scalar(String.self))),
          GraphQLField("dhServer", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(token: String, dhServer: String) {
        self.init(unsafeResultMap: ["__typename": "PrepareTokenV2Response", "token": token, "dhServer": dhServer])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var token: String {
        get {
          return resultMap["token"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "token")
        }
      }

      public var dhServer: String {
        get {
          return resultMap["dhServer"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "dhServer")
        }
      }
    }
  }
}

public final class RegisterMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation register($email: String!, $password: String!, $phoneNumber: String!, $device: String!, $deviceId: String!) {
      register(
        email: $email
        password: $password
        phoneNumber: $phoneNumber
        device: $device
        deviceId: $deviceId
      ) {
        __typename
        temporaryToken
        otpInfo {
          __typename
          ...OtpInfoFragment
        }
      }
    }
    """

  public let operationName: String = "register"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + OtpInfoFragment.fragmentDefinition)
    return document
  }

  public var email: String
  public var password: String
  public var phoneNumber: String
  public var device: String
  public var deviceId: String

  public init(email: String, password: String, phoneNumber: String, device: String, deviceId: String) {
    self.email = email
    self.password = password
    self.phoneNumber = phoneNumber
    self.device = device
    self.deviceId = deviceId
  }

  public var variables: GraphQLMap? {
    return ["email": email, "password": password, "phoneNumber": phoneNumber, "device": device, "deviceId": deviceId]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("register", arguments: ["email": GraphQLVariable("email"), "password": GraphQLVariable("password"), "phoneNumber": GraphQLVariable("phoneNumber"), "device": GraphQLVariable("device"), "deviceId": GraphQLVariable("deviceId")], type: .nonNull(.object(Register.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(register: Register) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "register": register.resultMap])
    }

    public var register: Register {
      get {
        return Register(unsafeResultMap: resultMap["register"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "register")
      }
    }

    public struct Register: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["RegisterResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("temporaryToken", type: .nonNull(.scalar(String.self))),
          GraphQLField("otpInfo", type: .nonNull(.object(OtpInfo.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(temporaryToken: String, otpInfo: OtpInfo) {
        self.init(unsafeResultMap: ["__typename": "RegisterResponse", "temporaryToken": temporaryToken, "otpInfo": otpInfo.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var temporaryToken: String {
        get {
          return resultMap["temporaryToken"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "temporaryToken")
        }
      }

      public var otpInfo: OtpInfo {
        get {
          return OtpInfo(unsafeResultMap: resultMap["otpInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "otpInfo")
        }
      }

      public struct OtpInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["OtpInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(OtpInfoFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(expireInterval: Double, nextRequestInterval: Double) {
          self.init(unsafeResultMap: ["__typename": "OtpInfo", "expireInterval": expireInterval, "nextRequestInterval": nextRequestInterval])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var otpInfoFragment: OtpInfoFragment {
            get {
              return OtpInfoFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class ResendOtpQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query resendOtp($deviceId: String!, $phoneNumber: String!) {
      getOtp(deviceId: $deviceId, phoneNumber: $phoneNumber) {
        __typename
        remainingAttempts
        otpInfo {
          __typename
          ...OtpInfoFragment
        }
      }
    }
    """

  public let operationName: String = "resendOtp"

  public var queryDocument: String {
    var document: String = operationDefinition
    document.append("\n" + OtpInfoFragment.fragmentDefinition)
    return document
  }

  public var deviceId: String
  public var phoneNumber: String

  public init(deviceId: String, phoneNumber: String) {
    self.deviceId = deviceId
    self.phoneNumber = phoneNumber
  }

  public var variables: GraphQLMap? {
    return ["deviceId": deviceId, "phoneNumber": phoneNumber]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("getOtp", arguments: ["deviceId": GraphQLVariable("deviceId"), "phoneNumber": GraphQLVariable("phoneNumber")], type: .nonNull(.object(GetOtp.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(getOtp: GetOtp) {
      self.init(unsafeResultMap: ["__typename": "Query", "getOtp": getOtp.resultMap])
    }

    public var getOtp: GetOtp {
      get {
        return GetOtp(unsafeResultMap: resultMap["getOtp"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "getOtp")
      }
    }

    public struct GetOtp: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["GetOtpResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("remainingAttempts", type: .nonNull(.scalar(Double.self))),
          GraphQLField("otpInfo", type: .nonNull(.object(OtpInfo.selections))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(remainingAttempts: Double, otpInfo: OtpInfo) {
        self.init(unsafeResultMap: ["__typename": "GetOtpResponse", "remainingAttempts": remainingAttempts, "otpInfo": otpInfo.resultMap])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var remainingAttempts: Double {
        get {
          return resultMap["remainingAttempts"]! as! Double
        }
        set {
          resultMap.updateValue(newValue, forKey: "remainingAttempts")
        }
      }

      public var otpInfo: OtpInfo {
        get {
          return OtpInfo(unsafeResultMap: resultMap["otpInfo"]! as! ResultMap)
        }
        set {
          resultMap.updateValue(newValue.resultMap, forKey: "otpInfo")
        }
      }

      public struct OtpInfo: GraphQLSelectionSet {
        public static let possibleTypes: [String] = ["OtpInfo"]

        public static var selections: [GraphQLSelection] {
          return [
            GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
            GraphQLFragmentSpread(OtpInfoFragment.self),
          ]
        }

        public private(set) var resultMap: ResultMap

        public init(unsafeResultMap: ResultMap) {
          self.resultMap = unsafeResultMap
        }

        public init(expireInterval: Double, nextRequestInterval: Double) {
          self.init(unsafeResultMap: ["__typename": "OtpInfo", "expireInterval": expireInterval, "nextRequestInterval": nextRequestInterval])
        }

        public var __typename: String {
          get {
            return resultMap["__typename"]! as! String
          }
          set {
            resultMap.updateValue(newValue, forKey: "__typename")
          }
        }

        public var fragments: Fragments {
          get {
            return Fragments(unsafeResultMap: resultMap)
          }
          set {
            resultMap += newValue.resultMap
          }
        }

        public struct Fragments {
          public private(set) var resultMap: ResultMap

          public init(unsafeResultMap: ResultMap) {
            self.resultMap = unsafeResultMap
          }

          public var otpInfoFragment: OtpInfoFragment {
            get {
              return OtpInfoFragment(unsafeResultMap: resultMap)
            }
            set {
              resultMap += newValue.resultMap
            }
          }
        }
      }
    }
  }
}

public final class VerifyPhoneQuery: GraphQLQuery {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    query VerifyPhone($phoneNumber: String!) {
      verifyPhone(phoneNumber: $phoneNumber) {
        __typename
        status
      }
    }
    """

  public let operationName: String = "VerifyPhone"

  public var phoneNumber: String

  public init(phoneNumber: String) {
    self.phoneNumber = phoneNumber
  }

  public var variables: GraphQLMap? {
    return ["phoneNumber": phoneNumber]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Query"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("verifyPhone", arguments: ["phoneNumber": GraphQLVariable("phoneNumber")], type: .nonNull(.object(VerifyPhone.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(verifyPhone: VerifyPhone) {
      self.init(unsafeResultMap: ["__typename": "Query", "verifyPhone": verifyPhone.resultMap])
    }

    public var verifyPhone: VerifyPhone {
      get {
        return VerifyPhone(unsafeResultMap: resultMap["verifyPhone"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "verifyPhone")
      }
    }

    public struct VerifyPhone: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["StatusResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("status", type: .nonNull(.scalar(Status.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(status: Status) {
        self.init(unsafeResultMap: ["__typename": "StatusResponse", "status": status])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var status: Status {
        get {
          return resultMap["status"]! as! Status
        }
        set {
          resultMap.updateValue(newValue, forKey: "status")
        }
      }
    }
  }
}

public final class VerifyOtpMutation: GraphQLMutation {
  /// The raw GraphQL definition of this operation.
  public let operationDefinition: String =
    """
    mutation verifyOtp($smsOtp: String!) {
      verifyOtp(smsOtp: $smsOtp) {
        __typename
        accessToken
        refreshToken
      }
    }
    """

  public let operationName: String = "verifyOtp"

  public var smsOtp: String

  public init(smsOtp: String) {
    self.smsOtp = smsOtp
  }

  public var variables: GraphQLMap? {
    return ["smsOtp": smsOtp]
  }

  public struct Data: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Mutation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("verifyOtp", arguments: ["smsOtp": GraphQLVariable("smsOtp")], type: .nonNull(.object(VerifyOtp.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(verifyOtp: VerifyOtp) {
      self.init(unsafeResultMap: ["__typename": "Mutation", "verifyOtp": verifyOtp.resultMap])
    }

    public var verifyOtp: VerifyOtp {
      get {
        return VerifyOtp(unsafeResultMap: resultMap["verifyOtp"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "verifyOtp")
      }
    }

    public struct VerifyOtp: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["VerifyOtpResponse"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("accessToken", type: .nonNull(.scalar(String.self))),
          GraphQLField("refreshToken", type: .nonNull(.scalar(String.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(accessToken: String, refreshToken: String) {
        self.init(unsafeResultMap: ["__typename": "VerifyOtpResponse", "accessToken": accessToken, "refreshToken": refreshToken])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      public var accessToken: String {
        get {
          return resultMap["accessToken"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "accessToken")
        }
      }

      public var refreshToken: String {
        get {
          return resultMap["refreshToken"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "refreshToken")
        }
      }
    }
  }
}

public struct AccountFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment AccountFragment on Account {
      __typename
      id
      accountNumber
      accountId
      acceptedDate
      accountingUnitType
      accountingUnitSubType
      currency
      lifecycleStatus
      swift
      iban
      source
      flags
      limits {
        __typename
        dailyTransferLimit {
          __typename
          name
          value
          min
          max
        }
      }
      arrearsBalance {
        __typename
        ...BalanceFragment
      }
      blockedBalance {
        __typename
        ...BalanceFragment
      }
      availableBalance {
        __typename
        ...BalanceFragment
      }
      bookedBalance {
        __typename
        ...BalanceFragment
      }
      proxyIds {
        __typename
        alias
        status
        type
      }
    }
    """

  public static let possibleTypes: [String] = ["Account"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(String.self))),
      GraphQLField("accountNumber", type: .nonNull(.scalar(String.self))),
      GraphQLField("accountId", type: .nonNull(.scalar(String.self))),
      GraphQLField("acceptedDate", type: .nonNull(.scalar(String.self))),
      GraphQLField("accountingUnitType", type: .nonNull(.scalar(AccountingUnitType.self))),
      GraphQLField("accountingUnitSubType", type: .nonNull(.scalar(AccountingUnitSubType.self))),
      GraphQLField("currency", type: .nonNull(.scalar(String.self))),
      GraphQLField("lifecycleStatus", type: .nonNull(.scalar(LifecycleStatus.self))),
      GraphQLField("swift", type: .nonNull(.scalar(String.self))),
      GraphQLField("iban", type: .nonNull(.scalar(String.self))),
      GraphQLField("source", type: .nonNull(.scalar(SourceSystem.self))),
      GraphQLField("flags", type: .nonNull(.list(.nonNull(.scalar(AccountFlag.self))))),
      GraphQLField("limits", type: .nonNull(.object(Limit.selections))),
      GraphQLField("arrearsBalance", type: .nonNull(.object(ArrearsBalance.selections))),
      GraphQLField("blockedBalance", type: .nonNull(.object(BlockedBalance.selections))),
      GraphQLField("availableBalance", type: .nonNull(.object(AvailableBalance.selections))),
      GraphQLField("bookedBalance", type: .nonNull(.object(BookedBalance.selections))),
      GraphQLField("proxyIds", type: .nonNull(.list(.nonNull(.object(ProxyId.selections))))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: String, accountNumber: String, accountId: String, acceptedDate: String, accountingUnitType: AccountingUnitType, accountingUnitSubType: AccountingUnitSubType, currency: String, lifecycleStatus: LifecycleStatus, swift: String, iban: String, source: SourceSystem, flags: [AccountFlag], limits: Limit, arrearsBalance: ArrearsBalance, blockedBalance: BlockedBalance, availableBalance: AvailableBalance, bookedBalance: BookedBalance, proxyIds: [ProxyId]) {
    self.init(unsafeResultMap: ["__typename": "Account", "id": id, "accountNumber": accountNumber, "accountId": accountId, "acceptedDate": acceptedDate, "accountingUnitType": accountingUnitType, "accountingUnitSubType": accountingUnitSubType, "currency": currency, "lifecycleStatus": lifecycleStatus, "swift": swift, "iban": iban, "source": source, "flags": flags, "limits": limits.resultMap, "arrearsBalance": arrearsBalance.resultMap, "blockedBalance": blockedBalance.resultMap, "availableBalance": availableBalance.resultMap, "bookedBalance": bookedBalance.resultMap, "proxyIds": proxyIds.map { (value: ProxyId) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String {
    get {
      return resultMap["id"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var accountNumber: String {
    get {
      return resultMap["accountNumber"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "accountNumber")
    }
  }

  public var accountId: String {
    get {
      return resultMap["accountId"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "accountId")
    }
  }

  public var acceptedDate: String {
    get {
      return resultMap["acceptedDate"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "acceptedDate")
    }
  }

  public var accountingUnitType: AccountingUnitType {
    get {
      return resultMap["accountingUnitType"]! as! AccountingUnitType
    }
    set {
      resultMap.updateValue(newValue, forKey: "accountingUnitType")
    }
  }

  public var accountingUnitSubType: AccountingUnitSubType {
    get {
      return resultMap["accountingUnitSubType"]! as! AccountingUnitSubType
    }
    set {
      resultMap.updateValue(newValue, forKey: "accountingUnitSubType")
    }
  }

  /// Currency Code based on ISO 4217.
  public var currency: String {
    get {
      return resultMap["currency"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "currency")
    }
  }

  public var lifecycleStatus: LifecycleStatus {
    get {
      return resultMap["lifecycleStatus"]! as! LifecycleStatus
    }
    set {
      resultMap.updateValue(newValue, forKey: "lifecycleStatus")
    }
  }

  public var swift: String {
    get {
      return resultMap["swift"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "swift")
    }
  }

  public var iban: String {
    get {
      return resultMap["iban"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "iban")
    }
  }

  public var source: SourceSystem {
    get {
      return resultMap["source"]! as! SourceSystem
    }
    set {
      resultMap.updateValue(newValue, forKey: "source")
    }
  }

  public var flags: [AccountFlag] {
    get {
      return resultMap["flags"]! as! [AccountFlag]
    }
    set {
      resultMap.updateValue(newValue, forKey: "flags")
    }
  }

  public var limits: Limit {
    get {
      return Limit(unsafeResultMap: resultMap["limits"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "limits")
    }
  }

  /// Arrears Balance
  public var arrearsBalance: ArrearsBalance {
    get {
      return ArrearsBalance(unsafeResultMap: resultMap["arrearsBalance"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "arrearsBalance")
    }
  }

  /// Blocked Balance
  public var blockedBalance: BlockedBalance {
    get {
      return BlockedBalance(unsafeResultMap: resultMap["blockedBalance"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "blockedBalance")
    }
  }

  /// Available Balance
  public var availableBalance: AvailableBalance {
    get {
      return AvailableBalance(unsafeResultMap: resultMap["availableBalance"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "availableBalance")
    }
  }

  /// Booked Balance
  public var bookedBalance: BookedBalance {
    get {
      return BookedBalance(unsafeResultMap: resultMap["bookedBalance"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "bookedBalance")
    }
  }

  public var proxyIds: [ProxyId] {
    get {
      return (resultMap["proxyIds"] as! [ResultMap]).map { (value: ResultMap) -> ProxyId in ProxyId(unsafeResultMap: value) }
    }
    set {
      resultMap.updateValue(newValue.map { (value: ProxyId) -> ResultMap in value.resultMap }, forKey: "proxyIds")
    }
  }

  public struct Limit: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["AccountLimits"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("dailyTransferLimit", type: .nonNull(.object(DailyTransferLimit.selections))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(dailyTransferLimit: DailyTransferLimit) {
      self.init(unsafeResultMap: ["__typename": "AccountLimits", "dailyTransferLimit": dailyTransferLimit.resultMap])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var dailyTransferLimit: DailyTransferLimit {
      get {
        return DailyTransferLimit(unsafeResultMap: resultMap["dailyTransferLimit"]! as! ResultMap)
      }
      set {
        resultMap.updateValue(newValue.resultMap, forKey: "dailyTransferLimit")
      }
    }

    public struct DailyTransferLimit: GraphQLSelectionSet {
      public static let possibleTypes: [String] = ["Limit"]

      public static var selections: [GraphQLSelection] {
        return [
          GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
          GraphQLField("name", type: .nonNull(.scalar(LimitType.self))),
          GraphQLField("value", type: .nonNull(.scalar(Int.self))),
          GraphQLField("min", type: .nonNull(.scalar(Int.self))),
          GraphQLField("max", type: .nonNull(.scalar(Int.self))),
        ]
      }

      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public init(name: LimitType, value: Int, min: Int, max: Int) {
        self.init(unsafeResultMap: ["__typename": "Limit", "name": name, "value": value, "min": min, "max": max])
      }

      public var __typename: String {
        get {
          return resultMap["__typename"]! as! String
        }
        set {
          resultMap.updateValue(newValue, forKey: "__typename")
        }
      }

      /// This is just a code.
      public var name: LimitType {
        get {
          return resultMap["name"]! as! LimitType
        }
        set {
          resultMap.updateValue(newValue, forKey: "name")
        }
      }

      public var value: Int {
        get {
          return resultMap["value"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "value")
        }
      }

      public var min: Int {
        get {
          return resultMap["min"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "min")
        }
      }

      public var max: Int {
        get {
          return resultMap["max"]! as! Int
        }
        set {
          resultMap.updateValue(newValue, forKey: "max")
        }
      }
    }
  }

  public struct ArrearsBalance: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Balance"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(BalanceFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(netAmount: Double, currency: String) {
      self.init(unsafeResultMap: ["__typename": "Balance", "netAmount": netAmount, "currency": currency])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var balanceFragment: BalanceFragment {
        get {
          return BalanceFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct BlockedBalance: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Balance"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(BalanceFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(netAmount: Double, currency: String) {
      self.init(unsafeResultMap: ["__typename": "Balance", "netAmount": netAmount, "currency": currency])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var balanceFragment: BalanceFragment {
        get {
          return BalanceFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct AvailableBalance: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Balance"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(BalanceFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(netAmount: Double, currency: String) {
      self.init(unsafeResultMap: ["__typename": "Balance", "netAmount": netAmount, "currency": currency])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var balanceFragment: BalanceFragment {
        get {
          return BalanceFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct BookedBalance: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Balance"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(BalanceFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(netAmount: Double, currency: String) {
      self.init(unsafeResultMap: ["__typename": "Balance", "netAmount": netAmount, "currency": currency])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var balanceFragment: BalanceFragment {
        get {
          return BalanceFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct ProxyId: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["ProxyId"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("alias", type: .nonNull(.scalar(String.self))),
        GraphQLField("status", type: .nonNull(.scalar(ProxyIdStatus.self))),
        GraphQLField("type", type: .nonNull(.scalar(ProxyIdType.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(alias: String, status: ProxyIdStatus, type: ProxyIdType) {
      self.init(unsafeResultMap: ["__typename": "ProxyId", "alias": alias, "status": status, "type": type])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var alias: String {
      get {
        return resultMap["alias"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "alias")
      }
    }

    public var status: ProxyIdStatus {
      get {
        return resultMap["status"]! as! ProxyIdStatus
      }
      set {
        resultMap.updateValue(newValue, forKey: "status")
      }
    }

    public var type: ProxyIdType {
      get {
        return resultMap["type"]! as! ProxyIdType
      }
      set {
        resultMap.updateValue(newValue, forKey: "type")
      }
    }
  }
}

public struct AccountClosureStatementInfoFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment AccountClosureStatementInfoFragment on AccountClosureStatementInfo {
      __typename
      polling
      contractId
      successful
      error
    }
    """

  public static let possibleTypes: [String] = ["AccountClosureStatementInfo"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("polling", type: .nonNull(.scalar(Double.self))),
      GraphQLField("contractId", type: .scalar(String.self)),
      GraphQLField("successful", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("error", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(polling: Double, contractId: String? = nil, successful: Bool, error: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "AccountClosureStatementInfo", "polling": polling, "contractId": contractId, "successful": successful, "error": error])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var polling: Double {
    get {
      return resultMap["polling"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "polling")
    }
  }

  public var contractId: String? {
    get {
      return resultMap["contractId"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "contractId")
    }
  }

  public var successful: Bool {
    get {
      return resultMap["successful"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "successful")
    }
  }

  public var error: String? {
    get {
      return resultMap["error"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "error")
    }
  }
}

public struct AccountInfoFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment AccountInfoFragment on AccountInfo {
      __typename
      polling
      successful
      accountId
      error
    }
    """

  public static let possibleTypes: [String] = ["AccountInfo"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("polling", type: .nonNull(.scalar(Double.self))),
      GraphQLField("successful", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("accountId", type: .scalar(String.self)),
      GraphQLField("error", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(polling: Double, successful: Bool, accountId: String? = nil, error: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "AccountInfo", "polling": polling, "successful": successful, "accountId": accountId, "error": error])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var polling: Double {
    get {
      return resultMap["polling"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "polling")
    }
  }

  public var successful: Bool {
    get {
      return resultMap["successful"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "successful")
    }
  }

  public var accountId: String? {
    get {
      return resultMap["accountId"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "accountId")
    }
  }

  public var error: String? {
    get {
      return resultMap["error"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "error")
    }
  }
}

public struct AddressFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment AddressFragment on Address {
      __typename
      city
      country
      houseNumber
      postCode
      streetName
    }
    """

  public static let possibleTypes: [String] = ["Address"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("city", type: .nonNull(.scalar(String.self))),
      GraphQLField("country", type: .nonNull(.scalar(String.self))),
      GraphQLField("houseNumber", type: .nonNull(.scalar(String.self))),
      GraphQLField("postCode", type: .nonNull(.scalar(String.self))),
      GraphQLField("streetName", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(city: String, country: String, houseNumber: String, postCode: String, streetName: String) {
    self.init(unsafeResultMap: ["__typename": "Address", "city": city, "country": country, "houseNumber": houseNumber, "postCode": postCode, "streetName": streetName])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var city: String {
    get {
      return resultMap["city"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "city")
    }
  }

  public var country: String {
    get {
      return resultMap["country"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "country")
    }
  }

  public var houseNumber: String {
    get {
      return resultMap["houseNumber"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "houseNumber")
    }
  }

  public var postCode: String {
    get {
      return resultMap["postCode"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "postCode")
    }
  }

  public var streetName: String {
    get {
      return resultMap["streetName"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "streetName")
    }
  }
}

public struct BalanceFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment BalanceFragment on Balance {
      __typename
      netAmount
      currency
    }
    """

  public static let possibleTypes: [String] = ["Balance"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("netAmount", type: .nonNull(.scalar(Double.self))),
      GraphQLField("currency", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(netAmount: Double, currency: String) {
    self.init(unsafeResultMap: ["__typename": "Balance", "netAmount": netAmount, "currency": currency])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var netAmount: Double {
    get {
      return resultMap["netAmount"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "netAmount")
    }
  }

  /// Currency Code based on ISO 4217.
  public var currency: String {
    get {
      return resultMap["currency"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "currency")
    }
  }
}

public struct CardLimitFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment CardLimitFragment on CardLimit {
      __typename
      total
      remaining
      min
      max
    }
    """

  public static let possibleTypes: [String] = ["CardLimit"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("total", type: .nonNull(.scalar(Double.self))),
      GraphQLField("remaining", type: .nonNull(.scalar(Double.self))),
      GraphQLField("min", type: .nonNull(.scalar(Double.self))),
      GraphQLField("max", type: .nonNull(.scalar(Double.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(total: Double, remaining: Double, min: Double, max: Double) {
    self.init(unsafeResultMap: ["__typename": "CardLimit", "total": total, "remaining": remaining, "min": min, "max": max])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var total: Double {
    get {
      return resultMap["total"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "total")
    }
  }

  public var remaining: Double {
    get {
      return resultMap["remaining"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "remaining")
    }
  }

  public var min: Double {
    get {
      return resultMap["min"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "min")
    }
  }

  public var max: Double {
    get {
      return resultMap["max"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "max")
    }
  }
}

public struct CardTransactionFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment CardTransactionFragment on CardTransaction {
      __typename
      billingMoney {
        __typename
        ...MoneyFragment
      }
      cardPanLastFourDigits
      cardTransactionType
      createdAt
      declineReason
      direction
      exchangeRate
      id
      merchantName
      modified_at
      money {
        __typename
        ...MoneyFragment
      }
      settlementDate
      status
      valueDate
      violatedLimits
    }
    """

  public static let possibleTypes: [String] = ["CardTransaction"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("billingMoney", type: .nonNull(.object(BillingMoney.selections))),
      GraphQLField("cardPanLastFourDigits", type: .nonNull(.scalar(String.self))),
      GraphQLField("cardTransactionType", type: .nonNull(.scalar(CardTransactionCardTransactionType.self))),
      GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
      GraphQLField("declineReason", type: .scalar(CardTransactionDeclineReason.self)),
      GraphQLField("direction", type: .nonNull(.scalar(PaymentTransactionDirection.self))),
      GraphQLField("exchangeRate", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("merchantName", type: .nonNull(.scalar(String.self))),
      GraphQLField("modified_at", type: .nonNull(.scalar(String.self))),
      GraphQLField("money", type: .nonNull(.object(Money.selections))),
      GraphQLField("settlementDate", type: .scalar(String.self)),
      GraphQLField("status", type: .nonNull(.scalar(PaymentTransactionStatus.self))),
      GraphQLField("valueDate", type: .scalar(String.self)),
      GraphQLField("violatedLimits", type: .nonNull(.list(.nonNull(.scalar(CardTransactionCardLimitType.self))))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(billingMoney: BillingMoney, cardPanLastFourDigits: String, cardTransactionType: CardTransactionCardTransactionType, createdAt: String, declineReason: CardTransactionDeclineReason? = nil, direction: PaymentTransactionDirection, exchangeRate: String, id: GraphQLID, merchantName: String, modifiedAt: String, money: Money, settlementDate: String? = nil, status: PaymentTransactionStatus, valueDate: String? = nil, violatedLimits: [CardTransactionCardLimitType]) {
    self.init(unsafeResultMap: ["__typename": "CardTransaction", "billingMoney": billingMoney.resultMap, "cardPanLastFourDigits": cardPanLastFourDigits, "cardTransactionType": cardTransactionType, "createdAt": createdAt, "declineReason": declineReason, "direction": direction, "exchangeRate": exchangeRate, "id": id, "merchantName": merchantName, "modified_at": modifiedAt, "money": money.resultMap, "settlementDate": settlementDate, "status": status, "valueDate": valueDate, "violatedLimits": violatedLimits])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var billingMoney: BillingMoney {
    get {
      return BillingMoney(unsafeResultMap: resultMap["billingMoney"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "billingMoney")
    }
  }

  public var cardPanLastFourDigits: String {
    get {
      return resultMap["cardPanLastFourDigits"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "cardPanLastFourDigits")
    }
  }

  public var cardTransactionType: CardTransactionCardTransactionType {
    get {
      return resultMap["cardTransactionType"]! as! CardTransactionCardTransactionType
    }
    set {
      resultMap.updateValue(newValue, forKey: "cardTransactionType")
    }
  }

  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var declineReason: CardTransactionDeclineReason? {
    get {
      return resultMap["declineReason"] as? CardTransactionDeclineReason
    }
    set {
      resultMap.updateValue(newValue, forKey: "declineReason")
    }
  }

  public var direction: PaymentTransactionDirection {
    get {
      return resultMap["direction"]! as! PaymentTransactionDirection
    }
    set {
      resultMap.updateValue(newValue, forKey: "direction")
    }
  }

  public var exchangeRate: String {
    get {
      return resultMap["exchangeRate"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "exchangeRate")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var merchantName: String {
    get {
      return resultMap["merchantName"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "merchantName")
    }
  }

  public var modifiedAt: String {
    get {
      return resultMap["modified_at"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "modified_at")
    }
  }

  public var money: Money {
    get {
      return Money(unsafeResultMap: resultMap["money"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "money")
    }
  }

  public var settlementDate: String? {
    get {
      return resultMap["settlementDate"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "settlementDate")
    }
  }

  public var status: PaymentTransactionStatus {
    get {
      return resultMap["status"]! as! PaymentTransactionStatus
    }
    set {
      resultMap.updateValue(newValue, forKey: "status")
    }
  }

  public var valueDate: String? {
    get {
      return resultMap["valueDate"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "valueDate")
    }
  }

  public var violatedLimits: [CardTransactionCardLimitType] {
    get {
      return resultMap["violatedLimits"]! as! [CardTransactionCardLimitType]
    }
    set {
      resultMap.updateValue(newValue, forKey: "violatedLimits")
    }
  }

  public struct BillingMoney: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Money"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MoneyFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(amount: String, currencyCode: String) {
      self.init(unsafeResultMap: ["__typename": "Money", "amount": amount, "currencyCode": currencyCode])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var moneyFragment: MoneyFragment {
        get {
          return MoneyFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Money: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Money"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MoneyFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(amount: String, currencyCode: String) {
      self.init(unsafeResultMap: ["__typename": "Money", "amount": amount, "currencyCode": currencyCode])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var moneyFragment: MoneyFragment {
        get {
          return MoneyFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct ConsentFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ConsentFragment on ConsentInfo {
      __typename
      isPep
      taxation {
        __typename
        ...TaxationFragment
      }
      acceptTerms
      acceptConditions
      acceptPrivacyPolicy
      taxResidency
    }
    """

  public static let possibleTypes: [String] = ["ConsentInfo"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("isPep", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("taxation", type: .nonNull(.list(.nonNull(.object(Taxation.selections))))),
      GraphQLField("acceptTerms", type: .scalar(Bool.self)),
      GraphQLField("acceptConditions", type: .scalar(Bool.self)),
      GraphQLField("acceptPrivacyPolicy", type: .scalar(Bool.self)),
      GraphQLField("taxResidency", type: .scalar(TaxResidency.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(isPep: Bool, taxation: [Taxation], acceptTerms: Bool? = nil, acceptConditions: Bool? = nil, acceptPrivacyPolicy: Bool? = nil, taxResidency: TaxResidency? = nil) {
    self.init(unsafeResultMap: ["__typename": "ConsentInfo", "isPep": isPep, "taxation": taxation.map { (value: Taxation) -> ResultMap in value.resultMap }, "acceptTerms": acceptTerms, "acceptConditions": acceptConditions, "acceptPrivacyPolicy": acceptPrivacyPolicy, "taxResidency": taxResidency])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var isPep: Bool {
    get {
      return resultMap["isPep"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "isPep")
    }
  }

  public var taxation: [Taxation] {
    get {
      return (resultMap["taxation"] as! [ResultMap]).map { (value: ResultMap) -> Taxation in Taxation(unsafeResultMap: value) }
    }
    set {
      resultMap.updateValue(newValue.map { (value: Taxation) -> ResultMap in value.resultMap }, forKey: "taxation")
    }
  }

  public var acceptTerms: Bool? {
    get {
      return resultMap["acceptTerms"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "acceptTerms")
    }
  }

  public var acceptConditions: Bool? {
    get {
      return resultMap["acceptConditions"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "acceptConditions")
    }
  }

  public var acceptPrivacyPolicy: Bool? {
    get {
      return resultMap["acceptPrivacyPolicy"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "acceptPrivacyPolicy")
    }
  }

  public var taxResidency: TaxResidency? {
    get {
      return resultMap["taxResidency"] as? TaxResidency
    }
    set {
      resultMap.updateValue(newValue, forKey: "taxResidency")
    }
  }

  public struct Taxation: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Taxation"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(TaxationFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(country: String, taxNumber: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Taxation", "country": country, "taxNumber": taxNumber])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var taxationFragment: TaxationFragment {
        get {
          return TaxationFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct ContractInfoFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ContractInfoFragment on ContractInfo {
      __typename
      polling
      successful
      contractId
      error
    }
    """

  public static let possibleTypes: [String] = ["ContractInfo"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("polling", type: .nonNull(.scalar(Double.self))),
      GraphQLField("successful", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("contractId", type: .scalar(String.self)),
      GraphQLField("error", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(polling: Double, successful: Bool, contractId: String? = nil, error: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "ContractInfo", "polling": polling, "successful": successful, "contractId": contractId, "error": error])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var polling: Double {
    get {
      return resultMap["polling"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "polling")
    }
  }

  public var successful: Bool {
    get {
      return resultMap["successful"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "successful")
    }
  }

  public var contractId: String? {
    get {
      return resultMap["contractId"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "contractId")
    }
  }

  public var error: String? {
    get {
      return resultMap["error"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "error")
    }
  }
}

public struct DocumentFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment DocumentFragment on Document {
      __typename
      serial
      type
      validUntil
    }
    """

  public static let possibleTypes: [String] = ["Document"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("serial", type: .nonNull(.scalar(String.self))),
      GraphQLField("type", type: .nonNull(.scalar(DocumentType.self))),
      GraphQLField("validUntil", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(serial: String, type: DocumentType, validUntil: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Document", "serial": serial, "type": type, "validUntil": validUntil])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var serial: String {
    get {
      return resultMap["serial"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "serial")
    }
  }

  public var type: DocumentType {
    get {
      return resultMap["type"]! as! DocumentType
    }
    set {
      resultMap.updateValue(newValue, forKey: "type")
    }
  }

  public var validUntil: String? {
    get {
      return resultMap["validUntil"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "validUntil")
    }
  }
}

public struct EmailFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment EmailFragment on Email {
      __typename
      address
      verified
    }
    """

  public static let possibleTypes: [String] = ["Email"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("address", type: .nonNull(.scalar(String.self))),
      GraphQLField("verified", type: .scalar(Bool.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(address: String, verified: Bool? = nil) {
    self.init(unsafeResultMap: ["__typename": "Email", "address": address, "verified": verified])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var address: String {
    get {
      return resultMap["address"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "address")
    }
  }

  public var verified: Bool? {
    get {
      return resultMap["verified"] as? Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "verified")
    }
  }
}

public struct IncomingSourcesFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment IncomingSourcesFragment on IncomingSources {
      __typename
      salary
      other
    }
    """

  public static let possibleTypes: [String] = ["IncomingSources"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("salary", type: .nonNull(.scalar(Bool.self))),
      GraphQLField("other", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(salary: Bool, other: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "IncomingSources", "salary": salary, "other": other])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var salary: Bool {
    get {
      return resultMap["salary"]! as! Bool
    }
    set {
      resultMap.updateValue(newValue, forKey: "salary")
    }
  }

  public var other: String? {
    get {
      return resultMap["other"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "other")
    }
  }
}

public struct IndividualFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment IndividualFragment on Individual {
      __typename
      legalName {
        __typename
        ...NameFragment
      }
      birthName {
        __typename
        ...NameFragment
      }
      birthData {
        __typename
        countryOfBirth
        placeOfBirth
        dateOfBirth
        motherName
      }
      legalAddress {
        __typename
        ...AddressFragment
      }
      correspondenceAddress {
        __typename
        ...AddressFragment
      }
      identityCardDocument {
        __typename
        ...DocumentFragment
      }
      addressCardDocument {
        __typename
        ...DocumentFragment
      }
      mainEmail {
        __typename
        ...EmailFragment
      }
      mobilePhone {
        __typename
        ...PhoneFragment
      }
    }
    """

  public static let possibleTypes: [String] = ["Individual"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("legalName", type: .object(LegalName.selections)),
      GraphQLField("birthName", type: .object(BirthName.selections)),
      GraphQLField("birthData", type: .object(BirthDatum.selections)),
      GraphQLField("legalAddress", type: .object(LegalAddress.selections)),
      GraphQLField("correspondenceAddress", type: .object(CorrespondenceAddress.selections)),
      GraphQLField("identityCardDocument", type: .object(IdentityCardDocument.selections)),
      GraphQLField("addressCardDocument", type: .object(AddressCardDocument.selections)),
      GraphQLField("mainEmail", type: .nonNull(.object(MainEmail.selections))),
      GraphQLField("mobilePhone", type: .nonNull(.object(MobilePhone.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(legalName: LegalName? = nil, birthName: BirthName? = nil, birthData: BirthDatum? = nil, legalAddress: LegalAddress? = nil, correspondenceAddress: CorrespondenceAddress? = nil, identityCardDocument: IdentityCardDocument? = nil, addressCardDocument: AddressCardDocument? = nil, mainEmail: MainEmail, mobilePhone: MobilePhone) {
    self.init(unsafeResultMap: ["__typename": "Individual", "legalName": legalName.flatMap { (value: LegalName) -> ResultMap in value.resultMap }, "birthName": birthName.flatMap { (value: BirthName) -> ResultMap in value.resultMap }, "birthData": birthData.flatMap { (value: BirthDatum) -> ResultMap in value.resultMap }, "legalAddress": legalAddress.flatMap { (value: LegalAddress) -> ResultMap in value.resultMap }, "correspondenceAddress": correspondenceAddress.flatMap { (value: CorrespondenceAddress) -> ResultMap in value.resultMap }, "identityCardDocument": identityCardDocument.flatMap { (value: IdentityCardDocument) -> ResultMap in value.resultMap }, "addressCardDocument": addressCardDocument.flatMap { (value: AddressCardDocument) -> ResultMap in value.resultMap }, "mainEmail": mainEmail.resultMap, "mobilePhone": mobilePhone.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var legalName: LegalName? {
    get {
      return (resultMap["legalName"] as? ResultMap).flatMap { LegalName(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "legalName")
    }
  }

  public var birthName: BirthName? {
    get {
      return (resultMap["birthName"] as? ResultMap).flatMap { BirthName(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "birthName")
    }
  }

  public var birthData: BirthDatum? {
    get {
      return (resultMap["birthData"] as? ResultMap).flatMap { BirthDatum(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "birthData")
    }
  }

  public var legalAddress: LegalAddress? {
    get {
      return (resultMap["legalAddress"] as? ResultMap).flatMap { LegalAddress(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "legalAddress")
    }
  }

  public var correspondenceAddress: CorrespondenceAddress? {
    get {
      return (resultMap["correspondenceAddress"] as? ResultMap).flatMap { CorrespondenceAddress(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "correspondenceAddress")
    }
  }

  public var identityCardDocument: IdentityCardDocument? {
    get {
      return (resultMap["identityCardDocument"] as? ResultMap).flatMap { IdentityCardDocument(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "identityCardDocument")
    }
  }

  public var addressCardDocument: AddressCardDocument? {
    get {
      return (resultMap["addressCardDocument"] as? ResultMap).flatMap { AddressCardDocument(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "addressCardDocument")
    }
  }

  public var mainEmail: MainEmail {
    get {
      return MainEmail(unsafeResultMap: resultMap["mainEmail"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "mainEmail")
    }
  }

  public var mobilePhone: MobilePhone {
    get {
      return MobilePhone(unsafeResultMap: resultMap["mobilePhone"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "mobilePhone")
    }
  }

  public struct LegalName: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Name"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(NameFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(firstName: String, lastName: String) {
      self.init(unsafeResultMap: ["__typename": "Name", "firstName": firstName, "lastName": lastName])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var nameFragment: NameFragment {
        get {
          return NameFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct BirthName: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Name"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(NameFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(firstName: String, lastName: String) {
      self.init(unsafeResultMap: ["__typename": "Name", "firstName": firstName, "lastName": lastName])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var nameFragment: NameFragment {
        get {
          return NameFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct BirthDatum: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["BirthData"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("countryOfBirth", type: .scalar(String.self)),
        GraphQLField("placeOfBirth", type: .scalar(String.self)),
        GraphQLField("dateOfBirth", type: .scalar(String.self)),
        GraphQLField("motherName", type: .scalar(String.self)),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(countryOfBirth: String? = nil, placeOfBirth: String? = nil, dateOfBirth: String? = nil, motherName: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "BirthData", "countryOfBirth": countryOfBirth, "placeOfBirth": placeOfBirth, "dateOfBirth": dateOfBirth, "motherName": motherName])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var countryOfBirth: String? {
      get {
        return resultMap["countryOfBirth"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "countryOfBirth")
      }
    }

    public var placeOfBirth: String? {
      get {
        return resultMap["placeOfBirth"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "placeOfBirth")
      }
    }

    public var dateOfBirth: String? {
      get {
        return resultMap["dateOfBirth"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "dateOfBirth")
      }
    }

    public var motherName: String? {
      get {
        return resultMap["motherName"] as? String
      }
      set {
        resultMap.updateValue(newValue, forKey: "motherName")
      }
    }
  }

  public struct LegalAddress: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Address"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(AddressFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(city: String, country: String, houseNumber: String, postCode: String, streetName: String) {
      self.init(unsafeResultMap: ["__typename": "Address", "city": city, "country": country, "houseNumber": houseNumber, "postCode": postCode, "streetName": streetName])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var addressFragment: AddressFragment {
        get {
          return AddressFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct CorrespondenceAddress: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Address"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(AddressFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(city: String, country: String, houseNumber: String, postCode: String, streetName: String) {
      self.init(unsafeResultMap: ["__typename": "Address", "city": city, "country": country, "houseNumber": houseNumber, "postCode": postCode, "streetName": streetName])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var addressFragment: AddressFragment {
        get {
          return AddressFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct IdentityCardDocument: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Document"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(DocumentFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(serial: String, type: DocumentType, validUntil: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Document", "serial": serial, "type": type, "validUntil": validUntil])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var documentFragment: DocumentFragment {
        get {
          return DocumentFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct AddressCardDocument: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Document"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(DocumentFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(serial: String, type: DocumentType, validUntil: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Document", "serial": serial, "type": type, "validUntil": validUntil])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var documentFragment: DocumentFragment {
        get {
          return DocumentFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct MainEmail: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Email"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(EmailFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(address: String, verified: Bool? = nil) {
      self.init(unsafeResultMap: ["__typename": "Email", "address": address, "verified": verified])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var emailFragment: EmailFragment {
        get {
          return EmailFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct MobilePhone: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Phone"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(PhoneFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(fullPhoneNumber: String) {
      self.init(unsafeResultMap: ["__typename": "Phone", "fullPhoneNumber": fullPhoneNumber])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var phoneFragment: PhoneFragment {
        get {
          return PhoneFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct KycSurveyFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment KycSurveyFragment on KycSurvey {
      __typename
      incomingSources {
        __typename
        ...IncomingSourcesFragment
      }
      depositPlan {
        __typename
        ...PlanFragment
      }
      transferPlan {
        __typename
        ...PlanFragment
      }
    }
    """

  public static let possibleTypes: [String] = ["KycSurvey"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("incomingSources", type: .object(IncomingSource.selections)),
      GraphQLField("depositPlan", type: .object(DepositPlan.selections)),
      GraphQLField("transferPlan", type: .object(TransferPlan.selections)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(incomingSources: IncomingSource? = nil, depositPlan: DepositPlan? = nil, transferPlan: TransferPlan? = nil) {
    self.init(unsafeResultMap: ["__typename": "KycSurvey", "incomingSources": incomingSources.flatMap { (value: IncomingSource) -> ResultMap in value.resultMap }, "depositPlan": depositPlan.flatMap { (value: DepositPlan) -> ResultMap in value.resultMap }, "transferPlan": transferPlan.flatMap { (value: TransferPlan) -> ResultMap in value.resultMap }])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var incomingSources: IncomingSource? {
    get {
      return (resultMap["incomingSources"] as? ResultMap).flatMap { IncomingSource(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "incomingSources")
    }
  }

  public var depositPlan: DepositPlan? {
    get {
      return (resultMap["depositPlan"] as? ResultMap).flatMap { DepositPlan(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "depositPlan")
    }
  }

  public var transferPlan: TransferPlan? {
    get {
      return (resultMap["transferPlan"] as? ResultMap).flatMap { TransferPlan(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "transferPlan")
    }
  }

  public struct IncomingSource: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["IncomingSources"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(IncomingSourcesFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(salary: Bool, other: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "IncomingSources", "salary": salary, "other": other])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var incomingSourcesFragment: IncomingSourcesFragment {
        get {
          return IncomingSourcesFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct DepositPlan: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Plan"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(PlanFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(amountFrom: Int? = nil, amountTo: Int? = nil, currency: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Plan", "amountFrom": amountFrom, "amountTo": amountTo, "currency": currency])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var planFragment: PlanFragment {
        get {
          return PlanFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct TransferPlan: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Plan"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(PlanFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(amountFrom: Int? = nil, amountTo: Int? = nil, currency: String? = nil) {
      self.init(unsafeResultMap: ["__typename": "Plan", "amountFrom": amountFrom, "amountTo": amountTo, "currency": currency])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var planFragment: PlanFragment {
        get {
          return PlanFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct MoneyFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment MoneyFragment on Money {
      __typename
      amount
      currencyCode
    }
    """

  public static let possibleTypes: [String] = ["Money"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("amount", type: .nonNull(.scalar(String.self))),
      GraphQLField("currencyCode", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(amount: String, currencyCode: String) {
    self.init(unsafeResultMap: ["__typename": "Money", "amount": amount, "currencyCode": currencyCode])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var amount: String {
    get {
      return resultMap["amount"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "amount")
    }
  }

  public var currencyCode: String {
    get {
      return resultMap["currencyCode"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "currencyCode")
    }
  }
}

public struct NameFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment NameFragment on Name {
      __typename
      firstName
      lastName
    }
    """

  public static let possibleTypes: [String] = ["Name"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("firstName", type: .nonNull(.scalar(String.self))),
      GraphQLField("lastName", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(firstName: String, lastName: String) {
    self.init(unsafeResultMap: ["__typename": "Name", "firstName": firstName, "lastName": lastName])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var firstName: String {
    get {
      return resultMap["firstName"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "firstName")
    }
  }

  public var lastName: String {
    get {
      return resultMap["lastName"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "lastName")
    }
  }
}

public struct OtpInfoFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment OtpInfoFragment on OtpInfo {
      __typename
      expireInterval
      nextRequestInterval
    }
    """

  public static let possibleTypes: [String] = ["OtpInfo"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("expireInterval", type: .nonNull(.scalar(Double.self))),
      GraphQLField("nextRequestInterval", type: .nonNull(.scalar(Double.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(expireInterval: Double, nextRequestInterval: Double) {
    self.init(unsafeResultMap: ["__typename": "OtpInfo", "expireInterval": expireInterval, "nextRequestInterval": nextRequestInterval])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var expireInterval: Double {
    get {
      return resultMap["expireInterval"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "expireInterval")
    }
  }

  public var nextRequestInterval: Double {
    get {
      return resultMap["nextRequestInterval"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "nextRequestInterval")
    }
  }
}

public struct ParticipantFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ParticipantFragment on Participant {
      __typename
      name
      account {
        __typename
        identificationType
        identification
      }
    }
    """

  public static let possibleTypes: [String] = ["Debtor", "Creditor"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("account", type: .nonNull(.object(Account.selections))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public static func makeDebtor(name: String, account: Account) -> ParticipantFragment {
    return ParticipantFragment(unsafeResultMap: ["__typename": "Debtor", "name": name, "account": account.resultMap])
  }

  public static func makeCreditor(name: String, account: Account) -> ParticipantFragment {
    return ParticipantFragment(unsafeResultMap: ["__typename": "Creditor", "name": name, "account": account.resultMap])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var name: String {
    get {
      return resultMap["name"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var account: Account {
    get {
      return Account(unsafeResultMap: resultMap["account"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "account")
    }
  }

  public struct Account: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["PTAccount"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLField("identificationType", type: .nonNull(.scalar(IdentificationType.self))),
        GraphQLField("identification", type: .nonNull(.scalar(String.self))),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(identificationType: IdentificationType, identification: String) {
      self.init(unsafeResultMap: ["__typename": "PTAccount", "identificationType": identificationType, "identification": identification])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var identificationType: IdentificationType {
      get {
        return resultMap["identificationType"]! as! IdentificationType
      }
      set {
        resultMap.updateValue(newValue, forKey: "identificationType")
      }
    }

    public var identification: String {
      get {
        return resultMap["identification"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "identification")
      }
    }
  }
}

public struct PaymentTransactionFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment PaymentTransactionFragment on PaymentTransaction {
      __typename
      money {
        __typename
        ...MoneyFragment
      }
      fee {
        __typename
        ...MoneyFragment
      }
      debtor {
        __typename
        ...ParticipantFragment
      }
      creditor {
        __typename
        ...ParticipantFragment
      }
      paymentReference
      direction
      status
      id
      createdAt
      settlementDate
      rejectionReason
    }
    """

  public static let possibleTypes: [String] = ["PaymentTransaction"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("money", type: .nonNull(.object(Money.selections))),
      GraphQLField("fee", type: .object(Fee.selections)),
      GraphQLField("debtor", type: .nonNull(.object(Debtor.selections))),
      GraphQLField("creditor", type: .nonNull(.object(Creditor.selections))),
      GraphQLField("paymentReference", type: .scalar(String.self)),
      GraphQLField("direction", type: .nonNull(.scalar(PaymentTransactionDirection.self))),
      GraphQLField("status", type: .nonNull(.scalar(PaymentTransactionStatus.self))),
      GraphQLField("id", type: .nonNull(.scalar(GraphQLID.self))),
      GraphQLField("createdAt", type: .nonNull(.scalar(String.self))),
      GraphQLField("settlementDate", type: .scalar(String.self)),
      GraphQLField("rejectionReason", type: .scalar(RejectionReason.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(money: Money, fee: Fee? = nil, debtor: Debtor, creditor: Creditor, paymentReference: String? = nil, direction: PaymentTransactionDirection, status: PaymentTransactionStatus, id: GraphQLID, createdAt: String, settlementDate: String? = nil, rejectionReason: RejectionReason? = nil) {
    self.init(unsafeResultMap: ["__typename": "PaymentTransaction", "money": money.resultMap, "fee": fee.flatMap { (value: Fee) -> ResultMap in value.resultMap }, "debtor": debtor.resultMap, "creditor": creditor.resultMap, "paymentReference": paymentReference, "direction": direction, "status": status, "id": id, "createdAt": createdAt, "settlementDate": settlementDate, "rejectionReason": rejectionReason])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var money: Money {
    get {
      return Money(unsafeResultMap: resultMap["money"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "money")
    }
  }

  public var fee: Fee? {
    get {
      return (resultMap["fee"] as? ResultMap).flatMap { Fee(unsafeResultMap: $0) }
    }
    set {
      resultMap.updateValue(newValue?.resultMap, forKey: "fee")
    }
  }

  public var debtor: Debtor {
    get {
      return Debtor(unsafeResultMap: resultMap["debtor"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "debtor")
    }
  }

  public var creditor: Creditor {
    get {
      return Creditor(unsafeResultMap: resultMap["creditor"]! as! ResultMap)
    }
    set {
      resultMap.updateValue(newValue.resultMap, forKey: "creditor")
    }
  }

  public var paymentReference: String? {
    get {
      return resultMap["paymentReference"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "paymentReference")
    }
  }

  public var direction: PaymentTransactionDirection {
    get {
      return resultMap["direction"]! as! PaymentTransactionDirection
    }
    set {
      resultMap.updateValue(newValue, forKey: "direction")
    }
  }

  public var status: PaymentTransactionStatus {
    get {
      return resultMap["status"]! as! PaymentTransactionStatus
    }
    set {
      resultMap.updateValue(newValue, forKey: "status")
    }
  }

  public var id: GraphQLID {
    get {
      return resultMap["id"]! as! GraphQLID
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var createdAt: String {
    get {
      return resultMap["createdAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "createdAt")
    }
  }

  public var settlementDate: String? {
    get {
      return resultMap["settlementDate"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "settlementDate")
    }
  }

  public var rejectionReason: RejectionReason? {
    get {
      return resultMap["rejectionReason"] as? RejectionReason
    }
    set {
      resultMap.updateValue(newValue, forKey: "rejectionReason")
    }
  }

  public struct Money: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Money"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MoneyFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(amount: String, currencyCode: String) {
      self.init(unsafeResultMap: ["__typename": "Money", "amount": amount, "currencyCode": currencyCode])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var moneyFragment: MoneyFragment {
        get {
          return MoneyFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Fee: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Money"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(MoneyFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public init(amount: String, currencyCode: String) {
      self.init(unsafeResultMap: ["__typename": "Money", "amount": amount, "currencyCode": currencyCode])
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var moneyFragment: MoneyFragment {
        get {
          return MoneyFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Debtor: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Debtor"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ParticipantFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var participantFragment: ParticipantFragment {
        get {
          return ParticipantFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }

  public struct Creditor: GraphQLSelectionSet {
    public static let possibleTypes: [String] = ["Creditor"]

    public static var selections: [GraphQLSelection] {
      return [
        GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
        GraphQLFragmentSpread(ParticipantFragment.self),
      ]
    }

    public private(set) var resultMap: ResultMap

    public init(unsafeResultMap: ResultMap) {
      self.resultMap = unsafeResultMap
    }

    public var __typename: String {
      get {
        return resultMap["__typename"]! as! String
      }
      set {
        resultMap.updateValue(newValue, forKey: "__typename")
      }
    }

    public var fragments: Fragments {
      get {
        return Fragments(unsafeResultMap: resultMap)
      }
      set {
        resultMap += newValue.resultMap
      }
    }

    public struct Fragments {
      public private(set) var resultMap: ResultMap

      public init(unsafeResultMap: ResultMap) {
        self.resultMap = unsafeResultMap
      }

      public var participantFragment: ParticipantFragment {
        get {
          return ParticipantFragment(unsafeResultMap: resultMap)
        }
        set {
          resultMap += newValue.resultMap
        }
      }
    }
  }
}

public struct PhoneFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment PhoneFragment on Phone {
      __typename
      fullPhoneNumber
    }
    """

  public static let possibleTypes: [String] = ["Phone"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("fullPhoneNumber", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(fullPhoneNumber: String) {
    self.init(unsafeResultMap: ["__typename": "Phone", "fullPhoneNumber": fullPhoneNumber])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var fullPhoneNumber: String {
    get {
      return resultMap["fullPhoneNumber"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "fullPhoneNumber")
    }
  }
}

public struct PlanFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment PlanFragment on Plan {
      __typename
      amountFrom
      amountTo
      currency
    }
    """

  public static let possibleTypes: [String] = ["Plan"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("amountFrom", type: .scalar(Int.self)),
      GraphQLField("amountTo", type: .scalar(Int.self)),
      GraphQLField("currency", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(amountFrom: Int? = nil, amountTo: Int? = nil, currency: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Plan", "amountFrom": amountFrom, "amountTo": amountTo, "currency": currency])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var amountFrom: Int? {
    get {
      return resultMap["amountFrom"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "amountFrom")
    }
  }

  public var amountTo: Int? {
    get {
      return resultMap["amountTo"] as? Int
    }
    set {
      resultMap.updateValue(newValue, forKey: "amountTo")
    }
  }

  public var currency: String? {
    get {
      return resultMap["currency"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "currency")
    }
  }
}

public struct ScaChallengeFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment ScaChallengeFragment on ScaChallenge {
      __typename
      id
      userId
      cardToken
      merchant
      amount
      currency
      challengedAt
      expiresAfter
      status
      lastDigits
    }
    """

  public static let possibleTypes: [String] = ["ScaChallenge"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("id", type: .nonNull(.scalar(String.self))),
      GraphQLField("userId", type: .nonNull(.scalar(String.self))),
      GraphQLField("cardToken", type: .nonNull(.scalar(String.self))),
      GraphQLField("merchant", type: .nonNull(.scalar(String.self))),
      GraphQLField("amount", type: .nonNull(.scalar(String.self))),
      GraphQLField("currency", type: .nonNull(.scalar(String.self))),
      GraphQLField("challengedAt", type: .nonNull(.scalar(String.self))),
      GraphQLField("expiresAfter", type: .nonNull(.scalar(Double.self))),
      GraphQLField("status", type: .nonNull(.scalar(ScaChallengeStatus.self))),
      GraphQLField("lastDigits", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(id: String, userId: String, cardToken: String, merchant: String, amount: String, currency: String, challengedAt: String, expiresAfter: Double, status: ScaChallengeStatus, lastDigits: String) {
    self.init(unsafeResultMap: ["__typename": "ScaChallenge", "id": id, "userId": userId, "cardToken": cardToken, "merchant": merchant, "amount": amount, "currency": currency, "challengedAt": challengedAt, "expiresAfter": expiresAfter, "status": status, "lastDigits": lastDigits])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var id: String {
    get {
      return resultMap["id"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "id")
    }
  }

  public var userId: String {
    get {
      return resultMap["userId"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "userId")
    }
  }

  public var cardToken: String {
    get {
      return resultMap["cardToken"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "cardToken")
    }
  }

  public var merchant: String {
    get {
      return resultMap["merchant"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "merchant")
    }
  }

  public var amount: String {
    get {
      return resultMap["amount"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "amount")
    }
  }

  public var currency: String {
    get {
      return resultMap["currency"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "currency")
    }
  }

  public var challengedAt: String {
    get {
      return resultMap["challengedAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "challengedAt")
    }
  }

  public var expiresAfter: Double {
    get {
      return resultMap["expiresAfter"]! as! Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "expiresAfter")
    }
  }

  public var status: ScaChallengeStatus {
    get {
      return resultMap["status"]! as! ScaChallengeStatus
    }
    set {
      resultMap.updateValue(newValue, forKey: "status")
    }
  }

  public var lastDigits: String {
    get {
      return resultMap["lastDigits"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "lastDigits")
    }
  }
}

public struct SecureFlowFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment SecureFlowFragment on SecureFlowResponse {
      __typename
      iv
      data
    }
    """

  public static let possibleTypes: [String] = ["SecureFlowResponse"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("iv", type: .nonNull(.scalar(String.self))),
      GraphQLField("data", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(iv: String, data: String) {
    self.init(unsafeResultMap: ["__typename": "SecureFlowResponse", "iv": iv, "data": data])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var iv: String {
    get {
      return resultMap["iv"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "iv")
    }
  }

  public var data: String {
    get {
      return resultMap["data"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "data")
    }
  }
}

public struct StatementFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment StatementFragment on Statement {
      __typename
      statementId
      periodStart
      periodEnd
    }
    """

  public static let possibleTypes: [String] = ["Statement"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("statementId", type: .nonNull(.scalar(String.self))),
      GraphQLField("periodStart", type: .nonNull(.scalar(String.self))),
      GraphQLField("periodEnd", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(statementId: String, periodStart: String, periodEnd: String) {
    self.init(unsafeResultMap: ["__typename": "Statement", "statementId": statementId, "periodStart": periodStart, "periodEnd": periodEnd])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  /// Uuid v4
  public var statementId: String {
    get {
      return resultMap["statementId"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "statementId")
    }
  }

  /// Date(Format: YYYY-MM-DD)
  public var periodStart: String {
    get {
      return resultMap["periodStart"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "periodStart")
    }
  }

  /// Date(Format: YYYY-MM-DD)
  public var periodEnd: String {
    get {
      return resultMap["periodEnd"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "periodEnd")
    }
  }
}

public struct TaxationFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment TaxationFragment on Taxation {
      __typename
      country
      taxNumber
    }
    """

  public static let possibleTypes: [String] = ["Taxation"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("country", type: .nonNull(.scalar(String.self))),
      GraphQLField("taxNumber", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(country: String, taxNumber: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Taxation", "country": country, "taxNumber": taxNumber])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var country: String {
    get {
      return resultMap["country"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "country")
    }
  }

  public var taxNumber: String? {
    get {
      return resultMap["taxNumber"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "taxNumber")
    }
  }
}

public struct TokenFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment TokenFragment on LoginResponse {
      __typename
      accessToken
      refreshToken
    }
    """

  public static let possibleTypes: [String] = ["LoginResponse"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("accessToken", type: .nonNull(.scalar(String.self))),
      GraphQLField("refreshToken", type: .nonNull(.scalar(String.self))),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(accessToken: String, refreshToken: String) {
    self.init(unsafeResultMap: ["__typename": "LoginResponse", "accessToken": accessToken, "refreshToken": refreshToken])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var accessToken: String {
    get {
      return resultMap["accessToken"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "accessToken")
    }
  }

  public var refreshToken: String {
    get {
      return resultMap["refreshToken"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "refreshToken")
    }
  }
}

public struct UserContractFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment UserContractFragment on Contract {
      __typename
      name
      contractId
      signedAt
      acceptedAt
      uploadedAt
    }
    """

  public static let possibleTypes: [String] = ["Contract"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("name", type: .nonNull(.scalar(String.self))),
      GraphQLField("contractId", type: .nonNull(.scalar(String.self))),
      GraphQLField("signedAt", type: .nonNull(.scalar(String.self))),
      GraphQLField("acceptedAt", type: .nonNull(.scalar(String.self))),
      GraphQLField("uploadedAt", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(name: String, contractId: String, signedAt: String, acceptedAt: String, uploadedAt: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "Contract", "name": name, "contractId": contractId, "signedAt": signedAt, "acceptedAt": acceptedAt, "uploadedAt": uploadedAt])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var name: String {
    get {
      return resultMap["name"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var contractId: String {
    get {
      return resultMap["contractId"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "contractId")
    }
  }

  public var signedAt: String {
    get {
      return resultMap["signedAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "signedAt")
    }
  }

  public var acceptedAt: String {
    get {
      return resultMap["acceptedAt"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "acceptedAt")
    }
  }

  public var uploadedAt: String? {
    get {
      return resultMap["uploadedAt"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "uploadedAt")
    }
  }
}

public struct UserTransactionErrorFragment: GraphQLFragment {
  /// The raw GraphQL definition of this fragment.
  public static let fragmentDefinition: String =
    """
    fragment UserTransactionErrorFragment on UserTransactionError {
      __typename
      code
      error
      message
      name
      sourceService
      stack
      statusCode
      type
    }
    """

  public static let possibleTypes: [String] = ["UserTransactionError"]

  public static var selections: [GraphQLSelection] {
    return [
      GraphQLField("__typename", type: .nonNull(.scalar(String.self))),
      GraphQLField("code", type: .scalar(String.self)),
      GraphQLField("error", type: .scalar(String.self)),
      GraphQLField("message", type: .scalar(String.self)),
      GraphQLField("name", type: .scalar(String.self)),
      GraphQLField("sourceService", type: .nonNull(.scalar(String.self))),
      GraphQLField("stack", type: .scalar(String.self)),
      GraphQLField("statusCode", type: .scalar(Double.self)),
      GraphQLField("type", type: .scalar(String.self)),
    ]
  }

  public private(set) var resultMap: ResultMap

  public init(unsafeResultMap: ResultMap) {
    self.resultMap = unsafeResultMap
  }

  public init(code: String? = nil, error: String? = nil, message: String? = nil, name: String? = nil, sourceService: String, stack: String? = nil, statusCode: Double? = nil, type: String? = nil) {
    self.init(unsafeResultMap: ["__typename": "UserTransactionError", "code": code, "error": error, "message": message, "name": name, "sourceService": sourceService, "stack": stack, "statusCode": statusCode, "type": type])
  }

  public var __typename: String {
    get {
      return resultMap["__typename"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "__typename")
    }
  }

  public var code: String? {
    get {
      return resultMap["code"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "code")
    }
  }

  public var error: String? {
    get {
      return resultMap["error"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "error")
    }
  }

  public var message: String? {
    get {
      return resultMap["message"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "message")
    }
  }

  public var name: String? {
    get {
      return resultMap["name"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "name")
    }
  }

  public var sourceService: String {
    get {
      return resultMap["sourceService"]! as! String
    }
    set {
      resultMap.updateValue(newValue, forKey: "sourceService")
    }
  }

  public var stack: String? {
    get {
      return resultMap["stack"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "stack")
    }
  }

  public var statusCode: Double? {
    get {
      return resultMap["statusCode"] as? Double
    }
    set {
      resultMap.updateValue(newValue, forKey: "statusCode")
    }
  }

  public var type: String? {
    get {
      return resultMap["type"] as? String
    }
    set {
      resultMap.updateValue(newValue, forKey: "type")
    }
  }
}
