cmake_minimum_required(VERSION 3.2)

message("${CMAKE_INSTALL_PREFIX}")

project(helloworld VERSION 1.0.$ENV{TRAVIS_BUILD_NUMBER})

find_package(Boost COMPONENTS unit_test_framework REQUIRED)
find_package(GTest REQUIRED)

configure_file(version.h.in version.h)

add_executable(helloworld_cli main.cpp)
add_library(helloworld lib.cpp)
add_executable(test_version test_version.cpp)
add_executable(gtest_version gtest_version.cpp)

set_target_properties(
    helloworld_cli helloworld test_version gtest_version PROPERTIES

    CXX_STANDARD 14
    CXX_STANDARD_REQUIRED ON
    COMPILE_OPTIONS "-Wpedantic;-Wall;-Wextra"
)

set_target_properties(helloworld PROPERTIES
    # Use version.h from the binary directory
    INCLUDE_DIRECTORIES ${CMAKE_CURRENT_BINARY_DIR}
)

set_target_properties(test_version PROPERTIES
    COMPILE_DEFINITIONS BOOST_TEST_DYN_LINK
    INCLUDE_DIRECTORIES ${Boost_INCLUDE_DIR}
)

set_target_properties(gtest_version PROPERTIES
    # Use version.h from the binary directory
    INCLUDE_DIRECTORIES ${CMAKE_CURRENT_BINARY_DIR}
    INCLUDE_DIRECTORIES ${GTEST_INCLUDE_DIRS}
)

target_link_libraries(helloworld_cli
    helloworld
)

target_link_libraries(test_version
    ${Boost_LIBRARIES}
    helloworld
)

target_link_libraries(gtest_version
    ${GTEST_LIBRARIES}
    # For linking with static libgtest.a:
    # pthread
    helloworld
)


install(TARGETS helloworld_cli RUNTIME DESTINATION bin)

set(CPACK_GENERATOR DEB)

set(CPACK_PACKAGE_NAME helloworld)
set(CPACK_PACKAGE_VERSION "${PROJECT_VERSION}")
set(CPACK_DEBIAN_PACKAGE_ARCHITECTURE amd64)
set(CPACK_DEBIAN_PACKAGE_MAINTAINER "Anton Sochnev <an.sochnev@yandex.ru>")
set(CPACK_DEBIAN_PACKAGE_SECTION "homework")
set(CPACK_DEBIAN_PACKAGE_DESCRIPTION 
"hello world printer with version
 The first homework for otus-cpp course."
)
set(CPACK_PACKAGE_FILE_NAME ${CPACK_PACKAGE_NAME}-${CPACK_PACKAGE_VERSION})

include(CPack)

enable_testing()

add_test(test_version test_version)
add_test(gtest_version gtest_version)
