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

