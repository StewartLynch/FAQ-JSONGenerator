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


//enum AppFormType: Identifiable, View {
//    case new
//    case update(Application)
//    var id: String {
//        switch self {
//        case .new:
//            "new"
//        case .update:
//            "update"
//        }
//    }
//    
//    var body: some View {
//        switch self {
//        case .new:
//            AppFormView(model: AppFormModel())
//        case .update(let application):
//            AppFormView(model: AppFormModel(application: application))
//        }
//    }
//    
//}