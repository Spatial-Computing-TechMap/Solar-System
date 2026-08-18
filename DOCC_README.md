# SwiftUI Spatial Layout 태양계 DocC

이 프로젝트의 DocC 카탈로그는 `Tutorial/SolarSystemSpatialLayout.docc`에 있습니다. 현재 구현된 Full Immersive Space, Starfield, Reality Composer Pro 행성 에셋, 원형 SwiftUI Layout을 6개 튜토리얼로 설명합니다.

## 카탈로그 구성

- `SolarSystemSpatialLayout.tutorial`: 전체 목차와 두 개의 Chapter
- `Tutorials/01-ProjectSetup.tutorial`: 프로젝트와 패키지 준비
- `Tutorials/02-EnterFullSpace.tutorial`: Window에서 Full Space 열기
- `Tutorials/03-BuildStarfield.tutorial`: RealityView 밤하늘 만들기
- `Tutorials/04-LoadPlanetAssets.tutorial`: Model3DAsset으로 실제 행성 표시
- `Tutorials/05-BuildRadialLayout.tutorial`: 기존 Layout으로 원형 배치
- `Tutorials/06-ComposeSolarSystem.tutorial`: 깊이 정렬, 공간 합성, 회전
- `Articles/Architecture.md`: 코드 구조와 타입 책임
- `Articles/Requirements.md`: 빌드 환경과 에셋 요구사항
- `Articles/Roadmap.md`: 아직 구현하지 않은 공전, 명왕성 탈출, 시점 변화
- `Resources`: 전체 Swift 스니펫, 문서 이미지, 이미지 촬영 안내

Reality Composer Pro의 대용량 USDZ 파일은 DocC Resources에 복제하지 않습니다. 앱의 `RealityKitContent.rkassets`에서만 관리합니다.

## Xcode에서 문서 보기

1. `Tutorial.xcodeproj`를 엽니다.
2. `Tutorial` 스킴과 visionOS 목적지를 선택합니다.
3. Product > Build Documentation을 선택합니다.
4. Xcode Documentation Viewer에서 “SwiftUI Spatial Layout으로 태양계 둘러보기”를 엽니다.

## 명령줄에서 DocC 빌드

`Tutorial` 디렉터리에서 실행합니다.

```shell
xcodebuild docbuild \
  -project Tutorial.xcodeproj \
  -scheme Tutorial \
  -destination 'generic/platform=visionOS' \
  -derivedDataPath .build/DocC \
  CODE_SIGNING_ALLOWED=NO
```

생성된 문서 아카이브는 일반적으로 다음 위치에 있습니다.

```text
.build/DocC/Build/Products/Debug-xros/Tutorial.doccarchive
```

## 앱 빌드 확인

```shell
xcodebuild build \
  -project Tutorial.xcodeproj \
  -scheme Tutorial \
  -configuration Debug \
  -sdk xros \
  -destination 'generic/platform=visionOS' \
  -derivedDataPath .build/App \
  CODE_SIGNING_ALLOWED=NO
```

## GitHub Pages용 정적 변환

`<REPOSITORY_NAME>`을 실제 GitHub 저장소 이름으로 바꿉니다. DocC 카탈로그 이름과 Pages base path는 서로 다른 개념입니다. 프로젝트 사이트의 base path는 저장소 이름이어야 합니다.

```shell
xcrun docc process-archive transform-for-static-hosting \
  .build/DocC/Build/Products/Debug-xros/Tutorial.doccarchive \
  --output-path .build/site \
  --hosting-base-path '<REPOSITORY_NAME>'
```

정적 결과를 GitHub Pages에 올리면 주소는 다음 형식입니다.

```text
https://<OWNER>.github.io/<REPOSITORY_NAME>/tutorials/
https://<OWNER>.github.io/<REPOSITORY_NAME>/documentation/
```

## GitHub Actions

`.github/workflows/documentation.yml`은 저장소 이름을 `github.event.repository.name`에서 자동으로 읽습니다.

저장소의 Settings > Pages > Build and deployment에서 Source를 **GitHub Actions**로 설정해야 합니다. GitHub 호스티드 러너에 프로젝트가 요구하는 Xcode 26.4와 visionOS SDK가 없다면, 해당 SDK가 설치된 macOS 러너로 `runs-on` 값을 조정해야 합니다.

## 이미지 교체

현재 카탈로그는 실제 앱 리소스인 Starfield와 Jupiter 표면 이미지를 사용합니다. 완성 화면을 촬영하면 `Resources/ImageCaptureGuide.txt`의 이름과 설명을 따라 스크린샷을 추가하고 각 `@Image` 참조와 대체 텍스트를 갱신합니다.
