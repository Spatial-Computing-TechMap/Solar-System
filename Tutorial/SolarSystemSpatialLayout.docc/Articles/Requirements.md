# Requirements

프로젝트와 DocC 튜토리얼을 빌드하는 데 필요한 환경과 리소스를 확인합니다.

## 개발 환경

- Xcode 26.4 이상
- visionOS 26.4 SDK와 배포 대상
- SwiftUI와 RealityKit
- Reality Composer Pro
- Apple Vision Pro 또는 visionOS Simulator

얼굴, 손 또는 공간 추적을 직접 요청하지 않으므로 카메라 사용 설명이나 별도의 카메라 권한은 필요하지 않습니다.

## 프로젝트 열기

`Tutorial/Tutorial.xcodeproj`를 Xcode로 열고 `Tutorial` 스킴을 선택합니다. 앱 타깃은 로컬 Swift 패키지 `RealityKitContent`에 의존합니다.

## 에셋 요구사항

다음 에셋이 `Tutorial/Packages/RealityKitContent/Sources/RealityKitContent/RealityKitContent.rkassets`에 있어야 합니다.

- Sun
- Mercury
- Venus
- EarthRCP
- Mars
- Jupiter
- Saturn
- Uranus
- Neptune

`EarthRCP`는 같은 에셋 카탈로그에 존재하는 `Earth.usda`와 이름이 충돌하지 않도록 구분한 이름입니다. DocC 카탈로그는 이 모델을 사용하는 방법만 설명하며 대용량 USDZ 파일을 Resources에 다시 복사하지 않습니다.

별 배경에는 앱 Asset Catalog의 `Starfield` 이미지가 필요합니다.

## Simulator와 실기기

Simulator에서는 코드 구조와 기본 공간 배치를 확인할 수 있습니다. 실제 시야 범위, 모델의 체감 크기, 깊이와 Full Immersion의 느낌은 Apple Vision Pro에서 최종 검증하는 것이 좋습니다.

현재 프로젝트는 `.full` ImmersionStyle만 허용합니다. 주변 공간을 남기는 `.mixed` 스타일은 아직 지원하지 않습니다.

## 문서 빌드

Xcode에서 Product > Build Documentation을 선택하거나 프로젝트 루트에서 다음 명령을 실행합니다.

```shell
xcodebuild docbuild \
  -project Tutorial.xcodeproj \
  -scheme Tutorial \
  -destination 'generic/platform=visionOS' \
  -derivedDataPath .build/DocC \
  CODE_SIGNING_ALLOWED=NO
```

구조 설명은 <doc:Architecture>에서, 후속 구현 범위는 <doc:Roadmap>에서 확인할 수 있습니다.
