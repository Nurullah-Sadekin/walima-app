import java.util.Properties

plugins {
    id("com.android.application")
    id("kotlin-android")
    id("com.google.gms.google-services")
    id("com.google.firebase.crashlytics")
    // The Flutter Gradle Plugin must be applied after the Android and Kotlin Gradle plugins.
    id("dev.flutter.flutter-gradle-plugin")
}

val keystoreProperties = Properties()
val keystorePropertiesFile = rootProject.file("key.properties")
if (keystorePropertiesFile.exists()) {
    keystorePropertiesFile.inputStream().use { keystoreProperties.load(it) }
}

android {
    namespace = "com.walima.app"
    compileSdk = flutter.compileSdkVersion
    // Flutter 3.41 defaults to NDK 28.2.x, but that local install is incomplete on this machine.
    // Pin to a healthy installed NDK version so Gradle can configure the Android project.
    ndkVersion = "29.0.14033849"

    compileOptions {
        // Enable core library desugaring required by some dependencies (e.g. flutter_local_notifications)
        isCoreLibraryDesugaringEnabled = true
        sourceCompatibility = JavaVersion.VERSION_17
        targetCompatibility = JavaVersion.VERSION_17
    }

    kotlinOptions {
        jvmTarget = JavaVersion.VERSION_17.toString()
    }

    defaultConfig {
        // TODO: Specify your own unique Application ID (https://developer.android.com/studio/build/application-id.html).
        applicationId = "com.walima.app"
        // You can update the following values to match your application needs.
        // For more information, see: https://flutter.dev/to/review-gradle-config.
        minSdk = flutter.minSdkVersion
        targetSdk = flutter.targetSdkVersion
        versionCode = flutter.versionCode
        versionName = flutter.versionName
    }

    signingConfigs {
        create("release") {
            keyAlias = keystoreProperties.getProperty("keyAlias")?.trim()
            keyPassword = keystoreProperties.getProperty("keyPassword")?.trim()
            storeFile = file(
                keystoreProperties.getProperty("storeFile")?.trim()
                    ?.ifEmpty { "upload-keystore.jks" }
                    ?: "upload-keystore.jks"
            )
            storePassword = keystoreProperties.getProperty("storePassword")?.trim()
        }
    }

    buildTypes {
        release {
            signingConfig = signingConfigs.getByName("release")
        }
    }
}

flutter {
    source = "../.."
}

// Add the core library desugaring dependency required when desugaring is enabled.
dependencies {
    // Use a compatible desugar_jdk_libs version. If your Android Gradle Plugin requires a specific
    // version, update this accordingly. 2.0.3 is commonly compatible with newer AGP versions.
    coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.0.3")
}
