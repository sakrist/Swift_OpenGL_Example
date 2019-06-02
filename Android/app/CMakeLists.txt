# Sets the minimum version of CMake required to build your native library.
# This ensures that a certain set of CMake features is available to
# your build.

cmake_minimum_required(VERSION 3.4.1)

project(SwiftNative)


message(STATUS "Setting up project: ${PROJECT_NAME}")
message(STATUS "Android ABI: ${ANDROID_ABI}")

if("${ANDROID_ABI}" STREQUAL "arm64-v8a")
    set(SaNdkPlatform "aarch64-linux-android")
elseif("${ANDROID_ABI}" STREQUAL "x86")
    set(SaNdkPlatform "i686-linux-android")
elseif("${ANDROID_ABI}" STREQUAL "armeabi-v7a")
    set(SaNdkPlatform "arm-linux-androideabi")
elseif("${ANDROID_ABI}" STREQUAL "x86_64")
    set(SaNdkPlatform "x86_64-linux-android")
else()
    message(FATAL_ERROR "Unknown or not supported by Swift toolchain architecture: \"${ANDROID_ABI}\".")
endif()
message(STATUS "Android Tripple: ${SaNdkPlatform}")

# >>> Configuration section.

if(NOT SA_SWIFT_TOOLCHAIN_DIR)
    message(FATAL_ERROR "\"SA_SWIFT_TOOLCHAIN_DIR\" variable is not set.\nExpected directory layout \"<SA_SWIFT_TOOLCHAIN_DIR>/bin/swift\".")
else()
    set(SA_SWIFT_TOOLCHAIN_DIR ${SA_SWIFT_TOOLCHAIN_DIR} CACHE FILEPATH "Path to Swift toolchain installation directory.")
endif()

set(SASwiftCompiler "${SA_SWIFT_TOOLCHAIN_DIR}/bin/swiftc-${SaNdkPlatform}")
set(SASwiftCopyLibs "${SA_SWIFT_TOOLCHAIN_DIR}/bin/copy-libs-${SaNdkPlatform}")

# <<< Configuration section.

set(SANativeLibsDir "${CMAKE_CURRENT_SOURCE_DIR}/build/swift/${ANDROID_ABI}")
set(SaLibOutput "${SANativeLibsDir}/libapp.so")
set(SaAppBaseOut "${SANativeLibsDir}/libAppBase.so")
# file(GLOB SASourceFilesInput "${CMAKE_CURRENT_SOURCE_DIR}/../../Sources/app/*.swift")

set(SASourceFilesInput
        "${CMAKE_CURRENT_SOURCE_DIR}/../../Sources/app/App.swift"
        "${CMAKE_CURRENT_SOURCE_DIR}/../../Sources/app/Cube.swift"
        "${CMAKE_CURRENT_SOURCE_DIR}/../../Sources/app/Geometry.swift"
        "${CMAKE_CURRENT_SOURCE_DIR}/../../Sources/app/main_android.swift"
        "${CMAKE_CURRENT_SOURCE_DIR}/../../Sources/app/MatrixTransform.swift"
        "${CMAKE_CURRENT_SOURCE_DIR}/../../Sources/app/Scene.swift"
        "${CMAKE_CURRENT_SOURCE_DIR}/../../Sources/app/Shader.swift"
        )

add_custom_command(
        OUTPUT ${SaAppBaseOut}
        COMMAND cd ${CMAKE_CURRENT_SOURCE_DIR}/../AppBase/
        COMMAND make build:${ANDROID_ABI}
        COMMAND file ${SaAppBaseOut}
        COMMENT "Build AppBase"
        VERBATIM
)



add_custom_command(
        OUTPUT ${SaLibOutput}
        DEPENDS ${SASourceFilesInput} ${SaAppBaseOut}
        COMMAND ${SASwiftCompiler} -emit-library -emit-module -swift-version 5 -parse-as-library -F "${SANativeLibsDir}" -I "${SANativeLibsDir}" -I ${CMAKE_SYSROOT} -Xcc -fmodule-map-file="${CMAKE_CURRENT_SOURCE_DIR}/../GL.swift/module.modulemap" -module-name app -Xlinker -soname -Xlinker libapp.so -o "${SaLibOutput}" ${SASourceFilesInput}
        COMMAND file ${SaLibOutput}
        COMMENT "Building Swift Shared library"
        VERBATIM
)

add_custom_target(SASwiftCompile DEPENDS ${SaLibOutput})

# Copy

set(SaCopyStatus "${CMAKE_CURRENT_BINARY_DIR}/SwiftNative-CopyLins.stamp")
add_custom_command(
        OUTPUT ${SaCopyStatus}
        DEPENDS ${SaLibOutput}
        COMMAND ${SASwiftCopyLibs} ${SANativeLibsDir}
        COMMAND cmake -E touch ${SaCopyStatus}
        COMMENT "Copying prebuilt libraries"
        VERBATIM
)

add_custom_target(SASwiftCopy DEPENDS ${SaCopyStatus})

# >>> Dependencies

# Also import existing library on Gradle configuration level.
# https://developer.android.com/studio/projects/gradle-external-native-builds#jniLibs

add_library(swift_app SHARED IMPORTED)
set_target_properties(swift_app PROPERTIES IMPORTED_LOCATION ${SaLibOutput})

# <<<

# Specifies a library name, specifies whether the library is STATIC or
# SHARED, and provides relative paths to the source code. You can
# define multiple libraries by adding multiple add_library() commands,
# and CMake builds them for you. When you build your app, Gradle
# automatically packages shared libraries with your APK.

file(GLOB SABridgeLibSources "${CMAKE_CURRENT_SOURCE_DIR}/src/main/cpp/*.cpp")
add_library(SABridge SHARED ${SABridgeLibSources})
add_dependencies(SABridge SASwiftCompile SASwiftCopy)

target_link_libraries(SABridge swift_app ${SaAppBaseOut})
