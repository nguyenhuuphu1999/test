-keep class go.** { *; }
-keep class outline-go-tun2socks.** { *; }
-keep class org.golang.** { *; }

-keepclasseswithmembers class * {
    native <methods>;
}

-dontwarn okhttp3.**
-dontwarn okio.**
