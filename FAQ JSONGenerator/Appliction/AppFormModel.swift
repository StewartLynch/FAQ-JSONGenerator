//
// Created for FAQ JSONGenerator
// by  Stewart Lynch on 2024-02-03
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import SwiftUI
import SwiftData

@Observable
class AppFormModel {
    var name: String = ""
    var baseURL: String = ""
    var videoFolder: String = "videos"
    var htmlFolder: String = "html"
    var baseURLPath: String {
        baseURL.last == "/" ? baseURL : baseURL + "/"
    }
    
    var application:Application?
    
    var updating: Bool {
        application != nil
    }
    
    var disabled: Bool {
        name.isEmpty || baseURL.isEmpty || videoFolder.isEmpty || htmlFolder.isEmpty
    }
    
    init(application: Application) {
        self.application = application
        self.name = application.name
        self.baseURL = application.baseURL
        self.videoFolder = application.videoFolder
        self.htmlFolder = application.htmlFolder
    }
    
    init() {
    }
}


enum AppFormType: Identifiable, View {
    case new
    case update(Application)
    var id: String {
        switch self {
        case .new:
            "new"
        case .update:
            "update"
        }
    }
    
    var body: some View {
        switch self {
        case .new:
            AppFormView(model: AppFormModel())
        case .update(let application):
            AppFormView(model: AppFormModel(application: application))
        }
    }
    
}

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
            }
            .padding()
            .frame(width: 500)
        }
    }
}
