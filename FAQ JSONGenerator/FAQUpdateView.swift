//
// Created for FAQGenerator
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
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    
    var body: some View {
        Group {
            if router.appCount == 0 ||
                (router.appCount > 0 && router.application == nil &&  !model.isNew) ||
                router.appCount > 0 && router.application != nil && router.application!.faqs.isEmpty &&  !model.isNew {
                Image(.mac128)
            } else {
                if router.fAQ != nil || model.isNew {
                    VStack {
                        Form {
                            Section(header: Text("Question"))  {
                                TextEditor(text: $model.question)
                                    .frame(height: 100)
                            }
                            Section(header: Text("Answer")) {
                                TextEditor(text: $model.answer)
                                    .frame(height: 100)
                            }
                            Section(header: Text("Level")) {
                                Picker("", selection: $model.level) {
                                    ForEach(1..<6, id: \.self) { level in
                                        Text("Level \(level)").tag(level)
                                    }
                                }
                                .frame(width: 200)
                            }
                            Section(header: Text("Link Type")) {
                                Picker("", selection: $model.linkType) {
                                    ForEach(LinkType.allCases) { linkType in
                                        Text(linkType.rawValue).tag(linkType)
                                    }
                                }
                                .frame(width: 200)
                            }
                            
                            if model.linkType != .none {
                                Section(header: Text("Link Title")) {
                                    TextField("", text: $model.linkTitle)
                                        .frame(width: 400)
                                }
                                let text = switch model.linkType {
                                case .none: ""
                                case .video: "Video file name"
                                case .weblink: "html file/path name relative to application html folder"
                                case .external: "URL"
                                }
                                Section(header: Text(text)) {
                                    TextField("", text: $model.linkURL)
                                        .frame(width: 400)
                                }
                            }
                            
                            if !model.isNew {
                                HStack {
                                    Spacer()
                                    Button("Delete", systemImage: "trash", role: .destructive) {
                                        if let faq = router.fAQ, let application = router.application {
                                            router.fAQ = nil
                                            if let index = application.faqs.firstIndex(where: {$0.id == faq.id}) {
                                                application.faqs.remove(at: index)
                                            }
                                            router.needsListRefresh = true
                                        }
                                    }
                                    
                                    if changed {
                                        Button("Update") {
                                            let needsListRefresh = router.fAQ?.level != model.level
                                            router.needsListRefresh = needsListRefresh
                                            router.fAQ?.question = model.question
                                            router.fAQ?.answer = model.answer
                                            router.fAQ?.level = model.level
                                            router.fAQ?.linkType = model.linkType.rawValue
                                            if model.linkType == .none {
                                                router.fAQ?.link.title = ""
                                                router.fAQ?.link.url = ""
                                            } else {
                                                router.fAQ?.link.title = model.linkTitle
                                                router.fAQ?.link.url = model.linkURL
                                            }
                                            router.fAQ = nil
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                        Spacer()
                    }
                    .frame(width: 500)
                    .toolbar {
                        ToolbarItem {
                            Spacer()
                        }
                        if model.isNew {
                            ToolbarItem(placement: .cancellationAction) {
                                Button("Cancel") {
                                    dismiss()
                                }
                            }
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Add") {
                                    let newFAQ = FAQ(
                                        level: model.level,
                                        sortOrder: (router.application?.faqs.count ?? 0) + 1,
                                        question: model.question,
                                        answer: model.answer
                                    )
                                    newFAQ.linkType = model.linkType.rawValue
                                    if let application = router.application {
                                        application.faqs.append(newFAQ)
                                        try? modelContext.save()
                                    }
                                    if model.linkType != .none {
                                        newFAQ.link.title = model.linkTitle
                                        newFAQ.link.url = model.linkURL
                                    }
                                    dismiss()
                                }
                            }
                        }
                    }
                } else {
                    ContentUnavailableView("Select FAQ", systemImage: "hand.point.left.fill")
                }
            }
        }
        .onChange(of: router.fAQ) {
            if let fAQ = router.fAQ {
                model.question = fAQ.question
                model.answer = fAQ.answer
                model.level = fAQ.level
                model.linkType = fAQ.linkTypeEnum
                model.linkTitle = fAQ.link.title
                model.linkURL = fAQ.link.url
            }
        }
    }
    
    var changed: Bool {
        router.fAQ?.question != model.question ||
        router.fAQ?.answer != model.answer ||
        router.fAQ?.level != model.level ||
        router.fAQ?.linkType != model.linkType.rawValue ||
        router.fAQ?.link.title != model.linkTitle ||
        router.fAQ?.link.url != model.linkURL
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
