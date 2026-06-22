package momra.balady.android

import android.content.Context
import android.net.wifi.WifiManager
import android.os.PowerManager
import android.util.Log
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * Holds a partial wake lock + high-performance Wi-Fi lock while MBC live radio
 * is playing in the background.
 *
 * Why this exists:
 * - On many Android OEM ROMs and stock Doze, the Wi-Fi radio is throttled or
 *   turned off ~60-120 s after the screen turns off. HLS (`.m3u8`) chunked
 *   downloads then fail, ExoPlayer drops to `idle`, and the foreground media
 *   service is torn down. That matches the "MBC stops after 1-2 min with the
 *   screen locked" bug exactly.
 * - `JustAudioBackground` runs as a foreground service but does NOT acquire a
 *   Wi-Fi lock by default, and ExoPlayer's wake lock only keeps the CPU alive,
 *   not the radio.
 *
 * Lifecycle:
 * - `acquire()` is called from Flutter (`AudioService.playStream` on Android).
 * - `release()` is called from Flutter (`AudioService.stop`, `_cleanup`,
 *   dismissal).
 * - Both are idempotent and safe to call multiple times.
 */
class MbcLockBridge(private val context: Context) {

    companion object {
        private const val TAG = "MbcLockBridge"
        private const val CHANNEL = "com.balady.mbc_lock"
        private const val WAKE_LOCK_TAG = "Balady::MbcRadioWakeLock"
        private const val WIFI_LOCK_TAG = "Balady::MbcRadioWifiLock"
    }

    private var wakeLock: PowerManager.WakeLock? = null
    private var wifiLock: WifiManager.WifiLock? = null

    fun register(flutterEngine: FlutterEngine) {
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL)
            .setMethodCallHandler { call, result ->
                when (call.method) {
                    "acquire" -> {
                        acquire()
                        result.success(true)
                    }
                    "release" -> {
                        release()
                        result.success(true)
                    }
                    else -> result.notImplemented()
                }
            }
    }

    @Synchronized
    fun acquire() {
        try {
            if (wakeLock == null) {
                val pm = context.getSystemService(Context.POWER_SERVICE) as? PowerManager
                wakeLock = pm?.newWakeLock(PowerManager.PARTIAL_WAKE_LOCK, WAKE_LOCK_TAG)?.apply {
                    setReferenceCounted(false)
                }
            }
            wakeLock?.let { if (!it.isHeld) it.acquire() }

            if (wifiLock == null) {
                val wm = context.applicationContext.getSystemService(Context.WIFI_SERVICE) as? WifiManager
                wifiLock = wm?.createWifiLock(
                    WifiManager.WIFI_MODE_FULL_HIGH_PERF,
                    WIFI_LOCK_TAG,
                )?.apply {
                    setReferenceCounted(false)
                }
            }
            wifiLock?.let { if (!it.isHeld) it.acquire() }

            Log.d(
                TAG,
                "MBC locks acquired (wake=${wakeLock?.isHeld == true}, wifi=${wifiLock?.isHeld == true})",
            )
        } catch (t: Throwable) {
            Log.w(TAG, "Failed to acquire MBC locks", t)
        }
    }

    @Synchronized
    fun release() {
        try {
            wakeLock?.let { if (it.isHeld) it.release() }
            wifiLock?.let { if (it.isHeld) it.release() }
            Log.d(TAG, "MBC locks released")
        } catch (t: Throwable) {
            Log.w(TAG, "Failed to release MBC locks", t)
        }
    }
}

