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


import Foundation
import SwiftData

@Model
class Application {
    var name: String
    init(name: String) {
        self.name = name
    }
    @Relationship(deleteRule: .cascade)
    var faqs: [FAQ] = []
}

extension Application {
    @MainActor
    static var preview: ModelContainer {
        let container = try! ModelContainer(
            for: Application.self,
            configurations: ModelConfiguration(
                isStoredInMemoryOnly: true
            )
        )
        let apps = [Application(name: "Sample Application 1"), Application(name: "Sample Application 2")]
        let links: [LinkType : Link] = [
            .video : Link(title: "Watch Video", url: "https://www.createchsol.com"),
            .weblink : Link(title: "More Information", url: "https://www.createchsol.com")
        ]
        
        var faqs: [FAQ] {
            [
                FAQ(level: 1, sortOrder: 1, question: "Q 1-1", answer: "Level 1 Answer 1"),
                FAQ(level: 1, sortOrder: 2, question: "Q 1-2", answer: "Level 1 Answer 2",linkType: .video, link: links[.video]!),
                FAQ(level: 1, sortOrder: 3, question: "Q 1-3", answer: "Level 1 Answer 3",linkType: .weblink, link: links[.weblink]!),
                FAQ(level: 2, sortOrder: 1, question: "Q 2-1", answer: "Level 2 Answer 1"),
                FAQ(level: 2, sortOrder: 2, question: "Q 2-2", answer: "Level 2 Answer 2",linkType: .video, link: links[.video]!),
                FAQ(level: 2, sortOrder: 3, question: "Q 2-3", answer: "Level 2 Answer 3",linkType: .weblink, link: links[.weblink]!),
            ]
        }
        
        apps.forEach { app in
            container.mainContext.insert(app)
            faqs.forEach { faq in
                faq.question = app.name + " " + faq.question
                app.faqs.append(faq)
            }
        }
        return container
    }
}

@Model
class FAQ {
    var level: Int
    var sortOrder: Int
    var question: String
    var answer: String
    var linkType: String
    @Relationship(deleteRule: .cascade)
    var link: Link
    
    var linkTypeEnum: LinkType {
        LinkType(rawValue: linkType) ?? .none
    }
    
    var qImage: String {
        let  linkEnum = LinkType(rawValue: linkType) ?? .none
            switch linkEnum {
            case .video:
                return "video.fill"
            case .weblink:
                return "link"
            default:
                return "quote.opening"
            }
    }
        
        init(level: Int, sortOrder: Int, question: String, answer: String, linkType: LinkType = .none, link: Link = Link()) {
            self.level = level
            self.sortOrder = sortOrder
            self.question = question
            self.answer = answer
            self.linkType = linkType.rawValue
            self.link = link
        }
    }


@Model
class Link {
    var title: String
    var url: String
    init(title: String = "", url: String = "") {
        self.title = title
        self.url = url
    }
}

enum LinkType: String, Codable, Identifiable, CaseIterable {
    case none
    case video
    case weblink
    var id: Self {
        self
    }
    
    
}
