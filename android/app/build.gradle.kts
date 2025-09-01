//// File: android/app/build.gradle.kts
//import java.util.Properties
//import java.io.FileInputStream
//
//plugins {
//    id("com.android.application")
//    id("org.jetbrains.kotlin.android") // kotlin-android
//    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
//    id("dev.flutter.flutter-gradle-plugin")
//}
//
//// ---- Load signing from key.properties (fail-fast + log) ----
//val keystorePropertiesFile = rootProject.file("key.properties")
//val keystoreProperties = Properties().apply {
//    if (keystorePropertiesFile.exists()) {
//        FileInputStream(keystorePropertiesFile).use { fis -> load(fis) }
//    } else {
//        throw GradleException("key.properties not found at: ${keystorePropertiesFile.absolutePath}")
//    }
//}
//
//val storeFilePath = keystoreProperties.getProperty("storeFile")?.trim()
//    ?: throw GradleException("Missing 'storeFile' in key.properties")
//val storePasswordValue = keystoreProperties.getProperty("storePassword")?.trim()
//    ?: throw GradleException("Missing 'storePassword' in key.properties")
//val keyAliasValue = keystoreProperties.getProperty("keyAlias")?.trim()
//    ?: throw GradleException("Missing 'keyAlias' in key.properties")
//val keyPasswordValue = keystoreProperties.getProperty("keyPassword")?.trim()
//    ?: throw GradleException("Missing 'keyPassword' in key.properties")
//
//println("🔐 Using keystore: $storeFilePath | alias: $keyAliasValue")
//
//android {
//    namespace = "com.example.munchups_app"
//    compileSdk = flutter.compileSdkVersion
//    ndkVersion = flutter.ndkVersion
//
//    compileOptions {
//        sourceCompatibility = JavaVersion.VERSION_11
//        targetCompatibility = JavaVersion.VERSION_11
//    }
//    kotlinOptions {
//        jvmTarget = JavaVersion.VERSION_11.toString()
//    }
//
//    defaultConfig {
//        applicationId = "com.example.munchups_app"
//        minSdk = flutter.minSdkVersion
//        targetSdk = flutter.targetSdkVersion
//        versionCode = flutter.versionCode
//        versionName = flutter.versionName
//        multiDexEnabled = true
//    }
//
//    // ---- Signing configs must be defined BEFORE buildTypes ----
//    signingConfigs {
//        create("release") {
//            storeFile = file(storeFilePath)
//            storePassword = storePasswordValue
//            keyAlias = keyAliasValue
//            keyPassword = keyPasswordValue
//
//            enableV1Signing = true
//            enableV2Signing = true
//            enableV3Signing = true
//            enableV4Signing = true
//        }
//    }
//
//    buildTypes {
//        getByName("release") {
//            signingConfig = signingConfigs.getByName("release")
//            // You can enable these later once R8 rules are sorted
//            isMinifyEnabled = false
//            isShrinkResources = false
//            proguardFiles(
//                getDefaultProguardFile("proguard-android-optimize.txt"),
//                "proguard-rules.pro"
//            )
//        }
//        getByName("debug") {
//            // uses debug keystore automatically
//        }
//    }
//}
//
//flutter {
//    source = "../.."
//}

// File: android/app/build.gradle.kts
import java.util.Properties
import java.io.FileInputStream

plugins {
    id("com.android.application")
    id("org.jetbrains.kotlin.android") // kotlin-android
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

// ---- Load signing from key.properties (fail-fast + log) ----
val keystorePropertiesFile = rootProject.file("key.properties")
val keystoreProperties = Properties().apply {
    if (keystorePropertiesFile.exists()) {
        FileInputStream(keystorePropertiesFile).use { fis -> load(fis) }
    } else {
        throw GradleException("key.properties not found at: ${keystorePropertiesFile.absolutePath}")
    }
}

val storeFilePath = keystoreProperties.getProperty("storeFile")?.trim()
    ?: throw GradleException("Missing 'storeFile' in key.properties")
val storePasswordValue = keystoreProperties.getProperty("storePassword")?.trim()
    ?: throw GradleException("Missing 'storePassword' in key.properties")
val keyAliasValue = keystoreProperties.getProperty("keyAlias")?.trim()
    ?: throw GradleException("Missing 'keyAlias' in key.properties")
val keyPasswordValue = keystoreProperties.getProperty("keyPassword")?.trim()
    ?: throw GradleException("Missing 'keyPassword' in key.properties")

println("🔐 Using keystore: $storeFilePath | alias: $keyAliasValue")

android {
    namespace = "com.example.munchups_app"
    compileSdk = flutter.compileSdkVersion
    ndkVersion = flutter.ndkVersion

    compileOptions {
        sourceCompatibility = JavaVersion.VERSION_11
        targetCompatibility = JavaVersion.VERSION_11
    }
    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_11.toString()
    }

    defaultConfig {
        applicationId = "com.example.munchups_app"
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
        multiDexEnabled = true
    }

    // ---- Signing configs must be defined BEFORE buildTypes ----
    signingConfigs {
        create("release") {
            storeFile = file(storeFilePath)
            storePassword = storePasswordValue
            keyAlias = keyAliasValue
            keyPassword = keyPasswordValue

            enableV1Signing = true
            enableV2Signing = true
            enableV3Signing = true
            enableV4Signing = true
        }
    }

    buildTypes {
        getByName("release") {
            signingConfig = signingConfigs.getByName("release")
            // You can enable these later once R8 rules are sorted
            isMinifyEnabled = false
            isShrinkResources = false
            proguardFiles(
                getDefaultProguardFile("proguard-android-optimize.txt"),
                "proguard-rules.pro"
            )
        }
        getByName("debug") {
            // uses debug keystore automatically
        }
    }
}

flutter {
    source = "../.."
}