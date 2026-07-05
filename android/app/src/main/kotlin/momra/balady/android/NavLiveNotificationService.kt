package momra.balady.android

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.Color
import android.graphics.Paint
import android.graphics.Path
import android.graphics.RectF
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.widget.RemoteViews
import androidx.core.app.NotificationCompat
import kotlin.math.max
import kotlin.math.min
import kotlin.math.sin

/**
 * Demo of a "live" navigation notification (ongoing + lock screen).
 *
 * Shows mocked turn-by-turn state: distance to the next maneuver, current street,
 * current / max speed, and a traffic-colored route bar with an arrow marking the
 * car position. A 1-second timer mutates the mock state and re-posts the
 * notification so it visibly updates in the shade and on the lock screen.
 */
class NavLiveNotificationService : Service() {

    // ---- Mock route model -------------------------------------------------

    private data class Leg(val street: String, val lengthMeters: Double, val maxSpeedKmh: Int)

    /** Traffic segment along the whole route: fraction of total length + jam color. */
    private data class TrafficSegment(val fraction: Double, val color: Int)

    private val legs = listOf(
        Leg("King Fahd Rd", 1200.0, 90),
        Leg("Olaya St", 800.0, 60),
        Leg("Tahlia St", 1500.0, 80),
        Leg("King Abdullah Rd", 2100.0, 100),
        Leg("Northern Ring Rd", 1700.0, 110),
    )

    private val trafficSegments = listOf(
        TrafficSegment(0.18, TRAFFIC_GREEN),
        TrafficSegment(0.10, TRAFFIC_YELLOW),
        TrafficSegment(0.08, TRAFFIC_RED),
        TrafficSegment(0.22, TRAFFIC_GREEN),
        TrafficSegment(0.12, TRAFFIC_YELLOW),
        TrafficSegment(0.07, TRAFFIC_RED),
        TrafficSegment(0.23, TRAFFIC_GREEN),
    )

    private val totalRouteMeters = legs.sumOf { it.lengthMeters }

    // ---- Mutable mock state ----------------------------------------------

    private var legIndex = 0
    private var traveledInLegMeters = 0.0
    private var traveledTotalMeters = 0.0
    private var currentSpeedKmh = 48.0
    private var tick = 0

    private val handler = Handler(Looper.getMainLooper())
    private val updateRunnable = object : Runnable {
        override fun run() {
            advanceMockState()
            notificationManager.notify(NOTIFICATION_ID, buildNotification())
            handler.postDelayed(this, UPDATE_INTERVAL_MS)
        }
    }

    private val notificationManager: NotificationManager
        get() = getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    // ---- Service lifecycle -------------------------------------------------

    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == ACTION_STOP) {
            stopSelf()
            return START_NOT_STICKY
        }

        createChannel()
        val notification = buildNotification()
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.UPSIDE_DOWN_CAKE) {
            startForeground(NOTIFICATION_ID, notification, ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE)
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }

        handler.removeCallbacks(updateRunnable)
        handler.postDelayed(updateRunnable, UPDATE_INTERVAL_MS)
        return START_NOT_STICKY
    }

    override fun onDestroy() {
        handler.removeCallbacks(updateRunnable)
        super.onDestroy()
    }

    // ---- Mock simulation ----------------------------------------------------

    private fun advanceMockState() {
        tick++
        val leg = legs[legIndex]

        // Speed drifts around ~70% of the leg's limit with a gentle sine wobble.
        val target = leg.maxSpeedKmh * 0.7
        currentSpeedKmh = (target + sin(tick / 5.0) * 12.0).coerceIn(20.0, leg.maxSpeedKmh.toDouble())

        val deltaMeters = currentSpeedKmh / 3.6 * (UPDATE_INTERVAL_MS / 1000.0)
        traveledInLegMeters += deltaMeters
        traveledTotalMeters += deltaMeters

        if (traveledInLegMeters >= leg.lengthMeters) {
            traveledInLegMeters = 0.0
            legIndex = (legIndex + 1) % legs.size
        }
        if (traveledTotalMeters >= totalRouteMeters) {
            // Loop the demo route.
            traveledTotalMeters = 0.0
            traveledInLegMeters = 0.0
            legIndex = 0
        }
    }

    // ---- Notification building -----------------------------------------------

    private fun createChannel() {
        val channel = NotificationChannel(
            CHANNEL_ID,
            "Live navigation",
            NotificationManager.IMPORTANCE_DEFAULT,
        ).apply {
            description = "Turn-by-turn navigation status"
            setSound(null, null)
            enableVibration(false)
            setShowBadge(false)
            lockscreenVisibility = Notification.VISIBILITY_PUBLIC
        }
        notificationManager.createNotificationChannel(channel)
    }

    private fun buildNotification(): Notification {
        val leg = legs[legIndex]
        val distanceToManeuver = max(0.0, leg.lengthMeters - traveledInLegMeters)
        val routeFraction = (traveledTotalMeters / totalRouteMeters).coerceIn(0.0, 1.0)

        val views = RemoteViews(packageName, R.layout.notification_nav_live).apply {
            setTextViewText(R.id.nav_live_distance, formatDistance(distanceToManeuver))
            setTextViewText(R.id.nav_live_street, leg.street)
            setTextViewText(
                R.id.nav_live_speed,
                "${currentSpeedKmh.toInt()} / ${leg.maxSpeedKmh} km/h",
            )
            setImageViewBitmap(R.id.nav_live_route_bar, renderRouteBar(routeFraction))
        }

        val contentIntent = PendingIntent.getActivity(
            this,
            0,
            Intent(this, MainActivity::class.java),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )
        val stopIntent = PendingIntent.getService(
            this,
            1,
            Intent(this, NavLiveNotificationService::class.java).setAction(ACTION_STOP),
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE,
        )

        return NotificationCompat.Builder(this, CHANNEL_ID)
            .setSmallIcon(R.drawable.ic_nav_live_arrow)
            .setStyle(NotificationCompat.DecoratedCustomViewStyle())
            .setCustomContentView(views)
            .setCustomBigContentView(views)
            .setContentIntent(contentIntent)
            .addAction(0, "Stop", stopIntent)
            .setOngoing(true)
            .setOnlyAlertOnce(true)
            .setSilent(true)
            .setShowWhen(false)
            // Visible in full on the lock screen.
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setCategory(NotificationCompat.CATEGORY_NAVIGATION)
            .setForegroundServiceBehavior(NotificationCompat.FOREGROUND_SERVICE_IMMEDIATE)
            .build()
    }

    private fun formatDistance(meters: Double): String =
        if (meters >= 1000) String.format("%.1f km", meters / 1000.0) else "${meters.toInt()} m"

    // ---- Route bar rendering ---------------------------------------------------

    /**
     * Draws the traffic bar: colored segments over the full route, the already
     * traveled part dimmed to gray, and an arrow puck at the car position.
     */
    private fun renderRouteBar(positionFraction: Double): Bitmap {
        val width = BAR_BITMAP_WIDTH
        val height = BAR_BITMAP_HEIGHT
        val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        val paint = Paint(Paint.ANTI_ALIAS_FLAG)

        val barTop = height * 0.30f
        val barBottom = height * 0.70f
        val radius = (barBottom - barTop) / 2f

        // Clip everything bar-related to a rounded pill.
        val barPath = Path().apply {
            addRoundRect(RectF(0f, barTop, width.toFloat(), barBottom), radius, radius, Path.Direction.CW)
        }
        canvas.save()
        canvas.clipPath(barPath)

        // Traffic segments across the full route length.
        var x = 0f
        for (segment in trafficSegments) {
            val segmentWidth = (segment.fraction * width).toFloat()
            paint.color = segment.color
            canvas.drawRect(x, barTop, x + segmentWidth, barBottom, paint)
            x += segmentWidth
        }
        // Fill any rounding remainder with the last color.
        if (x < width) {
            canvas.drawRect(x, barTop, width.toFloat(), barBottom, paint)
        }

        // Dim the traveled part.
        val carX = (positionFraction * width).toFloat()
        paint.color = TRAVELED_OVERLAY
        canvas.drawRect(0f, barTop, carX, barBottom, paint)
        canvas.restore()

        // Car puck: dark circle with a white arrow pointing along the route.
        val puckRadius = height * 0.42f
        val cx = min(max(carX, puckRadius), width - puckRadius)
        val cy = height / 2f
        paint.color = PUCK_BACKGROUND
        canvas.drawCircle(cx, cy, puckRadius, paint)
        paint.color = Color.WHITE
        paint.style = Paint.Style.STROKE
        paint.strokeWidth = height * 0.05f
        canvas.drawCircle(cx, cy, puckRadius - paint.strokeWidth / 2f, paint)

        paint.style = Paint.Style.FILL
        val arrowSize = puckRadius * 0.62f
        val arrow = Path().apply {
            // Triangle pointing right (direction of travel).
            moveTo(cx + arrowSize, cy)
            lineTo(cx - arrowSize * 0.65f, cy - arrowSize * 0.75f)
            lineTo(cx - arrowSize * 0.30f, cy)
            lineTo(cx - arrowSize * 0.65f, cy + arrowSize * 0.75f)
            close()
        }
        canvas.drawPath(arrow, paint)

        return bitmap
    }

    companion object {
        const val CHANNEL_ID = "nav_live_updates"
        const val NOTIFICATION_ID = 4821
        const val ACTION_STOP = "momra.balady.android.action.NAV_LIVE_STOP"
        private const val UPDATE_INTERVAL_MS = 1000L

        private const val BAR_BITMAP_WIDTH = 960
        private const val BAR_BITMAP_HEIGHT = 72

        private const val TRAFFIC_GREEN = 0xFF4CAF50.toInt()
        private const val TRAFFIC_YELLOW = 0xFFFFC107.toInt()
        private const val TRAFFIC_RED = 0xFFF44336.toInt()
        private const val TRAVELED_OVERLAY = 0x99616161.toInt()
        private const val PUCK_BACKGROUND = 0xFF1565C0.toInt()

        fun start(context: Context) {
            context.startForegroundService(Intent(context, NavLiveNotificationService::class.java))
        }

        fun stop(context: Context) {
            context.startService(
                Intent(context, NavLiveNotificationService::class.java).setAction(ACTION_STOP),
            )
        }
    }
}