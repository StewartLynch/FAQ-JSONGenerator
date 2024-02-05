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
import SwiftData

struct AppFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var model: AppFormModel
    var body: some View {
        NavigationStack {
            Form {
                TextField("App Name", text: $model.name)
                TextField("Base URL", text: $model.baseURL)
                TextField("Video Folder", text: $model.videoFolder)
                TextField("HTML Folder", text: $model.htmlFolder)
            }
            .padding()
            .frame(width: 500)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(model.updating ? "Update" : "Create") {
                        if model.updating {
                            model.application?.name = model.name
                            model.application?.baseURL = model.baseURLPath
                            model.application?.videoFolder = model.videoFolder
                            model.application?.htmlFolder = model.videoFolder
                        } else {
                            let newApp = Application(
                                name: model.name,
                                baseURL: model.baseURLPath,
                                videoFolder: model.videoFolder,
                                htmlFolder: model.htmlFolder
                            )
                            modelContext.insert(newApp)
                        }
                        dismiss()
                    }
                    .disabled(model.disabled)
                }
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    AppFormView(model: AppFormModel())
        .modelContainer(Application.preview)
    
}
