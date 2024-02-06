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
    @Environment(AppState.self) var appState
    @Environment(\.modelContext) private var modelContext
    let application: Application?
    @State private var sortedFAQs = [FAQ_SD]()
    @State private var selectedLevel: Int? = nil
    @State private var levels: [Int] = []
    var body: some View {
        Group {
        if appState.appCount > 0 {
            if appState.application != nil {
                VStack {
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
                        List(selection: Bindable(appState).fAQ) {
                            ForEach(sortedFAQs){ faq in
                                HStack  {
                                    Image(systemName: faq.qImage)
                                    Text(faq.question)
//                                    Text("\(faq.sortOrder)")
                                }.tag(faq)
                            }
                            .onMove { from, to in
                                sortedFAQs.move(fromOffsets: from, toOffset: to)
                                resort(level: selectedLevel!)
                            }
                        }
                    } else {
                        // MARK: NO FAQs
                        Spacer()
                        ContentUnavailableView("No FAQs yet", systemImage: "square.and.pencil", description: Text("Either import from an existing JSON file or start adding new FAQs"))
                    }
                    Spacer()
                }
                .padding()
                .alert("Import JSON", isPresented: Bindable(appState).askImport) {
                    Button("Cancel", role: .cancel) {
                        
                    }
                    Button("Append") {
                        initiateImport()
                    }
                    Button("Replace") {
                        initiateImport(removeAll: true)
                    }
                } message: {
                    Text("Import FAQs from an existing JSON File.")
                }
                .alert("Import Failed", isPresented: Bindable(appState).importFailed, actions: {
                    
                }, message: {
                    Text("Could not decode that JSON file.  It must be in the wrong format.")
                })
                .sheet(isPresented: Bindable(appState).newFAQ, onDismiss: {
                    // Update
                    updateLevels()
                    sortBySelectedLevel()
                    
                }) {
                    if let application = appState.application {
                        FAQFormView(model: FAQFormModel(application: application))
                    }
                }
                .onChange(of: application) {
                    updateLevels()
                    sortBySelectedLevel()
                }
                .onChange(of: selectedLevel) {
                    sortBySelectedLevel()
                }
                .onChange(of: appState.needsListRefresh) {
                    updateLevels()
                    sortBySelectedLevel()
                    appState.needsListRefresh = false
                }
            } else {
                ContentUnavailableView("Select Application", systemImage: "hand.point.left.fill")
            }
        } else {
            Image(.mac128)
        }
    }
        .toolbar {
            ToolbarItem {
                if appState.application != nil  {
                    Button("New FAQ", systemImage: "plus") {
                        appState.newFAQ.toggle()
                    }
                    .help("Add a new FAQ")
                }
            }
            if !appState.newFAQ && appState.fAQ != nil {
                ToolbarItem {
                    Button("Delete", systemImage: "trash", role: .destructive) {
                        appState.deleteFAQ.toggle()
                    }
                    .help("Delete FAQ from this application")
                }
            }
        }
        .onChange(of: application) {
            updateLevels()
            sortBySelectedLevel()
        }
        .onChange(of: selectedLevel) {
            sortBySelectedLevel()
        }
        .onChange(of: appState.needsListRefresh) {
            updateLevels()
            sortBySelectedLevel()
            appState.needsListRefresh = false
        }
        
        .onChange(of: appState.initiateExport) {
            if appState.initiateExport {
                export()
            }
            appState.initiateExport = false
        }
        .onChange(of: appState.deleteFAQ) {
            if appState.deleteFAQ {
                if let faq = appState.fAQ, let application = appState.application {
                    appState.fAQ = nil
                    if let index = application.faqs.firstIndex(where: {$0.id == faq.id}) {
                        application.faqs.remove(at: index)
                    }
                    appState.needsListRefresh = true
                }
            }
            appState.deleteFAQ = false
        }
    }

    func sortBySelectedLevel() {
        if let selectedLevel, let application {
            sortedFAQs = application.faqs.sorted {$0.sortOrder < $1.sortOrder}.filter{$0.level == selectedLevel}
        } else {
            sortedFAQs = []
        }
        appState.fAQ = nil
        
    }
    
    func updateLevels() {
        if let application, !application.faqs.isEmpty {
            levels = Array(Set(application.faqs.map { $0.level })).sorted(by: <)
            if appState.needsListRefresh {
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
    
    func initiateImport(removeAll: Bool = false) {
        if let application = appState.application {
            switch InOutService.importFAQs(application: application) {
            case .success(let faqs):
                if removeAll {
                    application.faqs.removeAll()
                }
                completeImport(faqs: faqs)
            case .failure(let error):
                if error != .cancel {
                    appState.importFailed = true
                }
            }
        }
    }
    
    func completeImport(faqs: [ExportJSON.FAQ]) {
        if let application {
            faqs.forEach { faq in
                let linkType = LinkType(rawValue: faq.linkType) ?? .none
                let newFAQ = FAQ_SD(
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
                    case .video, .image:
                        newFAQ.link.title = link.title
                        newFAQ.link.url = link.url.components(separatedBy: "/").last ?? ""
                    case .weblink:
                        newFAQ.link.title = link.title
                        newFAQ.link.url = link.url.components(separatedBy: "/").last ?? ""
                    case .external:
                        newFAQ.link.title = link.title
                        newFAQ.link.url = link.url
                    }
                }
                try? modelContext.save()
            }
            appState.needsListRefresh = true
            updateLevels()
            sortBySelectedLevel()
            appState.needsListRefresh = false
        }
    }
    
    func export() {
        if let application, let jsonData = InOutService.exportJSONData(application: application) {
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

#Preview {
    let container = Application.preview
    let fetchDescriptor = FetchDescriptor<Application>()
    let application = try! container.mainContext.fetch(fetchDescriptor)[0]
    
    return AppFAQsListView(application: application)
        .environment(AppState())
    //        .modelContainer(Application.preview)
}
