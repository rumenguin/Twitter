//
//  Tweet.swift
//  TwitterClone
//
//  Created by RUMEN GUIN on 31/03/23.
//

import Foundation
import Firebase

struct Tweet: Codable {
    var id = UUID().uuidString
    let author: TwitterUser
    let tweetContent: String
    var likesCount: Int
    var likers: [String]
    let isReply: Bool
    let parentReference: String?
}
