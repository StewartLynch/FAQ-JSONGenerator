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

struct ApplicationListView: View {
    @Environment(AppState.self) var appState
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Application.name) var applications: [Application]
    @State private var appName = ""
    var body: some View {
        Group {
            if !applications.isEmpty {
                List(applications, selection: Bindable(appState).application) { application in
                    Text(application.name).tag(application)
                }
            } else {
                ContentUnavailableView {
                    Text("Tap on the \(Image(systemName: "plus")) button above to add your first application.")
                }
            }
        }
        .onAppear {
            appState.appCount = applications.count
        }
        .onChange(of: applications) {
            appState.appCount = applications.count
        }
        .sheet(item: Bindable(appState).appFormType) { $0 }
        .toolbar {
            ToolbarItem {
                Button {
                    appState.appFormType = .new
                } label: {
                    Image(systemName: "plus")
                }
                .help("Create new App FAQ JSON")
            }
            if appState.application != nil {
                ToolbarItem {
                    Button {
                        if let application = appState.application {
                            appState.appFormType = .update(application)
                        }
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .help("Edit App Name")
                }
                ToolbarItem {
                    Button {
                        if let application = appState.application {
                            modelContext.delete(application)
                            appState.application = nil
                        }
                        
                    } label: {
                        Image(systemName: "trash")
                    }
                    .help("Delete App")
                }
            }
        }
    }
}

#Preview {
    ApplicationListView()
        .modelContainer(Application.preview)
        .environment(AppState())
    
}
