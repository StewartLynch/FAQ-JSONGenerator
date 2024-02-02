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
import SwiftData

struct FAQUpdateView: View {
    @Environment(Router.self) var router
    @State var model: FAQFormModel
    
    var body: some View {
//        if router.fAQ != nil {
            if model.fAQ != nil {
                    Form {
                        TextField("Question", text: $model.question)
                        TextField("Answer", text: $model.answer)
                        Picker("Link Type", selection: $model.linkType) {
                            ForEach(LinkType.allCases) { linkType in
                                Text(linkType.rawValue).tag(linkType.rawValue)
                            }
                        }
                        if model.linkTypeEnum != .none {
                            TextField("Link Title", text: $model.linkTitle)
                            TextField("URL", text: $model.linkURL)
                            
                        }
                    }
//                }
        } else {
            ContentUnavailableView("Select FAQ", systemImage: "diamond")
        }
    }
    
        
    
}

#Preview {
    let container = Application.preview
    let fetchDescriptor = FetchDescriptor<Application>()
    let application = try! container.mainContext.fetch(fetchDescriptor)[0]
    let faq = application.faqs[0]
    return FAQUpdateView(model: FAQFormModel(fAQ: faq))
        .environment(Router())
}
