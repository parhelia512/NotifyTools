#ifndef TEST_SPDLOG_H
#define TEST_SPDLOG_H
#include <iostream>

#define SPDLOG 1

#if SPDLOG

#include <iostream>
#include "spdlog/spdlog.h"
#include "spdlog/fmt/ostr.h"

#include <fstream>
#include <cstdlib>
using namespace std;
void test_spdlog()
{
    spdlog::info("Welcome to spdlog!");
    spdlog::error("Some error message with arg: {}", 1);

    spdlog::warn("Easy padding in numbers like {:08d}", 12);
    spdlog::critical("Support for int: {0:d};  hex: {0:x};  oct: {0:o}; bin: {0:b}", 42);
    spdlog::info("Support for floats {:03.2f}", 1.23456);
    spdlog::info("Positional args are {1} {0}..", "too", "supported");
    spdlog::info("{:<30}", "left aligned");

    spdlog::set_level(spdlog::level::debug); // Set global log level to debug
    spdlog::debug("This message should be displayed..");

    // change log pattern
    spdlog::set_pattern("[%H:%M:%S %z] [%n] [%^---%L---%$] [thread %t] %v");

    // Compile time log levels
    // define SPDLOG_ACTIVE_LEVEL to desired level
    SPDLOG_TRACE("Some trace message with param {}", 42);
    SPDLOG_DEBUG("Some debug message");
}

int test_spdlog_main(int argc)
{
    test_spdlog();
    return 0;
}
#else
int test_spdlog_main(int argc)
{
    std::cout << "test_spdlog_main no glog \n";
    return 0;
}
#endif

#endif
