// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let dirs = [
    "common/",
    "libgambatte/include/",
    "libgambatte/src/",
]

let fm = FileManager.default
fm.changeCurrentDirectoryPath("$SRCROOT/Sources/gambatte/")
print("\nPWD: \(fm.currentDirectoryPath)")

let headers = Array(dirs.map { dir -> [String] in
    let contents: [String]? = try? FileManager.default.contentsOfDirectory(atPath: dir).filter { ($0 as NSString).pathExtension == "h" }
    let paths: [String]? = contents?.map { "\(dir)\($0)" }
    return paths ?? []
}.joined())

print("\n**headers**\n \(headers.joined(separator: "\n"))")

let package = Package(
    name: "GBCDeltaCore",
    platforms: [
        .iOS(.v12),
        .macOS(.v11),
        .tvOS(.v12)
    ],
    products: [
        .library(
            name: "GBCDeltaCore",
            targets: ["GBCDeltaCore"])
    ],
    dependencies: [
        //        .package(url: "https://github.com/rileytestut/DeltaCore.git", .branch("main"))
        .package(path: "../DeltaCore/")
    ],
    targets: [
        .target(
            name: "GBCSwift",
            dependencies: ["DeltaCore"]
        ),

        .target(
            name: "GBCBridge",
            dependencies: ["DeltaCore", "gambatte", "GBCSwift"],
            publicHeadersPath: "include",
            cSettings: [
                .unsafeFlags([
                    "-fmodules",
                    "-fcxx-modules"
                ]),
                .headerSearchPath("../gambatte/common"),
                .headerSearchPath("../gambatte/libgambatte/include"),
                .headerSearchPath("../gambatte/libgambatte/src"),
                .define("HAVE_CSTDINT")
            ],
            cxxSettings: [
                .unsafeFlags([
                    "-fmodules",
                    "-fcxx-modules"
                ]),
                .headerSearchPath("../gambatte/common"),
                .headerSearchPath("../gambatte/libgambatte/include"),
                .headerSearchPath("../gambatte/libgambatte/src"),
                .define("HAVE_CSTDINT")
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-I", "../gambatte/libgambatte/src"
                ])
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS, .tvOS, .macCatalyst])),
                .linkedFramework("AVFoundation", .when(platforms: [.iOS, .tvOS, .macCatalyst])),
                .linkedFramework("GLKit", .when(platforms: [.iOS, .tvOS, .macCatalyst])),
            ]
        ),

        .target(
            name: "GBCDeltaCore",
            dependencies: ["DeltaCore", "gambatte", "GBCSwift", "GBCBridge"],
            resources: [
                .copy("Resources/Controller Skin/Standard.deltaskin"),
                .copy("Resources/Standard.deltamapping"),
            ],
            publicHeadersPath: "include",
            swiftSettings: [
                .unsafeFlags([
//                    "-enable-cxx-interop",
                    //                        "-I", "Sources/CXX/include",
                    //                        "-I", "\(sdkRoot)/usr/include",
                    //                        "-I", "\(cPath)",
                    //                        "-lc++",
//                    "-Xfrontend", "-disable-implicit-concurrency-module-import",
//                    "-Xcc", "-nostdinc++"
                ])
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS, .tvOS, .macCatalyst])),
                .linkedFramework("AVFoundation", .when(platforms: [.iOS, .tvOS, .macCatalyst])),
                .linkedFramework("GLKit", .when(platforms: [.iOS, .tvOS, .macCatalyst])),
            ]
        ),

        .target(
            name: "gambatte",
            exclude: [
                "common/resample/",
                "common/videolink/",
                "gambatte_qt/",
                "gambatte_sdl/",
                "libgambatte/src/",
                "libgambatte/SConstruct",
                "test/",
                "README",
                "COPYING",
                "clean.sh",
                "changelog",
                "build_sdl.sh",
                "build_qt.sh",
                "libgambatte/src/file/file.cpp",
            ],
            sources: headers,
            publicHeadersPath: "libgambatte/include",
            cSettings: [
                .headerSearchPath("common"),
                .headerSearchPath("common/resample"),
                .headerSearchPath("libgambatte/include"),
                .headerSearchPath("libgambatte/src"),
                .headerSearchPath("libgambatte/src/file"),
                .headerSearchPath("libgambatte/src/mem"),
                .headerSearchPath("libgambatte/src/sound"),
                .headerSearchPath("libgambatte/src/video"),
                .define("HAVE_CSTDINT"),
            ],
            cxxSettings: [
                .headerSearchPath("common"),
                .headerSearchPath("common/resample"),
                .headerSearchPath("libgambatte/include"),
                .headerSearchPath("libgambatte/src"),
                .headerSearchPath("libgambatte/src/file"),
                .headerSearchPath("libgambatte/src/mem"),
                .headerSearchPath("libgambatte/src/sound"),
                .headerSearchPath("libgambatte/src/video"),
                .define("HAVE_CSTDINT"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx11
)
