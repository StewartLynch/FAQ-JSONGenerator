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

@main
struct FAQ_JSONGeneratorApp: App {
    var appState = AppState()
    @AppStorage("displayMode") var displayMode = DisplayMode.auto
    var body: some Scene {
        WindowGroup {
            MainScreen()
        }
        .modelContainer(for: Application.self)
        .commands {
            Menus()
        }
        .environment(appState)
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
