#include <gtest/gtest.h>
#include "lib.h"

TEST(TestVersion, NonZeroVersion) {
    ASSERT_GT(version(), 0);
}

int main(int argc, char** argv) {
    testing::InitGoogleTest(&argc, argv);
    return RUN_ALL_TESTS();
}
