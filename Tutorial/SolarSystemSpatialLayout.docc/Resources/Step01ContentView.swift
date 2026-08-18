import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack(spacing: 24) {
            Text("Solar System")
                .font(.largeTitle)

            Button("입장하기") {
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
