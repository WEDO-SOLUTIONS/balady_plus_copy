package momra.balady.android

import android.content.Intent
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * Captures home-screen shortcut keys from launch/warm intents.
 * Uses the same extra key as [io.flutter.plugins.quickactions.QuickActions.EXTRA_ACTION].
 */
object AppIconQuickActionChannel {
    const val CHANNEL_NAME = "momra.balady/app_icon_quick_action"
    const val EXTRA_ACTION = "some unique action key"

    private var pendingShortcutKey: String? = null
    private var methodChannel: MethodChannel? = null

    fun register(messenger: BinaryMessenger) {
        methodChannel = MethodChannel(messenger, CHANNEL_NAME).also { channel ->
            channel.setMethodCallHandler { call, result ->
                when (call.method) {
                    "consumePendingShortcut" -> result.success(consumePending())
                    "peekPendingShortcut" -> result.success(peekPending())
                    else -> result.notImplemented()
                }
            }
        }
    }

    /// Stores the shortcut key without stripping the intent extra — [QuickActions.getLaunchAction] can still read it.
    fun captureFromIntent(intent: Intent?) {
        val key = intent?.getStringExtra(EXTRA_ACTION)?.takeIf { it.isNotEmpty() } ?: return
        store(key)
    }

    fun store(key: String) {
        pendingShortcutKey = key
    }

    private fun peekPending(): String? = pendingShortcutKey

    private fun consumePending(): String? {
        val key = pendingShortcutKey
        pendingShortcutKey = null
        return key
    }
}
