// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation


let fm = FileManager.default

let inXcode = ProcessInfo.processInfo.environment["__CFBundleIdentifier"] == "com.apple.dt.Xcode"

print("ENV: \(ProcessInfo.processInfo.environment.map { "\($0.key) : \($0.value)\n"})")

if inXcode {
    print("ℹ️ Building from XCode")
    let PROJECT_DIR: String = ProcessInfo.processInfo.environment["PROJECT_DIR"] ?? ""
    fm.changeCurrentDirectoryPath("Cores/GBCDeltaCore/Sources/gambatte/gambatte/")
} else {
    print("ℹ️ Not building from XCode")
    fm.changeCurrentDirectoryPath("Sources/gambatte/gambatte/")
}
print("\nPWD: \(fm.currentDirectoryPath)")

let dirs = [
    "common/",
    "libgambatte/include/",
    "libgambatte/src/",
]

let headers: [String] = Array(dirs.map { dir -> [String] in
    let contents: [String]? = try? FileManager.default.contentsOfDirectory(atPath: dir).filter { ($0 as NSString).pathExtension == "h" }
    let paths: [String]? = contents?.map { "gambatte/\(dir)\($0)" }
    return paths ?? []
}.joined())


let sourceDirs = [
    "libgambatte/src/",
]
let cpps: [String] = Array(sourceDirs.map { dir -> [String] in
    let contents: [String]? = try? FileManager.default.contentsOfDirectory(atPath: dir).filter { ($0 as NSString).pathExtension == "cpp" }
    let paths: [String]? = contents?.map { "gambatte/\(dir)\($0)" }
    return paths ?? []
}.joined())

let manualSources: [String] = [
    "gambatte/libgambatte/src/gambatte.cpp",
    "gambatte/libgambatte/src/cpu.cpp"
]

let sources = manualSources

print("\n**sources**\n \(sources.joined(separator: "\n"))")

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
            dependencies: ["DeltaCore", "gambatte", "GBCSwift", .product(name: "DeltaTypes", package: "DeltaCore")],
            publicHeadersPath: "include",
            cSettings: [
                .unsafeFlags([
                    "-fmodules",
                    "-fcxx-modules"
                ]),
                .headerSearchPath("../gambatte/gambatte/common"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/include"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/src"),
                .define("HAVE_CSTDINT")
            ],
            cxxSettings: [
                .unsafeFlags([
                    "-fmodules",
                    "-fcxx-modules"
                ]),
                .headerSearchPath("../gambatte/gambatte/common"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/include"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/src"),
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
//                    "-enable-experimental-cxx-interop"
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
                "gambatte/common/resample/",
                "gambatte/common/videolink/",
                "gambatte/gambatte_qt/",
                "gambatte/gambatte_sdl/",
                "gambatte/libgambatte/src/",
                "gambatte/libgambatte/SConstruct",
                "gambatte/test/",
                "gambatte/README",
                "gambatte/COPYING",
                "gambatte/clean.sh",
                "gambatte/changelog",
                "gambatte/build_sdl.sh",
                "gambatte/build_qt.sh",
                "gambatte/libgambatte/src/file/file.cpp",
            ],
            sources: sources,
            publicHeadersPath: "gambatte/libgambatte/include",
            cSettings: [
                .headerSearchPath("gambatte/common"),
                .headerSearchPath("gambatte/common/resample"),
                .headerSearchPath("gambatte/libgambatte/include"),
                .headerSearchPath("gambatte/libgambatte/src"),
                .headerSearchPath("gambatte/libgambatte/src/file"),
                .headerSearchPath("gambatte/libgambatte/src/mem"),
                .headerSearchPath("gambatte/libgambatte/src/sound"),
                .headerSearchPath("gambatte/libgambatte/src/video"),
                .define("HAVE_CSTDINT"),
            ],
            cxxSettings: [
                .headerSearchPath("gambatte/common"),
                .headerSearchPath("gambatte/common/resample"),
                .headerSearchPath("gambatte/libgambatte/include"),
                .headerSearchPath("gambatte/libgambatte/src"),
                .headerSearchPath("gambatte/libgambatte/src/file"),
                .headerSearchPath("gambatte/libgambatte/src/mem"),
                .headerSearchPath("gambatte/libgambatte/src/sound"),
                .headerSearchPath("gambatte/libgambatte/src/video"),
                .define("HAVE_CSTDINT"),
            ]
        ),
    ],
    swiftLanguageVersions: [.v5],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx11
)
