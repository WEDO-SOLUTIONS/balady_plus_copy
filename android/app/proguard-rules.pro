# Kotlin coroutines rules
-keep class kotlinx.coroutines.** { *; }
-keep class org.jetbrains.annotations.** { *; }
-dontwarn kotlinx.coroutines.**

-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}