package com.dgis.map.live_updates

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.content.res.Configuration
import android.graphics.Color
import android.graphics.drawable.Icon
import android.os.Build
import androidx.annotation.RequiresApi
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

    /** Progress bar resolution; shares and progress are expressed in these units. */
    private const val PROGRESS_STEPS = 1000
    private const val TRAFFIC_FREE = "#2AB3A9"
    private const val TRAFFIC_JAM = "#FFEF03"
    private const val TRAFFIC_CONGESTION = "#F63319"
    private const val TRAFFIC_DEEP_CONGESTION = "#A81F0F"
    private const val TRAFFIC_UNKNOWN = "#8A8A8E"

    /** Rendered notification content; [key] is used for change detection / throttling. */
    data class Content(
        /** Distance to the next maneuver, or the GPS-lost / re-route status. */
        val title: String,
        /** "Towards <street>", falling back to the destination. */
        val text: String,
        /** Arrival time and time left, shown next to the app name. */
        val subText: String,
        val iconRes: Int,
        /** Travelled share of the route, 0..1. */
        val progress: Double,
        /** Traffic colouring for the Android 16 Live Update progress bar. */
        val trafficSegments: List<NavTrafficSegment>,
    ) {
        val key: String
            get() = "$title|$text|$subText|$iconRes|${(progress * PROGRESS_STEPS).toInt()}|" +
                trafficSegments.joinToString(",") { "${(it.share * PROGRESS_STEPS).toInt()}:${it.level}" }
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
            "gpsLost" -> metadata.string("gps_lost") { res.getString(R.string.live_update_gps_lost) }
            "routeResearch" -> metadata.string("reroute") { res.getString(R.string.live_update_reroute) }
            else -> null
        }
        val distanceTitle = maneuver
            ?.takeIf { it.distanceMm > 0 }
            ?.let { formatDistance(res, metadata, it.distanceMm) }
        val freeRoam = metadata.mode == "freeRoam"
        val title = statusTitle
            ?: (if (freeRoam) metadata.string("free_roam") { res.getString(R.string.free_roam) } else distanceTitle)
            ?: res.getString(R.string.driving_notification_title)

        val street = maneuver?.roadName?.takeIf { it.isNotBlank() }
        val text = when {
            street != null -> res.getString(R.string.live_update_towards_format, street)
            else -> metadata.destinationName?.takeIf { it.isNotBlank() }.orEmpty()
        }

        val subText = if (eta != null) {
            listOf(
                res.getString(R.string.live_update_eta_format, eta.arrivalTime),
                formatRemaining(res, metadata, eta.durationSec),
            ).joinToString(" • ")
        } else {
            ""
        }

        return Content(
            title = title,
            text = text,
            subText = if (freeRoam) "" else subText,
            iconRes = if (freeRoam) R.drawable.logo_notification else maneuverIcon(maneuver),
            // No route in free roam, so no timeline either.
            progress = if (freeRoam) 0.0 else eta?.progress ?: 0.0,
            trafficSegments = if (freeRoam) emptyList() else eta?.trafficSegments.orEmpty(),
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
            // No large icon: the system already shows the Balady app icon on the
            // leading edge, which is what the design asks for.
            .setColor(Color.parseColor(BRAND_COLOR))
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setSilent(true)
            .setCategory(NotificationCompat.CATEGORY_NAVIGATION)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setShowWhen(false)
            .setContentIntent(openAppPendingIntent(context))
            .build()
            .let {
                if (Build.VERSION.SDK_INT >= 36 && content.trafficSegments.isNotEmpty()) {
                    asLiveUpdate(context, it, content)
                } else {
                    it
                }
            }
    }

    /**
     * Android 16+ only: adds the segmented traffic timeline and lets the system
     * promote the notification to a Live Update (status bar chip + a prominent
     * lock screen card). Promotion additionally requires an ongoing, colorized
     * notification, hence the extra flag here.
     */
    @RequiresApi(36)
    private fun asLiveUpdate(
        context: Context,
        notification: Notification,
        content: Content,
    ): Notification {
        val segments = progressSegments(content)
        if (segments.isEmpty()) return notification

        val style = Notification.ProgressStyle()
            .setProgressSegments(segments)
            .setProgress((content.progress.coerceIn(0.0, 1.0) * PROGRESS_STEPS).toInt())
            .setProgressTrackerIcon(Icon.createWithResource(context, R.drawable.nav_progress_marker))

        val builder = Notification.Builder.recoverBuilder(context, notification)
            .setStyle(style)
            // Status bar chip while the shade is closed.
            .setShortCriticalText(content.title)
            .setColorized(true)
        requestPromotion(builder)
        return builder.build()
    }

    /**
     * Notification.Builder#setRequestPromotedOngoing arrived in Android 16 QPR1, which
     * is newer than the SDK this module compiles against — ask for the promotion
     * reflectively and fall back to a plain ongoing notification when it is missing.
     */
    private fun requestPromotion(builder: Notification.Builder) {
        try {
            Notification.Builder::class.java
                .getMethod("setRequestPromotedOngoing", Boolean::class.javaPrimitiveType)
                .invoke(builder, true)
        } catch (e: ReflectiveOperationException) {
            // Older Android 16 build — the system decides on its own.
        }
    }

    @RequiresApi(36)
    private fun progressSegments(content: Content): List<Notification.ProgressStyle.Segment> {
        if (content.trafficSegments.isEmpty()) {
            // Pedestrian routes carry no traffic — a single plain bar.
            return listOf(
                Notification.ProgressStyle.Segment(PROGRESS_STEPS)
                    .setColor(Color.parseColor(TRAFFIC_FREE))
            )
        }
        return content.trafficSegments.mapNotNull { segment ->
            val length = (segment.share * PROGRESS_STEPS).toInt()
            if (length <= 0) {
                null
            } else {
                Notification.ProgressStyle.Segment(length)
                    .setColor(Color.parseColor(trafficColor(segment.level)))
            }
        }
    }

    /** Same palette as the iOS widget timeline. */
    private fun trafficColor(level: Int): String = when (level) {
        1 -> TRAFFIC_FREE
        2 -> TRAFFIC_JAM
        3 -> TRAFFIC_CONGESTION
        4 -> TRAFFIC_DEEP_CONGESTION
        else -> TRAFFIC_UNKNOWN
    }

    /** Arrival card: destination plus the two actions from the design. */
    fun buildArrival(
        context: Context,
        metadata: LiveUpdatesCoordinator.SessionMetadata,
    ): Notification {
        val res = localizedContext(context, metadata.language)
        return NotificationCompat.Builder(context, CHANNEL_ID)
            .setContentTitle(metadata.string("arrived") { res.getString(R.string.live_update_arrived_title) })
            .setContentText(
                metadata.destinationName?.takeIf { it.isNotBlank() }
                    ?: res.getString(R.string.live_update_arrived_message)
            )
            .setSmallIcon(IconCompat.createWithResource(context, R.drawable.finish))
            .setColor(Color.parseColor(BRAND_COLOR))
            .addAction(
                0,
                res.getString(R.string.live_update_open_action),
                openAppPendingIntent(context),
            )
            .addAction(
                0,
                metadata.string("end_trip") { res.getString(R.string.live_update_end_trip_action) },
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

    /** App copy for [key], falling back to the plugin's own resources. */
    private inline fun LiveUpdatesCoordinator.SessionMetadata.string(
        key: String,
        fallback: () -> String,
    ): String = strings[key]?.takeIf { it.isNotBlank() } ?: fallback()

    /** mm -> "340 m" / "1.2 km" with bucketed rounding: <100m step 10, <1km step 50, else 0.1 km. */
    private fun formatDistance(
        res: Context,
        metadata: LiveUpdatesCoordinator.SessionMetadata,
        distanceMm: Long,
    ): String {
        val meters = distanceMm / 1000.0
        val meterUnit = metadata.string("m") { res.getString(R.string.meter) }
        return when {
            meters < 100 -> {
                val bucketed = max(10L, (meters / 10.0).roundToLong() * 10)
                "$bucketed $meterUnit"
            }
            meters < 1000 -> {
                val bucketed = (meters / 50.0).roundToLong() * 50
                "$bucketed $meterUnit"
            }
            else -> {
                val km = String.format(Locale.ENGLISH, "%.1f", meters / 1000.0)
                "$km ${metadata.string("km") { res.getString(R.string.kilometer) }}"
            }
        }
    }

    /** Seconds -> "5 min" / "1 h 20 min". */
    private fun formatRemaining(
        res: Context,
        metadata: LiveUpdatesCoordinator.SessionMetadata,
        durationSec: Int,
    ): String {
        val totalMinutes = max(1L, ((durationSec + 30) / 60).toLong())
        val hours = totalMinutes / 60
        val minutes = totalMinutes % 60
        val minutesUnit = metadata.string("min") { res.getString(R.string.minutesShort) }
        return if (hours > 0) {
            val hoursUnit = metadata.string("h") { res.getString(R.string.hoursShort) }
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
