# Architecture

태양계 앱은 SwiftUI가 화면과 공간 레이아웃을 담당하고, RealityKit은 밤하늘 장면과 Reality Composer Pro 콘텐츠를 제공하도록 역할을 나눕니다.

## 전체 흐름

1. `TutorialApp`이 일반 `WindowGroup`과 `.full` 스타일의 `ImmersiveSpace`를 선언합니다.
2. `ContentView`의 버튼이 `openImmersiveSpace`를 호출합니다.
3. `SolarSystem`이 별 배경, 궤도선, 행성 레이아웃을 합성합니다.
4. `SolarSystemSpatialLayout`이 각 행성의 반지름과 초기 각도를 읽어 원 위의 좌표를 계산합니다.
5. `PlanetModelView`가 Reality Composer Pro 에셋을 `Model3DAsset`으로 로드해 깊이를 가진 SwiftUI 뷰로 표시합니다.

## 파일과 책임

| 파일 | 책임 |
| --- | --- |
| `TutorialApp.swift` | Window와 Immersive Space Scene 선언 |
| `ContentView.swift` | Full Space 진입 액션과 진행 상태 관리 |
| `PlanetConfiguration.swift` | 행성 이름, 에셋, 표시 크기, 궤도 반지름, 초기 각도 정의 |
| `Starfield.swift` | 안쪽을 향한 RealityKit 밤하늘 구체 생성 |
| `PlanetModelView.swift` | `Model3DAsset` 로딩, 3D 크기 제안, 이름 오버레이 |
| `OrbitGuideView.swift` | 행성별 원형 궤도선 렌더링 |
| `SolarSystemSpatialLayout.swift` | LayoutValue와 삼각함수를 이용한 원형 배치 |
| `SolarSystem.swift` | SpatialContainer, 깊이 정렬, 궤도 평면 회전과 최종 장면 합성 |

## RealityView와 Model3D

`Starfield`는 하나의 대형 RealityKit 장면입니다. 구체의 메시와 머티리얼을 직접 만들고 콘텐츠에 Entity를 추가해야 하므로 `RealityView`가 알맞습니다.

각 행성은 SwiftUI 커스텀 레이아웃의 하위 뷰입니다. `Model3D`를 사용하면 모델이 다른 SwiftUI 뷰처럼 크기 제안, 깊이 정렬, 레이아웃 회전에 참여합니다. 앱의 모든 3D 요소를 RealityView 하나에 넣을 필요는 없습니다.

## 공간 레이아웃

visionOS 26의 SwiftUI Spatial Layout은 별도 프로토콜이 아닙니다. 기존 `Layout`과 Stack에 깊이 구성 기능이 추가된 방식입니다.

- `frame(depth:)`는 모델이 차지할 깊이를 제안합니다.
- `scaledToFit3D()`는 모델 비율을 유지하며 너비·높이·깊이에 맞춥니다.
- `depthAlignment(.front)`는 하위 뷰들의 앞면을 같은 깊이 기준에 맞춥니다.
- `SpatialContainer`는 여러 뷰를 같은 3D 좌표 공간에 놓습니다.
- `spatialOverlay`는 한 기준 뷰에 보조 뷰를 같은 공간에서 겹칩니다.
- `rotation3DLayout`은 회전된 크기와 위치를 레이아웃 계산에 반영합니다.
- `rotation3DEffect`는 배치가 끝난 결과만 시각적으로 회전합니다.

## 현재 데이터의 의미

`PlanetConfiguration.orbitAngle`은 실행 시간에 변하지 않는 초기 배치 각도입니다. 공전을 구현하려면 시간에 따라 변하는 별도 상태가 필요합니다. `orbitRadius`도 실제 천문 단위를 그대로 사용하는 값이 아니라, 2,400포인트 캔버스에서 보기 좋은 간격으로 조정한 시각적 값입니다.

다음으로 <doc:Requirements>에서 실행 환경을 확인하고, <doc:Roadmap>에서 아직 구현하지 않은 기능을 살펴보세요.
