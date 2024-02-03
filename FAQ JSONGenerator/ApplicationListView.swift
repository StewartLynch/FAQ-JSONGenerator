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
    @Environment(Router.self) var router
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Application.name) var applications: [Application]
    @State private var appName = ""
    @State private var newApp = false
    @State private var editApp = false
    var body: some View {
        Group {
            if !applications.isEmpty {
                List(applications, selection: Bindable(router).application) { application in
                    Text(application.name).tag(application)
                }
            } else {
                ContentUnavailableView("No Applications yet", systemImage: "diamond.fill")
            }
        }
        .alert(
            "Edit Application name",
            isPresented: $editApp,
            actions: {
                TextField("Application name", text: $appName)
                Button("OK") {
                    if !appName.isEmpty {
                        router.application?.name = appName
                    }
                    router.application = nil
                }
            },
            message: {
                Text("Edit Application Name")
            }
        )
        .alert(
            "New Application",
            isPresented: $newApp,
            actions: {
                TextField("Application name", text: $appName)
                Button("OK") {
                    if !appName.isEmpty {
                        let newApp = Application(name: appName)
                        modelContext.insert(newApp)
                        router.application = nil
                    }
                }
            },
            message: {
                Text("New Application JSON")
            }
        )
        .toolbar {
            ToolbarItem {
                Button {
                    appName = ""
                    newApp.toggle()
                } label: {
                    Image(systemName: "plus")
                }
                .help("Create new App FAQ JSON")
            }
            if router.application != nil {
                ToolbarItem {
                    Button {
                        appName = router.application?.name ?? ""
                        editApp.toggle()
                    } label: {
                        Image(systemName: "pencil")
                    }
                    .help("Edit App Name")
                }
                ToolbarItem {
                    Button {
                        if let application = router.application {
                            modelContext.delete(application)
                            router.application = nil
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
        .environment(Router())
    
}
