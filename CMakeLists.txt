cmake_minimum_required(VERSION 3.2)

################################################################################
# See https://github.com/google/googletest/tree/master/googletest

# Download and unpack googletest at configure time
configure_file(CMakeLists.txt.in googletest-download/CMakeLists.txt)
execute_process(COMMAND "${CMAKE_COMMAND}" -G "${CMAKE_GENERATOR}" .
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/googletest-download" )
execute_process(COMMAND "${CMAKE_COMMAND}" --build .
    WORKING_DIRECTORY "${CMAKE_BINARY_DIR}/googletest-download" )

# Prevent GoogleTest from overriding our compiler/linker options
# when building with Visual Studio
set(gtest_force_shared_crt ON CACHE BOOL "" FORCE)

# Add googletest directly to our build. This adds
# the following targets: gtest, gtest_main
add_subdirectory("${CMAKE_BINARY_DIR}/googletest-src"
                 "${CMAKE_BINARY_DIR}/googletest-build")

# The gtest targets carry header search path dependencies 
# automatically when using CMake 2.8.11 or later. 

# Now simply link your own targets against gtest.
################################################################################


project(helloworld VERSION 1.0.$ENV{TRAVIS_BUILD_NUMBER})

find_package(Boost COMPONENTS unit_test_framework REQUIRED)

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
)

target_link_libraries(helloworld_cli helloworld)
target_link_libraries(test_version ${Boost_LIBRARIES} helloworld)
target_link_libraries(gtest_version helloworld gtest)


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
