plugins {
    id("org.jetbrains.kotlin.jvm") version "2.3.10"
}

repositories {
    mavenCentral()
}

kotlin {
    compilerOptions {
        jvmTarget.set(org.jetbrains.kotlin.gradle.dsl.JvmTarget.JVM_21)
    }
}

tasks.withType<JavaExec>().configureEach {
    systemProperty("file.encoding", "UTF-8")
    systemProperty("sun.jnu.encoding", "UTF-8")
}
