//
//  Session.swift
//  TestingApp
//
//  Created by Adham Albanna on 24/03/2022.
//

import Foundation

struct Session: Codable {
    let id, userID: String
    let verified: Bool
    let date, expiresAt: Int

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case userID = "userId"
        case verified, date, expiresAt
    }
}
