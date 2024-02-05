//
// Created for FAQ JSONGenerator
// by  Stewart Lynch on 2024-02-04
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import SwiftUI

struct Menus: Commands {
    @Environment(AppState.self) var appState
    @AppStorage("displayMode") var displayMode = DisplayMode.auto
    var body: some Commands {
        SidebarCommands()
        ToolbarCommands()
        CommandGroup(replacing: .newItem) {
            Button("New Application...") {
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
        CommandMenu("Display") {
            Picker("Appearance", selection: $displayMode) {
                ForEach(DisplayMode.allCases, id: \.self) {
                    Text($0.rawValue)
                        .tag($0)
                }
            }
        }
    }
//    }
}