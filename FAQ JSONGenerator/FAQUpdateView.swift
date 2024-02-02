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
        Group {
            if router.fAQ != nil {
                Form {
                    TextField("Question", text: $model.question)
                    TextField("Answer", text: $model.answer)
                    Picker("Level", selection: $model.level) {
                        ForEach(1..<6, id: \.self) { level in
                            Text("Level \(level)").tag(level)
                        }
                    }
                    Picker("Link Type", selection: $model.linkType) {
                        ForEach(LinkType.allCases) { linkType in
                            Text(linkType.rawValue).tag(linkType)
                        }
                    }
                    if model.linkType != .none {
                        TextField("Link Title", text: $model.linkTitle)
                        TextField("URL", text: $model.linkURL)
                        
                    }
                    if changed {
                        Button("Update") {
                            let didChangeLevel = router.fAQ?.level != model.level
                            router.didChangeLevel = didChangeLevel
                            print("Level changed: \(didChangeLevel)")
                            router.fAQ?.question = model.question
                            router.fAQ?.answer = model.answer
                            router.fAQ?.level = model.level
                            router.fAQ?.linkType = model.linkType.rawValue
                            if model.linkType == .none {
                                router.fAQ?.link = nil
                            } else {
                                router.fAQ?.link?.title = model.linkTitle
                                router.fAQ?.link?.url = model.linkURL
                            }
                            router.fAQ = nil
                        }
                    }
                }
            } else {
                ContentUnavailableView("Select FAQ", systemImage: "diamond")
            }
        }
        .toolbar {
            Button("") {
                
            }
        }
        .onChange(of: router.fAQ) {
            if let fAQ = router.fAQ {
                model.question = fAQ.question
                model.answer = fAQ.answer
                model.level = fAQ.level
                model.linkType = fAQ.linkTypeEnum
                model.linkTitle = fAQ.link?.title ?? ""
                model.linkURL = fAQ.link?.url ?? ""
            }
        }
    }
    
    var changed: Bool {
        router.fAQ?.question != model.question ||
        router.fAQ?.answer != model.answer ||
        router.fAQ?.level != model.level ||
        router.fAQ?.linkType != model.linkType.rawValue
        
    }

    
}

#Preview {
    let container = Application.preview
    let fetchDescriptor = FetchDescriptor<Application>()
    let application = try! container.mainContext.fetch(fetchDescriptor)[0]
    let faq = application.faqs[0]
    let router = Router()
    router.fAQ = faq
    return FAQUpdateView(model: FAQFormModel())
        .environment(router)
}
