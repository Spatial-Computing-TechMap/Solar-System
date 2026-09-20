GeometryReader { proxy in
    let textWidth = min(max(proxy.size.width * 0.4, 300), 500)
    let imageWidth = min(max(proxy.size.width - textWidth, 300), 700)
    ZStack {
        // 텍스트와 module.detailView 둘 다 깊이(depth)가 없는 평면
        // 콘텐츠라, depthAlignment(.center)를 줘도 정렬할 깊이 차이 자체가
        // 없어서 겉모습/동작은 그대로다. HStack 대신 HStackLayout을 써야
        // depthAlignment를 걸 수 있다.
        HStackLayout(spacing: 60).depthAlignment(.center) {
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
