# Giữ toàn bộ package Go Mobile (ví dụ go seq / mobileproxy)
-keep class go.** { *; }
-keep class mobileproxy.** { *; }
-keep class org.golang.** { *; }

# Giữ các lớp JNI loader
-keepclasseswithmembers class * {
    native <methods>;
}

# OkHttp warnings
-dontwarn okhttp3.**
-dontwarn okio.**

-keep class mobileproxy.** { *; }
-keep class go.** { *; }      # gomobile sinh gói go.*
-dontwarn go.**
