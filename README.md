# app-daily-banking-ios

The native Daily Banking iOS app.

For app testing [request](https://mkb-sys.atlassian.net/wiki/spaces/NWD/pages/186482798/Native+Testflight+iOS) a testflight access.

## Used technologies

- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [CocoaPods](https://cocoapods.org/)
- [Resolver](https://github.com/hmlongco/Resolver)
- [Combine](https://developer.apple.com/documentation/combine)
- [Fastlane](https://fastlane.tools/)
- [SwiftGen](https://github.com/SwiftGen/SwiftGen)
- [SwiftLint](https://github.com/realm/SwiftLint)
- [SwiftyMocky](https://github.com/MakeAWishFoundation/SwiftyMocky)

## Documentation

[Shared documentation between iOS and Android](https://github.com/Magyar-Bankholding-Zrt/app-daily-banking-documentation)

## Prerequisites

- XCode 13 or higher
- Ruby (suggested version: macOS default ruby)

## Getting started

Checkout the project together with the subrepo:
```
$ git clone --recurse-submodules git@github.com:Magyar-Bankholding-Zrt/app-daily-banking-ios.git
```

Run the project setup script:
```
sh ./scripts/setupProject.sh
```

### Useful scripts:
#### Running xUnique:
xUnique, is a pure Python script to regenerate project.pbxproj, a.k.a the Xcode project file, and make it unique and same on any machine, which makes merging project file easier. (https://github.com/truebit/xUnique)
```
$ sh ./scripts/runXUnique.sh
```

#### Updating Apollo schema:
```
$ sh ./scripts/apolloDownload.sh
```

#### Generate request/response classes from the downloaded schema:
```
sh ./scripts/apolloGenerate.sh
```

## Working with resources

Bundled resources of the application are accessed via strongly typed references. Resource references are generated using [Swiftgen](https://github.com/SwiftGen/SwiftGen), on each build.
 
The purpose of these references is to provide compiler errors in case a non-existent resource would be used, hence string based identification (such as `UIImage(named: "my-image")`) must be avoid if possible.

### Strings

Localizable strings are currently found in the application target only. 

Generated resources references: `Strings.generated.swift`

Example usage: 

```
Text(Strings.Localizable.startRegistration)
```

#### Updating

For updating localizable strings check out the [Translation guide](https://github.com/Magyar-Bankholding-Zrt/app-daily-banking-documentation/blob/main/Tools/Translation.md).

### Images

Images can be found in every build target.

Generated resource refernces: `Assets.generated.swift`

Example usage:
```
Image(.fileDocument)
```

#### Updating

Where do I put a new image?
- System icon -> DesignKit
- Duotone icon -> Application target
- Detailed icon -> Application target

### Colors

Colors can be found in DesignKit only. `DesignKit > Colors.swift` contains the semantic color palette which is fully aligned with [Designed System color palette](https://www.figma.com/file/doukckpPruaBaWcoNNDPjc/?node-id=0%3A1). Avoid using any colors outside of this palette, otherwise rebranding the UI will not change the those elements. 

Generated resource refernces: `Assets.generated.swift`

Example usage:
```
.foregroundColor(.text.primary)
```

### Fonts

Fonts can be found in DesignKit only. `DesignKit > Fonts.swift` contains the semantic font styles those are fully aligned with Designed System. Avoid using any fonts outside of these, otherwise rebranding the UI will not change the those elements. 

Generated resource references: `Fonts.generated.swift` 

Example usage:
```
.font(.body2)
```
