//
// Created for TripMapper
// by  Stewart Lynch on 2024-01-31
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import SwiftUI

struct FAQ: Codable, Identifiable, Hashable {
    struct Link: Codable, Hashable {
        var title: String
        var url: URL
    }

    
    enum FAQLinkType: String, Codable {
        case none
        case video = "Local Video"
        case weblink = "Local Link"
        case external = "External Link"
    }
    
    var levelString: String {
        switch level {
        case 1:
            "Level 1"
        case 2:
            "Level 2"
        default:
            "Extra"
        }
    }
    var id = UUID()
    let sortOrder: Int
    let level: Int
    let question: String
    let answer: String
    let linkType: String
    let link: Link?
    
    var qImage: String {
        if let  linkENum = FAQLinkType(rawValue: linkType) {
            switch linkENum {
            case .none:
                return "quote.opening"
            case .video:
               return  "video.fill"
            case .weblink:
                return "link"
            case .external:
                return "globe.americas.fill"
            }
        } else {
            return "quote.opening"
        }
    }
    enum CodingKeys: CodingKey {
        case sortOrder, level, question, answer, linkType, link
    }
}


