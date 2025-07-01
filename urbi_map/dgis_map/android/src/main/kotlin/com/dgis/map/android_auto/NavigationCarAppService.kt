package com.dgis.map.android_auto

import android.app.NotificationChannel
import android.app.NotificationManager
import android.content.Context
import android.content.pm.ServiceInfo
import android.os.Build
import android.util.Log
import androidx.car.app.CarAppService
import androidx.car.app.Session
import androidx.car.app.SessionInfo
import androidx.car.app.validation.HostValidator
import androidx.core.app.NotificationCompat
import androidx.core.graphics.drawable.IconCompat
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.dgis.FlutterProvider
import com.dgis.map.DgisMapInitializer
import com.dgis.map.R
import com.dgis.map.map_api.*


/** Entry point for the car app */
class NavigationCarAppService : CarAppService() {
    override fun onCreateSession(sessionInfo: SessionInfo): Session {
        FlutterProvider.getHostFlutterApi(this)
            .analyticsTrack("android_auto_start") { }
        DgisMapInitializer.init(applicationContext, VendorConfigMessage.MOMRAH_PROD)
        startForegroundNotification()
        val session = NavigationCarAppSession(sessionInfo, applicationContext)
        session.lifecycle.addObserver(object : DefaultLifecycleObserver {
            override fun onDestroy(owner: LifecycleOwner) = stopForeground(STOP_FOREGROUND_REMOVE)
        })
        return session
    }

    override fun createHostValidator(): HostValidator {
        return HostValidator.ALLOW_ALL_HOSTS_VALIDATOR
    }

    override fun onCreate() {
        super.onCreate()
        connectionState = CarAppConnectionState.CONNECTED
    }

    override fun onDestroy() {
        super.onDestroy()
        connectionState = CarAppConnectionState.DISCONNECTED

        if (MainAppScreenStateNotifier.state == MainAppScreenState.DESTROYED) {
            FlutterProvider.destroyFlutterEngine()
        }
    }

    private fun startForegroundNotification() {
        try {
            createNotificationChannel()

            val notification = getDefaultNotification(this).build()
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                val foregroundServiceType =
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) ServiceInfo.FOREGROUND_SERVICE_TYPE_LOCATION else 0
                startForeground(
                    notificationId, notification, foregroundServiceType
                )
            } else {
                startForeground(notificationId, notification)
            }
        } catch (e: Exception) {
            Log.e(tag, "startForeground: ", e)
        }
    }

    private fun createNotificationChannel() {
        val channel = NotificationChannel(
            channelId, channelName, NotificationManager.IMPORTANCE_LOW
        ).apply { setShowBadge(false) }
        getSystemService(NotificationManager::class.java)?.createNotificationChannel(channel)
    }

    companion object {
        const val channelId = "CarNavigationChannel"
        const val channelName = "Navigation Channel"
        const val notificationId = 1
        private const val tag = "NavigationCarAppService"

        var connectionState: CarAppConnectionState = CarAppConnectionState.DISCONNECTED

        fun getDefaultNotification(context: Context): NotificationCompat.Builder {
            return NotificationCompat.Builder(context, channelId)
                .setContentTitle(context.getString(R.string.driving_notification_title))
                .setSmallIcon(
                    IconCompat.createWithResource(context, R.drawable.logo_notification)
                )
//                .setPriority(NotificationCompat.PRIORITY_HIGH) // todo
        }
    }
}

enum class CarAppConnectionState {
    CONNECTED, DISCONNECTED
}
