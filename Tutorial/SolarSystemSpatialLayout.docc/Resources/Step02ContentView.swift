import SwiftUI

struct ContentView: View {
    @Environment(\.openImmersiveSpace) private var openImmersiveSpace
    @State private var isOpeningImmersiveSpace = false

    var body: some View {
        VStack(spacing: 24) {
            Text("Solar System")
                .font(.largeTitle)

            Button {
                Task {
                    isOpeningImmersiveSpace = true
                    defer { isOpeningImmersiveSpace = false }

                    await openImmersiveSpace(id: "SolarSystemSpace")
                }
            } label: {
                Text(isOpeningImmersiveSpace ? "입장 중..." : "입장하기")
            }
            .disabled(isOpeningImmersiveSpace)
            .buttonStyle(.borderedProminent)
        }
        .padding()
    }
}

#Preview(windowStyle: .automatic) {
    ContentView()
}
