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

struct AppFAQsListView: View {
    @Environment(Router.self) var router
    let application: Application?
    @State private var sortedFAQs = [FAQ]()
    @State private var selectedLevel: Int? = nil
    @State private var levels: [Int] = []
    var body: some View {
        Group {
            if let application {
                if !application.faqs.isEmpty {
                    if levels.count > 0 {
                        Picker("Select Level", selection: $selectedLevel) {
                            EmptyView().tag(nil as Int?)
                            ForEach(levels, id: \.self) { level in
                                Text("Level \(level)").tag(level as Int?)
                            }
                        }
                    }
                    List(sortedFAQs, selection: Bindable(router).fAQ) { faq in
                        HStack  {
                            Image(systemName: faq.qImage)
                            Text(faq.question)
                        }.tag(faq)
                    }
                } else {
                    ContentUnavailableView("No FAQs yet", systemImage: "diamond")
                }
                
            } else {
                ContentUnavailableView("Select an application from the list", systemImage: "diamond")
            }
        }
        .onAppear {
            updateLevels()
        }
        .onChange(of: application) {
            updateLevels()
        }
        .onChange(of: selectedLevel) {
            if let selectedLevel, let application {
                sortedFAQs = application.faqs.sorted {$0.sortOrder < $1.sortOrder}.filter{$0.level == selectedLevel}
            } else {
                sortedFAQs = []
            }
            router.fAQ = nil
        }
    }
    
    func updateLevels() {
        if let application, !application.faqs.isEmpty {
            levels = Array(Set(application.faqs.map { $0.level })).sorted(by: <)
            selectedLevel = levels[0]

        } else {
            selectedLevel = nil
        }
    }
    
}

#Preview {
    let container = Application.preview
    let fetchDescriptor = FetchDescriptor<Application>()
    let application = try! container.mainContext.fetch(fetchDescriptor)[0]

     return AppFAQsListView(application: application)
        .environment(Router())
//        .modelContainer(Application.preview)
}
