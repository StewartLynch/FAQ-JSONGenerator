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
    @State private var newFAQ = false
    var body: some View {
                VStack {
                    HStack {
                        Spacer()
                        if let application = router.application  {
                                    Button("New FAQ", systemImage: "plus.circle.fill") {
                                        newFAQ.toggle()
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            if !application.faqs.isEmpty {
                                Button("Export") {
                                    if let jsonData = router.exportJSONData() {
                                        let savePanel = NSSavePanel()
                                        let suggestedFileName = application.name.replacingOccurrences(of: " ", with: "")
                                        savePanel.nameFieldStringValue = suggestedFileName
                                        savePanel.allowedContentTypes = [.json]
                                        
                                        savePanel.begin { result in
                                            if result == .OK, let url = savePanel.url {
                                                do {
                                                    try jsonData.write(to: url)
                                                    print("JSON exported successfully.")
                                                } catch {
                                                    print("Error writing JSON data: \(error)")
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    if let application, !application.faqs.isEmpty {
                        if levels.count > 0 {
                            Picker("Select Level", selection: $selectedLevel) {
                                EmptyView().tag(nil as Int?)
                                ForEach(levels, id: \.self) { level in
                                    Text("Level \(level)").tag(level as Int?)
                                }
                            }
                            .frame(width: 200)
                        }
                        List(selection: Bindable(router).fAQ) {
                            ForEach(sortedFAQs){ faq in
                                HStack  {
                                    Image(systemName: faq.qImage)
                                    Text(faq.question)
                                    Text("\(faq.sortOrder)")
                                }.tag(faq)
                            }
                            .onMove { from, to in
                                sortedFAQs.move(fromOffsets: from, toOffset: to)
                                resort(level: selectedLevel!)
                            }
                        }
                    } else {
                        ContentUnavailableView("No FAQs yet", systemImage: "diamond")
                    }
                    Spacer()
                }
                .padding()
                .sheet(isPresented: $newFAQ, onDismiss: {
                    // Update
                    updateLevels()
                    sortBySelectedLevel()
                    
                }) {
                    if let application = router.application {
                        FAQUpdateView(model: FAQFormModel(application: application))
                    }
                }
        .onChange(of: application) {
            updateLevels()
            sortBySelectedLevel()
        }
        .onChange(of: selectedLevel) {
            sortBySelectedLevel()
        }
        .onChange(of: router.needsListRefresh) {
            updateLevels()
            sortBySelectedLevel()
            router.needsListRefresh = false
        }
    }
    
    
    func sortBySelectedLevel() {
        if let selectedLevel, let application {
            sortedFAQs = application.faqs.sorted {$0.sortOrder < $1.sortOrder}.filter{$0.level == selectedLevel}
        } else {
            sortedFAQs = []
        }
        router.fAQ = nil
        
    }
    
    func updateLevels() {
        if let application, !application.faqs.isEmpty {
            levels = Array(Set(application.faqs.map { $0.level })).sorted(by: <)
            if router.needsListRefresh {
                // Update sort orders
                levels.forEach { level in
                    sortedFAQs = application.faqs.sorted {$0.sortOrder < $1.sortOrder}.filter{$0.level == level}
                    resort(level: level)
                }
            }
            selectedLevel = levels[0]

        } else {
            selectedLevel = nil
        }
    }
    
    
    func resort(level: Int) {
        if let application, !application.faqs.isEmpty {
//            sortedFAQs = application.faqs.sorted {$0.sortOrder < $1.sortOrder}.filter{$0.level == level}
            sortedFAQs.indices.forEach { index in
                sortedFAQs[index].sortOrder = index + 1
            }
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
