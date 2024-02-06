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

enum InOutService {
    static func exportJSONData(application: Application) -> Data? {
        var exportArray = [ExportJSON.FAQ]()
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
                    url: application.baseURL + application.mediaFolder + "/" + faq.link.url
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
            return jsonData
        } catch {
            print("Error encoding ExportJSON: \(error)")
            return nil
        }
    }
    
    enum ImportError:Error {
        case cancel
        case failed
    }
    static func importFAQs(application: Application) -> Result<[ExportJSON.FAQ], ImportError> {
            let openPanel = NSOpenPanel()
            openPanel.title = "Choose a file"
            openPanel.showsResizeIndicator = true
            openPanel.showsHiddenFiles = false
            openPanel.canChooseDirectories = false
            openPanel.canCreateDirectories = false
            openPanel.allowsMultipleSelection = false
            openPanel.allowedContentTypes = [.json]
            guard openPanel.runModal() == .OK else {
                return .failure(.cancel)
            }
            if let url = openPanel.url {
                do {
                    let fileContents = try String(contentsOf: url)
                    let jsonData = Data(fileContents.utf8)
//                    if let jsonString = String(data: jsonData, encoding: .utf8) {
//                        print(jsonString)
//                    } else {
//                        print( "")
//                    }
                    let decoder = JSONDecoder()
                    let faqs = try decoder.decode([ExportJSON.FAQ].self, from: jsonData)
                    return .success(faqs)
                } catch {
                    // Handle errors while reading or decoding the file
                    print("Error reading or decoding file: \(error.localizedDescription)")
                    return .failure(.failed)
                }
            } else {
                return .failure(.failed)
            }
    }
}
