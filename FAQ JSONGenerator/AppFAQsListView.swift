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
    @Environment(\.modelContext) private var modelContext
    let application: Application?
    @State private var sortedFAQs = [FAQ]()
    @State private var selectedLevel: Int? = nil
    @State private var levels: [Int] = []
    @State private var newFAQ = false
    @State private var importWarning = false
    var body: some View {
        VStack {
            HStack {
                Spacer()
                if let application = router.application  {
                    Button("Import JSON", systemImage: "arrow.up") {
                        importWarning.toggle()
                    }
                    .alert("Import JSON", isPresented: $importWarning) {
                        Button("Cancel", role: .cancel) {
                            
                        }
                        Button("OK") {
                            let openPanel = NSOpenPanel()
                            openPanel.title = "Choose a file"
                            openPanel.showsResizeIndicator = true
                            openPanel.showsHiddenFiles = false
                            openPanel.canChooseDirectories = false
                            openPanel.canCreateDirectories = false
                            openPanel.allowsMultipleSelection = false
                            openPanel.allowedContentTypes = [.json]
                            guard openPanel.runModal() == .OK else {
                                return
                            }
                            if let url = openPanel.url {
                                do {
                                    let fileContents = try String(contentsOf: url)
                                    let jsonData = Data(fileContents.utf8)
                                    if let jsonString = String(data: jsonData, encoding: .utf8) {
                                        print(jsonString)
                                    } else {
                                        print( "")
                                    }
                                    let decoder = JSONDecoder()
                                    let faqs = try decoder.decode([ExportJSON.FAQ].self, from: jsonData)
                                    application.faqs.removeAll()
                                    faqs.forEach { faq in
                                        let linkType = LinkType(rawValue: faq.linkType) ?? .none
                                        let newFAQ = FAQ(
                                            level: faq.level,
                                            sortOrder: faq.sortOrder,
                                            question: faq.question,
                                            answer:   faq.answer,
                                            linkType: linkType
                                        )
                                        application.faqs.append(newFAQ)
                                        try? modelContext.save()
                                        if let link = faq.link {
                                            switch linkType {
                                            case .none:
                                                break
                                            case .video:
                                                newFAQ.link.title = link.title
                                                newFAQ.link.url = link.url.components(separatedBy: "/").last ?? ""
                                            case .weblink:
                                                newFAQ.link.title = link.title
                                                newFAQ.link.url = link.url.components(separatedBy: "/").last ?? ""
                                            case .external:
                                                newFAQ.link.url = link.url
                                            }
                                        }
                                        try? modelContext.save()
                                    }
                                    updateLevels()
                                    sortBySelectedLevel()
                                    
                                } catch {
                                    // Handle errors while reading or decoding the file
                                    print("Error reading or decoding file: \(error.localizedDescription)")
                                }
                            }
                        }
                    } message: {
                        Text("Importing will replace existing FAQs")
                    }
                    
                    
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
                    Button("New FAQ", systemImage: "plus.circle.fill") {
                        newFAQ.toggle()
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
