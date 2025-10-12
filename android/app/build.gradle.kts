plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android")
    // Flutter Gradle Plugin phải apply sau Android & Kotlin
    id("dev.flutter.flutter-gradle-plugin")
}

android {
    namespace = "com.example.vpncn2_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    defaultConfig {
        applicationId = "com.example.vpncn2_app"
        // minSdk 29 for CordovaLib compatibility
        minSdk = 29
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }
    
    // Suppress deprecation warnings
    tasks.withType<JavaCompile> {
        options.compilerArgs.addAll(listOf("-Xlint:-deprecation", "-Xlint:-options"))
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
        freeCompilerArgs += listOf("-Xsuppress-version-warnings")
    }

    // Đảm bảo ABI khớp .so trong AAR
    splits {
        abi {
            isEnable = true
            reset()
            include("x86_64", "armeabi-v7a", "arm64-v8a")
            isUniversalApk = true
        }
    }

     buildTypes {
         release {
             // ký tạm bằng debug cho chạy nhanh
             signingConfig = signingConfigs.getByName("debug")
             isMinifyEnabled = false
             isShrinkResources = false
             ndk {
                 abiFilters += listOf("x86_64", "armeabi-v7a", "arm64-v8a")
             }
         }
         debug {
             isMinifyEnabled = false
             isShrinkResources = false
             ndk {
                 abiFilters += listOf("x86_64", "armeabi-v7a", "arm64-v8a")
             }
         }
     }
     
     // Disable duplicate class checking for Go runtime conflicts
     lint {
         checkReleaseBuilds = false
     }

    // Để AAR load JNI libs ổn định
    packaging {
        jniLibs {
            useLegacyPackaging = true
        }
        resources {
            excludes += setOf("META-INF/*")
        }
        // Exclude duplicate Go classes
        pickFirsts += setOf(
            "go/Seq.class",
            "go/Seq\$GoObject.class",
            "go/Seq\$GoRef.class",
            "go/Seq\$GoRefQueue.class",
            "go/Seq\$GoRefQueue\$1.class",
            "go/Seq\$Proxy.class",
            "go/Seq\$Ref.class",
            "go/Seq\$RefMap.class",
            "go/Seq\$RefTracker.class",
            "go/Universe.class",
            "go/Universe\$proxyerror.class",
            "go/error.class"
        )
    }

    sourceSets {
        getByName("main") {
            // nếu bạn có .so rải riêng, có thể thêm ở đây
            jniLibs.srcDirs("src/main/jniLibs", "libs/jni")
        }
    }
}

flutter {
    source = "../.."
}

// Add local maven repository for Outline dependencies
repositories {
    maven {
        url = uri("../local-maven-repo")
    }
}

// Disable duplicate class checking for Go runtime conflicts
afterEvaluate {
    tasks.findByName("checkDebugDuplicateClasses")?.enabled = false
}

dependencies {
    implementation(files("libs/mobileproxy.aar"))
    implementation("com.squareup.okhttp3:okhttp:4.12.0")
    
    implementation("org.apache.commons:commons-collections4:4.4")
    implementation("androidx.annotation:annotation:1.9.1")
}
