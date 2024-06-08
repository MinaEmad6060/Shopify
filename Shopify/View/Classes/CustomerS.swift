//
//  CustomerS.swift
//  Shopify
//
//  Created by Slsabel Hesham on 08/06/2024.
//

import Foundation

struct Customer: Codable {
    let id: Int
    let email: String
    let createdAt: String
    let updatedAt: String
    let firstName: String
    let lastName: String
    let ordersCount: Int
    let state: String
    let totalSpent: String
    let lastOrderId: Int?
    let note: String?
    let verifiedEmail: Bool
    let multipassIdentifier: String?
    let taxExempt: Bool
    let tags: String
    let lastOrderName: String?
    let currency: String
    let phone: String?
    let addresses: [String]
    let taxExemptions: [String]
    let emailMarketingConsentState: String
    let emailMarketingConsentOptInLevel: String
    let emailMarketingConsentConsentUpdatedAt: String?
    let smsMarketingConsent: String?
    let adminGraphqlApiId: String

    enum CodingKeys: String, CodingKey {
        case id
        case email
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case firstName = "first_name"
        case lastName = "last_name"
        case ordersCount = "orders_count"
        case state
        case totalSpent = "total_spent"
        case lastOrderId = "last_order_id"
        case note
        case verifiedEmail = "verified_email"
        case multipassIdentifier = "multipass_identifier"
        case taxExempt = "tax_exempt"
        case tags
        case lastOrderName = "last_order_name"
        case currency
        case phone
        case addresses
        case taxExemptions = "tax_exemptions"
        case emailMarketingConsentState = "email_marketing_consent.state"
        case emailMarketingConsentOptInLevel = "email_marketing_consent.opt_in_level"
        case emailMarketingConsentConsentUpdatedAt = "email_marketing_consent.consent_updated_at"
        case smsMarketingConsent = "sms_marketing_consent"
        case adminGraphqlApiId = "admin_graphql_api_id"
    }
}
