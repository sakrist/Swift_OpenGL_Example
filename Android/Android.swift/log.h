#include <android/log.h>


static inline print_log(const char *str) {
    __android_log_print(ANDROID_LOG_INFO, "SwiftAndroid", "%s", str);
}
