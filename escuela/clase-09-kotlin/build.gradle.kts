plugins {
    kotlin("jvm") version "2.3.20"
    application
}

application {
    mainClass.set("InventarioKt")
}


repositories {
    mavenCentral()
}

dependencies {
    implementation(kotlin("stdlib"))
}
