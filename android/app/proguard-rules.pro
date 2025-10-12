-keep class go.** { *; }
-keep class mobileproxy.** { *; }
-keep class org.golang.** { *; }

-keepclasseswithmembers class * {
    native <methods>;
}

-dontwarn okhttp3.**
-dontwarn okio.**
