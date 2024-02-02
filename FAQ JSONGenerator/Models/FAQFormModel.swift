//
// Created for FAQ JSONGenerator
// by  Stewart Lynch on 2024-02-01
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import SwiftUI

@Observable
class FAQFormModel {
    var level: Int = 1
    var question: String = ""
    var answer: String = ""
    var linkType: String = LinkType.none.rawValue
    var linkTitle: String = ""
    var linkURL: String = ""
    
    var linkTypeEnum: LinkType {
        LinkType(rawValue: linkType) ?? .none
    }
    
    var fAQ: FAQ?
    var application: Application?
    
    var updating: Bool {
        fAQ != nil
    }
    
    init(application: Application) {
       // new
        self.application = application
    }
    
    init(fAQ: FAQ?) {
        self.fAQ = fAQ
        self.level = fAQ?.level ?? 1
        self.question = fAQ?.question ?? ""
        self.answer = fAQ?.answer ?? ""
        self.linkType = fAQ?.linkType ?? LinkType.none.rawValue
        self.linkTitle = fAQ?.link?.title ?? ""
        self.linkURL = fAQ?.link?.url ?? ""
    }
}
