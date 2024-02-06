//
// Created for TripMapper
// by  Stewart Lynch on 2024-01-31
//
// Follow me on Mastodon: @StewartLynch@iosdev.space
// Follow me on Threads: @StewartLynch (https://www.threads.net)
// Follow me on X: https://x.com/StewartLynch
// Follow me on LinkedIn: https://linkedin.com/in/StewartLynch
// Subscribe on YouTube: https://youTube.com/@StewartLynch
// Buy me a ko-fi:  https://ko-fi.com/StewartLynch


import Foundation

@Observable
class FAQService {
    var faqs: [FAQ] = []
    var loading = false
    let jsonURL: String
    init(_ jsonURL: String) {
        self.jsonURL = jsonURL
    }
    
    func fetchFAQs() async {
        do {
            let (data, _) = try  await URLSession.shared.data(from: URL(string: jsonURL)!)
            faqs = try JSONDecoder().decode(
                [FAQ].self,
                from: data
            )
            loading = false
        } catch {
            print("Could not decode")
            loading = false
        }
    }
}
