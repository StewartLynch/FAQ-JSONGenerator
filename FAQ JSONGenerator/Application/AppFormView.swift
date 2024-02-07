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

            }
            .padding()
            .frame(width: 500)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button(model.updating ? "Update" : "Create") {
                        if model.updating {
                            model.application?.name = model.name
                        } else {
                            let newApp = Application(
                                name: model.name
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
