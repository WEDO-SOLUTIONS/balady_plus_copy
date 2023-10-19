# Kotlin coroutines rules
-keep class kotlinx.coroutines.** { *; }
-keep class org.jetbrains.annotations.** { *; }
-dontwarn kotlinx.coroutines.**

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}


-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }


-keepattributes *Annotation*

-dontskipnonpubliclibraryclasses
-dontskipnonpubliclibraryclassmembers