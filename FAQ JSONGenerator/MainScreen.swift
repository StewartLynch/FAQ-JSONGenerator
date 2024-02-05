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

struct MainScreen: View {
    @Environment(Router.self) var router
    @State private var columnVisibility: NavigationSplitViewVisibility = .all
    var body: some View {
        NavigationSplitView(columnVisibility: $columnVisibility) {
            ApplicationListView()
                .navigationSplitViewColumnWidth(250)
        } content: {
            AppFAQsListView(application: router.application)
                .navigationSplitViewColumnWidth(350)
        } detail: {
            FAQView(model: FAQFormModel())
        }
        .navigationSplitViewStyle(.balanced)
        .frame(
          minWidth: 1200,
          idealWidth: 1200,
          maxWidth: .infinity,
          minHeight: 600,
          idealHeight: 600,
          maxHeight: .infinity)
    }
}

#Preview {
    MainScreen()
        .modelContainer(Application.preview)
        .environment(Router())
}
