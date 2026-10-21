import SwiftUI

struct HistoryView: View {
    @Environment(ThemeManager.self) private var themeManager
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = HistoryViewModel()

    var body: some View {
        let palette = themeManager.palette
        NavigationStack {
            Group {
                if viewModel.history.isEmpty {
                    ContentUnavailableView("No calculations yet", systemImage: "clock", description: Text("Results from this session will appear here."))
                } else {
                    List(viewModel.history) { item in
                        HStack {
                            Text(item.equation).foregroundStyle(palette.secondary)
                            Spacer()
                            Text("= \(item.result)").fontWeight(.semibold)
                        }
                        .listRowBackground(palette.surface)
                    }
                    .scrollContentBackground(.hidden)
                }
            }
            .background(palette.background)
            .foregroundStyle(palette.primary)
            .navigationTitle("History")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) { Button("Done") { dismiss() } }
                ToolbarItem(placement: .topBarTrailing) { Button("Clear", role: .destructive) { viewModel.clear() }.disabled(viewModel.history.isEmpty) }
            }
        }
        .tint(palette.accent)
    }
}
