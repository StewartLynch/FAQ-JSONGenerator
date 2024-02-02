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
    @Query(sort: \Application.name) var applications: [Application]
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
        .onChange(of: router.application) { oldValue, newValue in
            print(newValue?.name ?? "No Name")
        }
    }
}

#Preview {
    ApplicationListView()
        .modelContainer(Application.preview)
        .environment(Router())
    
}
