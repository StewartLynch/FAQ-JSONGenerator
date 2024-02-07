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

struct FAQFormView: View {
    @Environment(AppState.self) var appState
    @State var model: FAQFormModel
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        Group {
            if appState.appCount == 0 ||
                (appState.appCount > 0 && appState.application == nil &&  !model.isNew) ||
                appState.appCount > 0 && appState.application != nil && appState.application!.faqs.isEmpty &&  !model.isNew {
                Image(.mac128)
            } else {
                if appState.fAQ != nil || model.isNew {
                    VStack {
                        Form {
                            Section(header: Text("Question"))  {
                                TextField("", text: $model.question, axis: .vertical)
                            }
                            Section(header: Text("Answer")) {
                                TextField("", text: $model.answer, axis: .vertical)
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
                                case .image: "Image file name"
                                case .video: "Video file name"
                                case .weblink: "html file/path name relative to application html folder"
                                case .external: "URL"
                                }
                                Section(header: Text(text)) {
                                    TextField("", text: $model.linkURL)
                                        .frame(width: 400)
                                }
                            }
                            if model.isNew {
                                        HStack {
                                            Spacer()
                                            Button("Cancel") {
                                                dismiss()
                                            }
                                            Button("Add") {
                                                let newFAQ = FAQ_SD(
                                                    level: model.level,
                                                    sortOrder: (appState.application?.faqs.count ?? 0) + 1,
                                                    question: model.question,
                                                    answer: model.answer
                                                )
                                                newFAQ.linkType = model.linkType.rawValue
                                                if let application = appState.application {
                                                    application.faqs.append(newFAQ)
                                                    try? modelContext.save()
                                                }
                                                if model.linkType != .none {
                                                    newFAQ.link.title = model.linkTitle
                                                    newFAQ.link.url = model.linkURL
                                                }
                                                appState.needsListRefresh = true
                                                dismiss()
                                        }
                                            .buttonStyle(GreenButtonStyle(disabled: model.disabled))
                                            .disabled(model.disabled)
                                    }
                            }
                            if !model.isNew {
                                HStack {
                                    Spacer()
                                    if changed {
                                        Button("Cancel") {
                                            appState.fAQ = nil
                                        }
                                        Button("Update") {
                                            let needsListRefresh = appState.fAQ?.level != model.level
                                            appState.needsListRefresh = needsListRefresh
                                            appState.fAQ?.question = model.question
                                            appState.fAQ?.answer = model.answer
                                            appState.fAQ?.level = model.level
                                            appState.fAQ?.linkType = model.linkType.rawValue
                                            if model.linkType == .none {
                                                appState.fAQ?.link.title = ""
                                                appState.fAQ?.link.url = ""
                                            } else {
                                                appState.fAQ?.link.title = model.linkTitle
                                                appState.fAQ?.link.url = model.linkURL
                                            }
                                            appState.fAQ = nil
                                        }
                                        .buttonStyle(GreenButtonStyle(disabled: model.disabled))
                                        .disabled(model.disabled)
                                    }
                                }
                            }
                        }
                        .padding()
                        Spacer()
                    }
                    .frame(width: 500, height: 500)
                } else {
                    ContentUnavailableView("Select FAQ", systemImage: "hand.point.left.fill")
                }
            }
        }
        .onChange(of: appState.fAQ) {
            if let fAQ = appState.fAQ {
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
        appState.fAQ?.question != model.question ||
        appState.fAQ?.answer != model.answer ||
        appState.fAQ?.level != model.level ||
        appState.fAQ?.linkType != model.linkType.rawValue ||
        appState.fAQ?.link.title != model.linkTitle ||
        appState.fAQ?.link.url != model.linkURL
    }
    
}

#Preview {
    let container = Application.preview
    let fetchDescriptor = FetchDescriptor<Application>()
    let application = try! container.mainContext.fetch(fetchDescriptor)[0]
    let faq = application.faqs[0]
    let appState = AppState()
    appState.fAQ = faq
    return FAQFormView(model: FAQFormModel())
        .environment(appState)
}

struct GreenButtonStyle: ButtonStyle {
    var disabled: Bool
    func makeBody(configuration: Self.Configuration) -> some View {
        if disabled {
            configuration.label
                .padding(2)
                .padding(.horizontal)
                .foregroundStyle(.secondary)
                .background(Color(.secondarySystemFill))
                .cornerRadius(6.0)
                
        } else {
            configuration.label
                .padding(2)
                .padding(.horizontal)
                .foregroundStyle(configuration.isPressed ? Color.accent  : Color.white)
                .background(configuration.isPressed ? Color.white : Color.accent)
                .cornerRadius(6.0)
        }
    }
}
