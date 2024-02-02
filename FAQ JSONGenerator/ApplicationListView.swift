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

struct ApplicationListView: View {
    @Environment(Router.self) var router
    @Environment(\.modelContext) var modelContext
    @Query(sort: \Application.name) var applications: [Application]
    @State private var appName = ""
    @State private var newApp = false
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
            "New Application",
            isPresented: $newApp,
            actions: {
                TextField("Enter your name", text: $appName)
                Button("OK") {
                    if !appName.isEmpty {
                        let newApp = Application(name: appName)
                        modelContext.insert(newApp)
                        router.application = newApp
                    }
                }
            },
            message: {
                Text("New Appliction JSON")
            }
        )
        .toolbar {
            Button {
                newApp.toggle()
            } label: {
                Image(systemName: "plus.circle.fill")
            }
        }
    }
}

#Preview {
    ApplicationListView()
        .modelContainer(Application.preview)
        .environment(Router())
    
}
