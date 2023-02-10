// swift-tools-version:5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

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
            targets: ["GBCDeltaCore"]),
        .library(
            name: "GBCDeltaCoreStatic",
            type: .static,
            targets: ["GBCDeltaCore"]),
        .library(
            name: "GBCDeltaCoreDynamic",
            type: .dynamic,
            targets: ["GBCDeltaCore"]),

    ],
    dependencies: [
        //        .package(url: "https://github.com/rileytestut/DeltaCore.git", .branch("main"))
        .package(path: "../DeltaCore/"),
        .package(url: "https://github.com/marmelroy/Zip.git", .upToNextMinor(from: "2.1.0"))
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
                .headerSearchPath("../gambatte/include"),
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
                .headerSearchPath("../gambatte/include/"),
                .headerSearchPath("../gambatte/gambatte/common/"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/include/"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/src/"),
                .define("HAVE_CSTDINT")
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-enable-experimental-cxx-interop",
                    "-I", "../gambatte/include",
                    "-I", "../gambatte/gambatte/libgambatte/src"
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
            dependencies: ["DeltaCore", "gambatte", "GBCSwift", "GBCBridge", "Zip"],
            exclude: [
                "Resources/Controller Skin/info.json",
                "Resources/Controller Skin/iphone_portrait.pdf",
                "Resources/Controller Skin/iphone_landscape.pdf",
                "Resources/Controller Skin/iphone_edgetoedge_portrait.pdf",
                "Resources/Controller Skin/iphone_edgetoedge_landscape.pdf",
                "Resources/Controller Skin/ipad_portrait.pdf",
                "Resources/Controller Skin/ipad_landscape.pdf",
                "Resources/Controller Skin/ipad_splitview_portrait.pdf",
                "Resources/Controller Skin/ipad_splitview_landscape.pdf"

            ],
            resources: [
                .copy("Resources/Controller Skin/Standard.deltaskin"),
                .copy("Resources/Standard.deltamapping"),
            ],
            publicHeadersPath: "include",
            cSettings: [
                .headerSearchPath("../gambatte/include"),
                .headerSearchPath("../gambatte/gambatte/common"),
                .headerSearchPath("../gambatte/gambatte/common/resample"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/include"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/src"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/src/file"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/src/mem"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/src/sound"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/src/video"),
                .define("HAVE_CSTDINT"),
            ],
            cxxSettings: [
                .headerSearchPath("../gambatte/include"),
                .headerSearchPath("../gambatte/gambatte/common"),
                .headerSearchPath("../gambatte/gambatte/common/resample"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/include"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/src"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/src/file"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/src/mem"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/src/sound"),
                .headerSearchPath("../gambatte/gambatte/libgambatte/src/video"),
                .define("HAVE_CSTDINT"),
            ],
            swiftSettings: [
                .unsafeFlags([
                    "-enable-experimental-cxx-interop",
                    "-I", "../gambatte/gambatte/libgambatte/src"
                ])
            ],
            linkerSettings: [
                .linkedFramework("UIKit", .when(platforms: [.iOS, .tvOS, .macCatalyst])),
                .linkedFramework("AVFoundation", .when(platforms: [.iOS, .tvOS, .macCatalyst])),
                .linkedFramework("GLKit", .when(platforms: [.iOS, .tvOS, .macCatalyst])),
                .linkedLibrary("z")
            ]
        ),

        .target(
            name: "gambatte",
            exclude: [
                "gambatte/COPYING",
                "gambatte/README",
                "gambatte/build_qt.sh",
                "gambatte/build_sdl.sh",
                "gambatte/changelog",
                "gambatte/clean.sh",
                "gambatte/gambatte_qt/",
                "gambatte/gambatte_sdl/",
                "gambatte/libgambatte/SConstruct",
                "gambatte/test/",
                "gambatte/libgambatte/src/file/file.cpp",
            ],
            sources: [
                "gambatte/common/adaptivesleep.cpp",
                "gambatte/common/rateest.cpp",
                "gambatte/common/skipsched.cpp",
                "gambatte/common/resample/src/chainresampler.cpp",
                "gambatte/common/resample/src/i0.cpp",
                "gambatte/common/resample/src/kaiser50sinc.cpp",
                "gambatte/common/resample/src/kaiser70sinc.cpp",
                "gambatte/common/resample/src/makesinckernel.cpp",
                "gambatte/common/resample/src/resamplerinfo.cpp",
                "gambatte/common/resample/src/u48div.cpp",
                "gambatte/common/videolink/rgb32conv.cpp",
                "gambatte/common/videolink/vfilterinfo.cpp",
                "gambatte/common/videolink/vfilters/catrom2x.cpp",
                "gambatte/common/videolink/vfilters/catrom3x.cpp",
                "gambatte/common/videolink/vfilters/kreed2xsai.cpp",
                "gambatte/common/videolink/vfilters/maxsthq2x.cpp",
                "gambatte/common/videolink/vfilters/maxsthq3x.cpp",
                "gambatte/libgambatte/src/bitmap_font.cpp",
                "gambatte/libgambatte/src/cpu.cpp",
                "gambatte/libgambatte/src/gambatte.cpp",
                "gambatte/libgambatte/src/initstate.cpp",
                "gambatte/libgambatte/src/interrupter.cpp",
                "gambatte/libgambatte/src/interruptrequester.cpp",
                "gambatte/libgambatte/src/loadres.cpp",
                "gambatte/libgambatte/src/memory.cpp",
                "gambatte/libgambatte/src/sound.cpp",
                "gambatte/libgambatte/src/state_osd_elements.cpp",
                "gambatte/libgambatte/src/statesaver.cpp",
                "gambatte/libgambatte/src/tima.cpp",
                "gambatte/libgambatte/src/video.cpp",
                "gambatte/libgambatte/src/file/file.cpp",
                "gambatte/libgambatte/src/file/file_zip.cpp",
                "gambatte/libgambatte/src/file/unzip/ioapi.cpp",
                "gambatte/libgambatte/src/file/unzip/unzip.cpp",
                "gambatte/libgambatte/src/mem/cartridge.cpp",
                "gambatte/libgambatte/src/mem/memptrs.cpp",
                "gambatte/libgambatte/src/mem/pakinfo.cpp",
                "gambatte/libgambatte/src/mem/rtc.cpp",
                "gambatte/libgambatte/src/sound/channel1.cpp",
                "gambatte/libgambatte/src/sound/channel2.cpp",
                "gambatte/libgambatte/src/sound/channel3.cpp",
                "gambatte/libgambatte/src/sound/channel4.cpp",
                "gambatte/libgambatte/src/sound/duty_unit.cpp",
                "gambatte/libgambatte/src/sound/envelope_unit.cpp",
                "gambatte/libgambatte/src/sound/length_counter.cpp",
                "gambatte/libgambatte/src/video/ly_counter.cpp",
                "gambatte/libgambatte/src/video/lyc_irq.cpp",
                "gambatte/libgambatte/src/video/next_m0_time.cpp",
                "gambatte/libgambatte/src/video/ppu.cpp",
                "gambatte/libgambatte/src/video/sprite_mapper.cpp"
            ],
            publicHeadersPath: "include",
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
            ],
            linkerSettings: [
                .linkedLibrary("z")
            ]
        ),
    ],
    swiftLanguageVersions: [.v5],
    cLanguageStandard: .c11,
    cxxLanguageStandard: .cxx14
)
