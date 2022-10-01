cmake_minimum_required(VERSION 3.18)

project(lake VERSION 0.0.1)

set(CMAKE_CXX_STANDARD 14)

find_package(verilator HINTS $ENV{VERILATOR_ROOT})

include(FetchContent)
FetchContent_Declare(
    googletest
    GIT_REPOSITORY https://github.com/google/googletest.git
    GIT_TAG release-1.12.1
)
FetchContent_MakeAvailable(googletest)

enable_testing()

add_executable(lake_test tests/lake_test.cc)
verilate(lake_test
    VERILATOR_ARGS --trace
    SOURCES lake.v
)
target_link_libraries(lake_test GTest::gtest_main)

include(GoogleTest)
gtest_discover_tests(lake_test)
