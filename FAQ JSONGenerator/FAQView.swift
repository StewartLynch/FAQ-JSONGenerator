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

struct FAQView: View {
    @Environment(Router.self) var router
    @State private var linkType:  LinkType?
    @State private var link: Link?
    let faq: FAQ?
    var body: some View {
        if let faq {
                Form {
                    TextField("Question", text: Bindable(faq).question)
                    TextField("Answer", text: Bindable(faq).answer)
                    Picker("Link Type", selection: $linkType) {
                        Text("None").tag(nil as LinkType?)
                        ForEach(LinkType.allCases) { linkType in
                            Text(linkType.rawValue).tag(linkType as LinkType?)
                        }
                    }
                    if linkType != nil, let link = faq.link  {
                        TextField("Link Title", text: Bindable(link).title)
                        TextField("URL", text: Bindable(link).url)
                    }
                }
                .padding()
                .onAppear {
                    updateLink()
                }
                .onChange(of: faq) {
                    updateLink()
                }
                .onChange(of: linkType) { oldValue, newValue in
                    faq.linkType = linkType?.rawValue
                    if linkType == .none {
                        link = nil
                    } else {
                        #warning("Here")
//                        link =
                    }
                }
            
        } else {
            ContentUnavailableView("Select FAQ", systemImage: "diamond")
        }
    }
    
    func updateLink() {
        if let linkType = faq?.linkType {
            self.linkType = LinkType(rawValue: linkType)
        }
        if let linkType = faq?.linkType {
            self.linkType = LinkType(rawValue: linkType)
        } else {
            self.linkType = nil
        }
    }
}

#Preview {
    let container = Application.preview
    let fetchDescriptor = FetchDescriptor<Application>()
    let application = try! container.mainContext.fetch(fetchDescriptor)[0]
    let faq = application.faqs[0]
    return FAQView(faq: faq)
        .environment(Router())
}
