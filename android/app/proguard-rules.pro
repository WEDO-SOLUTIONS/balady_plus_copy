# Kotlin coroutines rules
-keep class kotlinx.coroutines.** { *; }
-keep class org.jetbrains.annotations.** { *; }
-dontwarn kotlinx.coroutines.**



# This is a configuration file for ProGuard.
# http://proguard.sourceforge.net/index.html#manual/usage.html
# Optimizations: If you don't want to optimize, use the
# proguard-android.txt configuration file instead of this one, which
# turns off the optimization flags.  Adding optimization introduces
# certain risks, since for example not all optimizations performed by
# ProGuard works on all versions of Dalvik.  The following flags turn
# off various optimizations known to have issues, but the list may not
# be complete or up to date. (The "arithmetic" optimization can be
# used if you are only targeting Android 2.0 or later.)  Make sure you
# test thoroughly if you go this route.
-optimizations !code/simplification/arithmetic,!code/simplification/cast,!field/*,!class/merging/*
-optimizationpasses 5
-allowaccessmodification
-dontpreverify
# The remainder of this file is identical to the non-optimized version
# of the Proguard configuration file (except that the other file has
# flags to turn off optimization).
-dontusemixedcaseclassnames
-dontskipnonpubliclibraryclasses
-verbose
-keepattributes *Annotation*
-keep public class com.google.vending.licensing.ILicensingService
-keep public class com.android.vending.licensing.ILicensingService
# For native methods, see http://proguard.sourceforge.net/manual/examples.html#native
-keepclasseswithmembernames class * {
    native <methods>;
}
# keep setters in Views so that animations can still work.
# see http://proguard.sourceforge.net/manual/examples.html#beans
-keepclassmembers public class * extends android.view.View {
   void set*(***);
   *** get*();
}
# We want to keep methods in Activity that could be used in the XML attribute onClick
-keepclassmembers class * extends android.app.Activity {
   public void *(android.view.View);
}
# For enumeration classes, see http://proguard.sourceforge.net/manual/examples.html#enumerations
-keepclassmembers enum * {
    public static **[] values();
    public static ** valueOf(java.lang.String);
}
-keepclassmembers class * implements android.os.Parcelable {
  public static final android.os.Parcelable$Creator CREATOR;
}
-keepclassmembers class **.R$* {
    public static <fields>;
}
# The support library contains references to newer platform versions.
# Don't warn about those in case this app is linking against an older
# platform version.  We know about them, and they are safe.
-dontwarn android.support.**


-keep class io.flutter.app.** { *; }
-keep class io.flutter.plugin.** { *; }
-keep class io.flutter.util.** { *; }
-keep class io.flutter.view.** { *; }
-keep class io.flutter.** { *; }
-keep class io.flutter.plugins.** { *; }

-keepattributes *Annotation*

-dontskipnonpubliclibraryclasses
-dontskipnonpubliclibraryclassmembers

-keep class com.huawei.hms.** { *; }
-keep class com.huawei.libcore.** { *; }
-keep class com.huawei.libcore.io.** { *; }
-keepattributes EnclosingMethod

-dontwarn android.telephony.**
-dontwarn androidx.window.extensions.**
-dontwarn androidx.window.sidecar.**
-dontwarn com.huawei.android.os.**
-dontwarn com.huawei.hms.**
-dontwarn com.huawei.libcore.io.**


#insider sdk integration
-keep class com.useinsider.insider.Insider { *; }

-keep interface com.useinsider.insider.InsiderCallback { *; }
-keep class com.useinsider.insider.InsiderUser { *; }
-keep class com.useinsider.insider.InsiderProduct { *; }
-keep class com.useinsider.insider.InsiderEvent { *; }
-keep class com.useinsider.insider.InsiderCallbackType { *; }
-keep class com.useinsider.insider.InsiderGender { *; }
-keep class com.useinsider.insider.InsiderIdentifiers { *; }

-keep interface com.useinsider.insider.RecommendationEngine$SmartRecommendation { *; }
-keep interface com.useinsider.insider.MessageCenterData { *; }
-keep class com.useinsider.insider.Geofence { *; }
-keep class com.useinsider.insider.ContentOptimizerDataType { *; }
-keep class org.openudid.** { *; }
-keep class com.useinsider.insider.OpenUDID_manager { *; }


# Preserve generic signatures (needed for Gson TypeToken)
-keepattributes Signature

# Keep all classes that extend TypeToken
-keep class com.google.gson.reflect.TypeToken { *; }

# Keep Gson model classes (if applicable)
-keep class your.package.name.** { *; }  # Replace with your actual package name

# Keep all classes used by Flutter Local Notifications
-keep class com.dexterous.flutterlocalnotifications.** { *; }

# Keep Firebase and Google Play Services if you're using them
-keep class com.google.firebase.** { *; }
-keep class com.google.android.gms.** { *; }