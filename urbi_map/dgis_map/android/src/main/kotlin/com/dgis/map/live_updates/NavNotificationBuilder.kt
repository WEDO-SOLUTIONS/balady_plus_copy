package com.dgis.map.live_updates

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.graphics.Color
import androidx.core.app.NotificationCompat
import androidx.core.graphics.drawable.IconCompat
import com.dgis.map.R
import com.dgis.map.android_auto.iconId
import ru.dgis.sdk.navigation.InstructionManeuver
import java.util.Locale
import kotlin.math.max
import kotlin.math.roundToLong

/**
 * Builds the phone ongoing navigation notification (and the arrival notification).
 *
 * Kept as a plain builder so a promoted Live Updates / Notification.ProgressStyle variant
 * can be layered on top later without touching the data plumbing.
 */
object NavNotificationBuilder {

    const val CHANNEL_ID = "NavigationLiveChannel"
    private const val CHANNEL_NAME = "Navigation"
    const val ACTION_END_TRIP = "com.dgis.map.live_updates.END_TRIP"
    private const val BRAND_COLOR = "#147674"
    private const val ARRIVAL_TIMEOUT_MS = 180_000L

    /** Rendered notification content; [key] is used for change detection / throttling. */
    data class Content(
        /** Distance to the next maneuver, or the GPS-lost / re-route status. */
        val title: String,
        /** "Towards <street>", falling back to the destination. */
        val text: String,
        /** Arrival time and time left, shown next to the app name. */
        val subText: String,
        val iconRes: Int,
    ) {
        val key: String get() = "$title|$text|$subText|$iconRes"
    }

    fun ensureChannel(context: Context) {
        val channel = NotificationChannel(
            CHANNEL_ID, CHANNEL_NAME, NotificationManager.IMPORTANCE_DEFAULT
        ).apply {
            setShowBadge(false)
            setSound(null, null)
            enableVibration(false)
        }
        context.getSystemService(NotificationManager::class.java)?.createNotificationChannel(channel)
    }

    fun renderContent(
        context: Context,
        metadata: LiveUpdatesCoordinator.SessionMetadata,
        eta: NavEta?,
        maneuver: NavManeuver?,
        message: String = "none",
    ): Content {
        val res = localizedContext(context, metadata.language)

        // While the engine is looking for the location or rebuilding the route the
        // distance is meaningless — show the same status the in-app card shows.
        val statusTitle = when (message) {
            "gpsLost" -> res.getString(R.string.live_update_gps_lost)
            "routeResearch" -> res.getString(R.string.live_update_reroute)
            else -> null
        }
        val distanceTitle = maneuver
            ?.takeIf { it.distanceMm > 0 }
            ?.let { formatDistance(res, it.distanceMm) }
        val title = statusTitle
            ?: distanceTitle
            ?: res.getString(R.string.driving_notification_title)

        val street = maneuver?.roadName?.takeIf { it.isNotBlank() }
        val text = when {
            street != null -> res.getString(R.string.live_update_towards_format, street)
            else -> metadata.destinationName?.takeIf { it.isNotBlank() }.orEmpty()
        }

        val subText = if (eta != null) {
            listOf(
                res.getString(R.string.live_update_eta_format, eta.arrivalTime),
                formatRemaining(res, eta.durationSec),
            ).joinToString(" • ")
        } else {
            ""
        }

        return Content(
            title = title,
            text = text,
            subText = subText,
            iconRes = maneuverIcon(maneuver),
        )
    }

    /**
     * Ongoing state: Balady mark, distance to the maneuver and the street it leads to.
     * No actions — like on iOS, "End trip" only shows up on the arrival card.
     */
    fun buildOngoing(
        context: Context,
        metadata: LiveUpdatesCoordinator.SessionMetadata,
        content: Content,
    ): Notification {
        return NotificationCompat.Builder(context, CHANNEL_ID)
            .setContentTitle(content.title)
            .setContentText(content.text)
            .setSubText(content.subText)
            .setSmallIcon(IconCompat.createWithResource(context, content.iconRes))
            .setLargeIcon(appMark(context))
            // Not colorized: the design keeps the system card and puts the brand
            // colour on the icon only.
            .setColor(Color.parseColor(BRAND_COLOR))
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setSilent(true)
            .setCategory(NotificationCompat.CATEGORY_NAVIGATION)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setShowWhen(false)
            .setContentIntent(openAppPendingIntent(context))
            .build()
    }

    /** Arrival card: destination plus the two actions from the design. */
    fun buildArrival(
        context: Context,
        metadata: LiveUpdatesCoordinator.SessionMetadata,
    ): Notification {
        val res = localizedContext(context, metadata.language)
        return NotificationCompat.Builder(context, CHANNEL_ID)
            .setContentTitle(res.getString(R.string.end_trip_alert_title))
            .setContentText(
                metadata.destinationName?.takeIf { it.isNotBlank() }
                    ?: res.getString(R.string.live_update_arrived_message)
            )
            .setSmallIcon(IconCompat.createWithResource(context, R.drawable.finish))
            .setLargeIcon(appMark(context))
            .setColor(Color.parseColor(BRAND_COLOR))
            .addAction(
                0,
                res.getString(R.string.live_update_open_action),
                openAppPendingIntent(context),
            )
            .addAction(
                0,
                res.getString(R.string.live_update_end_trip_action),
                endTripPendingIntent(context),
            )
            .setOngoing(false)
            .setAutoCancel(true)
            .setOnlyAlertOnce(true)
            .setSilent(true)
            .setCategory(NotificationCompat.CATEGORY_NAVIGATION)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setTimeoutAfter(ARRIVAL_TIMEOUT_MS)
            .setContentIntent(openAppPendingIntent(context))
            .build()
    }

    /** The Balady mark shown on the left of the notification, as in the design. */
    private fun appMark(context: Context): Bitmap? =
        BitmapFactory.decodeResource(context.resources, R.drawable.logo_notification)

    private fun openAppPendingIntent(context: Context): PendingIntent? {
        val launchIntent =
            context.packageManager.getLaunchIntentForPackage(context.packageName) ?: return null
        return PendingIntent.getActivity(
            context,
            0,
            launchIntent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun endTripPendingIntent(context: Context): PendingIntent {
        val intent = Intent(context, EndTripReceiver::class.java).setAction(ACTION_END_TRIP)
        return PendingIntent.getBroadcast(
            context,
            1,
            intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
    }

    private fun maneuverIcon(maneuver: NavManeuver?): Int {
        val instruction = maneuver?.instructionName?.let { name ->
            try {
                InstructionManeuver.valueOf(name)
            } catch (e: IllegalArgumentException) {
                null
            }
        }
        return instruction?.iconId() ?: R.drawable.logo_notification
    }

    /** mm -> "340 m" / "1.2 km" with bucketed rounding: <100m step 10, <1km step 50, else 0.1 km. */
    private fun formatDistance(res: Context, distanceMm: Long): String {
        val meters = distanceMm / 1000.0
        return when {
            meters < 100 -> {
                val bucketed = max(10L, (meters / 10.0).roundToLong() * 10)
                "$bucketed ${res.getString(R.string.meter)}"
            }
            meters < 1000 -> {
                val bucketed = (meters / 50.0).roundToLong() * 50
                "$bucketed ${res.getString(R.string.meter)}"
            }
            else -> {
                val km = String.format(Locale.ENGLISH, "%.1f", meters / 1000.0)
                "$km ${res.getString(R.string.kilometer)}"
            }
        }
    }

    /** Seconds -> "5 min" / "1 h 20 min". */
    private fun formatRemaining(res: Context, durationSec: Int): String {
        val totalMinutes = max(1L, ((durationSec + 30) / 60).toLong())
        val hours = totalMinutes / 60
        val minutes = totalMinutes % 60
        val minutesUnit = res.getString(R.string.minutesShort)
        return if (hours > 0) {
            val hoursUnit = res.getString(R.string.hoursShort)
            if (minutes > 0) "$hours $hoursUnit $minutes $minutesUnit" else "$hours $hoursUnit"
        } else {
            "$minutes $minutesUnit"
        }
    }

    private fun localizedContext(context: Context, language: String): Context {
        val tag = language.ifBlank { "en" }.replace('_', '-')
        val locale = Locale.forLanguageTag(tag)
        val config = Configuration(context.resources.configuration)
        config.setLocale(locale)
        return context.createConfigurationContext(config)
    }
}
