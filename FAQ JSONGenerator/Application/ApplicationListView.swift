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
                    Text("Add your first appliction.")
                }
            }
        }
        .onAppear {
            appState.appCount = applications.count
        }
        .onChange(of: applications) {
            appState.appCount = applications.count
        }
        .onChange(of: appState.deleteApplication) {
            if appState.deleteApplication {
                if let application = appState.application {
                    modelContext.delete(application)
                    appState.application = nil
                }
            }
        }
        .sheet(item: Bindable(appState).appFormType) { $0 }
        .toolbar {
            ToolbarItem {
                Button {
                    appState.appFormType = .new
                } label: {
                    Image(systemName: "plus")
                }
                .help("Add a new application")
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
                    .help("Edit Application Information")
                }
                ToolbarItem {
                    Button {
                        appState.deleteApplication = true
                        
                    } label: {
                        Image(systemName: "trash")
                    }
                    .help("Delete Appilcation")
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
