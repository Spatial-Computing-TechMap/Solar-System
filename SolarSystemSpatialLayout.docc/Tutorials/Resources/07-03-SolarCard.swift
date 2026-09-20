GeometryReader { proxy in
    let textWidth = min(max(proxy.size.width * 0.4, 300), 500)
    let imageWidth = min(max(proxy.size.width - textWidth, 300), 700)
    ZStack {
        HStack(spacing: 60) {
            VStack(alignment: .leading, spacing: 0) {
                Text(module.heading)
                    .font(.system(size: 50, weight: .bold))
                    .padding(.bottom, 15)

                Text(module.overview)
                    .padding(.bottom, 24)

                ToggleImmersiveSpaceButton()
            }
            .frame(width: textWidth, alignment: .leading)

            module.detailView
                .frame(width: imageWidth, alignment: .center)
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
}
