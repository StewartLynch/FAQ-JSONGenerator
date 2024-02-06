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

struct FAQView: View {
    @State private var faqService = FAQService("https://stewartlynch.github.io/FAQ/FAQGenerator/FAQGenerator.json")
    @State private var groupedByLevel =  [Int: [FAQ]]()
    @Environment(\.dismiss) private var dismiss
    func levelString(_ level: Int) -> String {
        switch level {
        case 1:
            "App Information"
        case 2:
            "More..."
        case 3:
            "Level 3 Title"
        case 4:
            "Level 4 Title"
        default:
            "Level 5 Title"
        }
    }
    var body: some View {
        NavigationStack {
            Group {
                if faqService.loading {
                    ProgressView()
                } else {
                    List {
                        ForEach(groupedByLevel.keys.sorted(), id: \.self) { key in
                            Section(header: Text(levelString(key))) {
                                ForEach(groupedByLevel[key]!) { faq in
                                    QuestionView(faq: faq)
                                }
                            }
                        }
                    }
                    .listStyle(.plain)
                }
            }
            .navigationTitle("FAQ")
            .toolbar {
                ToolbarItem(placement: .cancellationAction){
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
        .task {
            await faqService.fetchFAQs()
            groupedByLevel =
            Dictionary(grouping: faqService.faqs.sorted(using: KeyPathComparator(\.sortOrder)), by: { $0.level })
        }
    }
}

struct QuestionView: View {
    @State private var showAnswer = false
    @State private var showWebView = false
    @Environment(\.dismiss) private var dismiss
    let faq: FAQ
    var body: some View {
        DisclosureGroup(
            isExpanded: $showAnswer,
            content: {
                VStack(alignment: .leading) {
                    Text(faq.answer)
                        .foregroundStyle(.secondary)
                    if let link = faq.link {
                        if faq.linkType == FAQ.FAQLinkType.video.rawValue {
                            Button {
                                showWebView.toggle()
                            } label: {
                                Text(link.title)
                            }
                            .buttonStyle(.bordered)
                            .sheet(isPresented: $showWebView) {
#if os(iOS)
                                VStack {
                                    FAQWebView(url: link.url)
                                    Button("Dismiss") {
                                        dismiss()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                }
#else
                                VStack {
                                    FAQWebView(url: link.url)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                    Text("Press escape to exit video view")
                                        .padding()
                                }
                                .frame(
                                    minWidth: 800,
                                    idealWidth: 800,
                                    maxWidth: .infinity,
                                    minHeight: 600,
                                    idealHeight: 600,
                                    maxHeight: .infinity
                                )
#endif
                            }
                        } else {
                            Link(link.title, destination: link.url)
                                .buttonStyle(.bordered)
                        }
                    }
                }
                .padding(.leading, 10)
            },
            label: {
                HStack(alignment: .top) {
                    Image(systemName: faq.qImage)
                        .imageScale(.medium)
                        .foregroundColor(.accent)
                    Text(faq.question)
                        .fontWeight(.semibold)
                }
            }
        )
    }
}


#Preview {
    NavigationStack {
        FAQView()
    }
}
