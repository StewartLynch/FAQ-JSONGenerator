//
// Created for FAQ JSONGenerator
// by  Stewart Lynch on 2024-02-03
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import Foundation

struct ExportJSON: Codable {
    var faqs: [FAQ]
    
    struct FAQ: Codable {
        var level: Int
        var sortOrder: Int
        var question: String
        var answer: String
        var linkType: String
        var link: Link?
    }
    
    struct Link: Codable {
        var title: String
        var url: String
    }
}
