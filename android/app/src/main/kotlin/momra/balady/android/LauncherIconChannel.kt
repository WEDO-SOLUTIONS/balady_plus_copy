package momra.balady.android

import android.content.ComponentName
import android.content.Context
import android.content.pm.PackageManager
import android.util.Log
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * Switches the launcher icon by toggling the `activity-alias` entries declared
 * in AndroidManifest.xml (`.MainActivityDefault` / `.MainActivityNationalDay`).
 *
 * Replaces `flutter_dynamic_icon_plus` on Android. That plugin hands the swap
 * to a background Service which is never declared in the manifest, so on this
 * app the icon never actually changed. This applies the change synchronously
 * with [PackageManager.DONT_KILL_APP], so the running process survives.
 *
 * The target alias is always enabled *before* the others are disabled, so the
 * app never momentarily has zero launcher entries.
 *
 * Known launcher caveats, inherent to the alias approach:
 *  * Home-screen shortcuts pinned to the alias being disabled are dropped.
 *  * Some OEM launchers (EMUI in particular) cache the icon drawable and may
 *    keep showing the old one until the home screen is refreshed.
 */
object LauncherIconChannel {
    const val CHANNEL_NAME = "momra.balady/launcher_icon"
    private const val TAG = "LauncherIconChannel"

    /** Manifest-relative alias names. Order is irrelevant; exactly one is ever enabled. */
    private val ALIASES = listOf(".MainActivityDefault", ".MainActivityNationalDay")

    private var appContext: Context? = null
    private var channel: MethodChannel? = null

    fun register(context: Context, messenger: BinaryMessenger) {
        appContext = context.applicationContext
        channel = MethodChannel(messenger, CHANNEL_NAME).also { ch ->
            ch.setMethodCallHandler { call, result ->
                when (call.method) {
                    "getEnabledAlias" -> result.success(enabledAlias())
                    "setEnabledAlias" -> {
                        val alias = call.argument<String>("alias")
                        if (alias.isNullOrEmpty() || alias !in ALIASES) {
                            result.error("bad_alias", "alias must be one of $ALIASES, got '$alias'", null)
                            return@setMethodCallHandler
                        }
                        try {
                            setEnabledAlias(alias)
                            result.success(true)
                        } catch (e: Exception) {
                            Log.w(TAG, "setEnabledAlias($alias) failed", e)
                            result.error("set_failed", e.message, null)
                        }
                    }
                    else -> result.notImplemented()
                }
            }
        }
    }

    /** The manifest-relative name of the alias currently enabled, or null if none is. */
    private fun enabledAlias(): String? {
        val context = appContext ?: return null
        val pm = context.packageManager
        return ALIASES.firstOrNull { isEnabled(pm, componentName(context, it)) }
    }

    private fun setEnabledAlias(target: String) {
        val context = appContext ?: throw IllegalStateException("LauncherIconChannel not registered")
        val pm = context.packageManager
        val current = enabledAlias()
        if (current == target) {
            return
        }

        Log.i(TAG, "Switching launcher alias ${current ?: "<none>"} -> $target")

        pm.setComponentEnabledSetting(
            componentName(context, target),
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED,
            PackageManager.DONT_KILL_APP,
        )

        ALIASES.filter { it != target }.forEach { alias ->
            pm.setComponentEnabledSetting(
                componentName(context, alias),
                PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
                PackageManager.DONT_KILL_APP,
            )
        }
    }

    private fun componentName(context: Context, alias: String): ComponentName =
        ComponentName(context, context.packageName + alias)

    /**
     * Resolves the effective enabled state. PackageManager reports
     * `COMPONENT_ENABLED_STATE_DEFAULT` until the app first changes a
     * component, in which case the manifest's `android:enabled` value wins.
     */
    private fun isEnabled(pm: PackageManager, cn: ComponentName): Boolean =
        when (pm.getComponentEnabledSetting(cn)) {
            PackageManager.COMPONENT_ENABLED_STATE_ENABLED -> true
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED_USER,
            PackageManager.COMPONENT_ENABLED_STATE_DISABLED_UNTIL_USED -> false
            else -> manifestDefault(pm, cn)
        }

    private fun manifestDefault(pm: PackageManager, cn: ComponentName): Boolean = try {
        @Suppress("DEPRECATION")
        pm.getActivityInfo(cn, PackageManager.GET_DISABLED_COMPONENTS).enabled
    } catch (e: PackageManager.NameNotFoundException) {
        Log.w(TAG, "Alias ${cn.className} not declared in the manifest")
        false
    }
}
