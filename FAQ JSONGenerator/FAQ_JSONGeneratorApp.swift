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
    @State private var appState = AppState()
    var body: some Scene {
        WindowGroup {
            MainScreen()
        }
        .modelContainer(for: Application.self)
        .environment(appState)
        .commands {
            SidebarCommands()
            ToolbarCommands()
            CommandGroup(replacing: .newItem) {
                Button("Add Application") {
                    appState.appFormType = .new
                }
                .keyboardShortcut("n", modifiers: [.shift, .command])
            }
            CommandMenu("FAQs") {
                Button("New FAQ") {
                    appState.newFAQ.toggle()
                }
                .keyboardShortcut("n", modifiers: .command)
                // more menu items go here
                .disabled(appState.importIsDisabled)
                Button("Import JSON") {
                    appState.importFailed = false
                    appState.askImport.toggle()
                }
                .disabled(appState.importIsDisabled)
                Button("Export JSON") {
                    appState.initiateExport = true
                }
                .disabled(appState.exportIsDisabled)
            }
        }
    }
    
    init() {
        print(URL.applicationSupportDirectory.path(percentEncoded: false))
    }
}
