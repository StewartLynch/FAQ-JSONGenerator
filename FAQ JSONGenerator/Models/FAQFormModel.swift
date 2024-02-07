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

struct FAQFormModel {
    var level: Int = 1
    var question: String = ""
    var answer: String = ""
    var linkType: LinkType = .none
    var linkTitle: String = ""
    var linkURL: String = ""

    var application: Application?
    
    var isNew: Bool {
        application != nil
    }
    
    var disabled: Bool {
        question.isEmpty || answer.isEmpty || (
            linkType != .none && (
                linkTitle.isEmpty || linkURL.isEmpty
            )
        )
    }
    
    init(application: Application) {
       // new
        self.application = application
    }
    
    init() {

    }
}
