#include "SignalHandle.h"
#include <gtest/gtest.h>
using namespace sfutils;
#include <stdlib.h>
#include <signal.h>
// #define __built_in_return_address(x) t(x)
TEST(testCase, test0)
{
    int i, j, sum;
    sum = 0;
    j = 0;
    i = 6;
    // sum = i / j;
    EXPECT_EQ(2 + 3, 5);
}
void sigsegv_test()
{
    std::cout << __func__ << " begin" << std::endl;

    char* buff = NULL;
    buff[1] = buff[1]; /* will crash here */
    std::cout << __func__ << " end" << std::endl;
}
GTEST_API_ int main(int argc, char** argv)
{
    testing::InitGoogleTest(&argc, argv);
    SignalHandle::GetInstance();
    int rtn = RUN_ALL_TESTS();
    sigsegv_test();
    return rtn;
}