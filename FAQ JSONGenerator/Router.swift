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
class Router {
    var application: Application?
    var fAQ: FAQ?
    var needsListRefresh = false
    
    func reset() {
        application = nil
        fAQ = nil
    }
    
    func exportJSONData() -> Data? {
        var exportArray = [ExportJSON.FAQ]()
        if let application {
            application.faqs.forEach { faq in
                var newExportFAQ = ExportJSON.FAQ(
                    level: faq.level,
                    sortOrder: faq.sortOrder,
                    question: faq.question,
                    answer: faq.answer,
                    linkType: faq.linkType
                )
                switch faq.linkTypeEnum {
                case .video:
                    newExportFAQ.link = ExportJSON.Link(
                        title: faq.link.title,
                        url: application.baseURL + application.videoFolder + "/" + faq.link.url
                    )
                case .weblink:
                    newExportFAQ.link = ExportJSON.Link(
                        title: faq.link.title,
                        url: application.baseURL + application.htmlFolder  + "/" + faq.link.url
                    )
                case .external:
                    newExportFAQ.link = ExportJSON.Link(
                        title: faq.link.title,
                        url: faq.link.url
                    )
                default: break
                }
                exportArray.append(newExportFAQ)
            }
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            encoder.outputFormatting = .prettyPrinted
            do {
                let jsonData = try encoder.encode(exportArray)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    print(jsonString)
                } else {
                    print( "")
                }
                return jsonData
            } catch {
                print("Error encoding ExportJSON: \(error)")
                return nil
            }
        } else {
            return nil
        }
    }
}
