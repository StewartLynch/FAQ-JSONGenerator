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

@Observable
class AppState {
    var application: Application?
    var fAQ: FAQ?
    var needsListRefresh = false
    var appCount = 0
    var askImport = false
    var importFailed = false
    
    var initiateExport = false
    
    var newFAQ = false
    var appFormType: AppFormType?
    
    // Menu
    var importIsDisabled: Bool {
       application == nil
    }
    
    var exportIsDisabled: Bool {
        application == nil ||
        application != nil && application!.faqs.isEmpty
    }
    
    func reset() {
        application = nil
        fAQ = nil
    }
}
