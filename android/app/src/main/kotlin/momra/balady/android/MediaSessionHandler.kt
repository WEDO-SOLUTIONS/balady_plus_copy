package momra.balady.android

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.media.AudioManager
import android.os.Build
import android.support.v4.media.MediaMetadataCompat
import android.support.v4.media.session.MediaSessionCompat
import android.support.v4.media.session.PlaybackStateCompat
import androidx.core.app.NotificationCompat
import androidx.media.session.MediaButtonReceiver
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.net.URL

class MediaSessionHandler(
    private val context: Context,
    private val channel: MethodChannel
) : MethodCallHandler {
    
    companion object {
        private const val NOTIFICATION_CHANNEL_ID = "momra.balady.android.channel.audio"
        private const val NOTIFICATION_CHANNEL_NAME = "Audio playback"
        private const val NOTIFICATION_ID = 1001
    }
    
    private var mediaSession: MediaSessionCompat? = null
    private var notificationManager: NotificationManager? = null
    private var currentMetadata: Map<String, Any>? = null
    private var isPlaying = false
    
    override fun onMethodCall(call: MethodCall, result: Result) {
        android.util.Log.d("MediaSessionHandler", "Received method call: ${call.method}")
        when (call.method) {
            "initMediaSession" -> {
                android.util.Log.d("MediaSessionHandler", "Initializing MediaSession")
                initMediaSession()
                result.success(null)
            }
            "updateMediaMetadata" -> {
                val metadata = call.arguments as? Map<String, Any>
                android.util.Log.d("MediaSessionHandler", "Updating metadata: $metadata")
                updateMediaMetadata(metadata)
                result.success(null)
            }
            "setPlaybackState" -> {
                val playing = call.argument<Boolean>("isPlaying") ?: false
                val position = call.argument<Long>("position") ?: 0L
                val duration = call.argument<Long>("duration") ?: -1L
                android.util.Log.d("MediaSessionHandler", "Setting playback state: playing=$playing, position=${position}ms (${position/1000}s), duration=${duration}ms (${duration/1000}s)")
                setPlaybackState(playing, position, duration)
                result.success(null)
            }
            "releaseMediaSession" -> {
                android.util.Log.d("MediaSessionHandler", "Releasing MediaSession")
                releaseMediaSession()
                result.success(null)
            }
            else -> {
                android.util.Log.w("MediaSessionHandler", "Method not implemented: ${call.method}")
                result.notImplemented()
            }
        }
    }
    
    private fun initMediaSession() {
        try {
            // Create notification channel
            createNotificationChannel()
            
            // Initialize MediaSession
            mediaSession = MediaSessionCompat(context, "BaladyAudioSession").apply {
                setFlags(
                    MediaSessionCompat.FLAG_HANDLES_MEDIA_BUTTONS or
                    MediaSessionCompat.FLAG_HANDLES_TRANSPORT_CONTROLS
                )
                
                // Set initial playback state to make it appear on lock screen
                setPlaybackState(
                    PlaybackStateCompat.Builder()
                        .setActions(
                            PlaybackStateCompat.ACTION_PLAY or
                            PlaybackStateCompat.ACTION_PAUSE or
                            PlaybackStateCompat.ACTION_STOP
                        )
                        .setState(PlaybackStateCompat.STATE_STOPPED, 0L, 1.0f)
                        .build()
                )
                
                setCallback(object : MediaSessionCompat.Callback() {
                    override fun onPlay() {
                        // Handle play from lock screen and notify Flutter
                        setPlaybackState(true)
                        try { channel.invokeMethod("onPlay", null) } catch (_: Exception) {}
                    }

                    override fun onPause() {
                        // Handle pause from lock screen and notify Flutter
                        setPlaybackState(false)
                        try { channel.invokeMethod("onPause", null) } catch (_: Exception) {}
                    }

                    override fun onStop() {
                        // Handle stop from lock screen and notify Flutter
                        setPlaybackState(false)
                        hideNotification()
                        try { channel.invokeMethod("onStop", null) } catch (_: Exception) {}
                    }
                })
                
                isActive = true
            }
            
            notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            
        } catch (e: Exception) {
            e.printStackTrace()
        }
    }
    
    private fun createNotificationChannel() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                NOTIFICATION_CHANNEL_ID,
                NOTIFICATION_CHANNEL_NAME,
                NotificationManager.IMPORTANCE_DEFAULT // Changed from LOW to DEFAULT for lock screen
            ).apply {
                description = "Audio playback controls"
                setShowBadge(false)
                lockscreenVisibility = android.app.Notification.VISIBILITY_PUBLIC // Ensure lock screen visibility
            }
            
            val notificationManager = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
            notificationManager.createNotificationChannel(channel)
        }
    }
    
    private fun updateMediaMetadata(metadata: Map<String, Any>?) {
        if (metadata == null) return
        
        currentMetadata = metadata
        val title = metadata["title"] as? String ?: "Unknown Title"
        val artist = metadata["artist"] as? String ?: "Unknown Artist"
        val artworkUrl = metadata["artworkUrl"] as? String
        val duration = metadata["duration"] as? Long ?: -1L // Support duration from Flutter
        
        val metadataBuilder = MediaMetadataCompat.Builder()
            .putString(MediaMetadataCompat.METADATA_KEY_TITLE, title)
            .putString(MediaMetadataCompat.METADATA_KEY_ARTIST, artist)
            .putString(MediaMetadataCompat.METADATA_KEY_GENRE, "Live Stream")
            .putString(MediaMetadataCompat.METADATA_KEY_ALBUM, "Live Radio")
            .putLong(MediaMetadataCompat.METADATA_KEY_DURATION, duration) // Use provided duration or -1 for live streams
        
        // Load artwork if provided
        artworkUrl?.let { url ->
            try {
                // In a real implementation, you'd want to load this asynchronously
                // For now, we'll skip artwork loading to avoid blocking
                // val bitmap = BitmapFactory.decodeStream(URL(url).openConnection().getInputStream())
                // metadataBuilder.putBitmap(MediaMetadataCompat.METADATA_KEY_ALBUM_ART, bitmap)
            } catch (e: Exception) {
                // Ignore artwork loading errors
            }
        }
        
        mediaSession?.setMetadata(metadataBuilder.build())
        
        // Ensure MediaSession is active after setting metadata
        mediaSession?.isActive = true
        
        // Always show notification when metadata is updated
        showNotification()
    }
    
    private fun setPlaybackState(playing: Boolean, position: Long = 0L, duration: Long = -1L) {
        isPlaying = playing
        
        val state = if (playing) PlaybackStateCompat.STATE_PLAYING else PlaybackStateCompat.STATE_PAUSED
        
        // For live streams with cached content, show progress
        val playbackSpeed = if (playing) 1.0f else 0.0f
        
        android.util.Log.d("MediaSessionHandler", "Building playback state with position=$position, duration=$duration, speed=$playbackSpeed")
        
        val playbackState = PlaybackStateCompat.Builder()
            .setActions(
                PlaybackStateCompat.ACTION_PLAY or
                PlaybackStateCompat.ACTION_PAUSE or
                PlaybackStateCompat.ACTION_STOP or
                PlaybackStateCompat.ACTION_SEEK_TO
            )
            .setState(state, position, playbackSpeed)
            .build()
        
        mediaSession?.setPlaybackState(playbackState)
        
        // Always update metadata with current duration for progress calculation
        currentMetadata?.let { metadata ->
            val title = metadata["title"] as? String ?: "Unknown Title"
            val artist = metadata["artist"] as? String ?: "Unknown Artist"
            
            // Use duration from parameter if available, otherwise use stored duration
            val metadataDuration = if (duration > 0) duration else (metadata["duration"] as? Long ?: -1L)
            
            android.util.Log.d("MediaSessionHandler", "Updating metadata with duration=$metadataDuration")
            
            val metadataBuilder = MediaMetadataCompat.Builder()
                .putString(MediaMetadataCompat.METADATA_KEY_TITLE, title)
                .putString(MediaMetadataCompat.METADATA_KEY_ARTIST, artist)
                .putString(MediaMetadataCompat.METADATA_KEY_GENRE, "Live Stream")
                .putString(MediaMetadataCompat.METADATA_KEY_ALBUM, "Live Radio")
                .putLong(MediaMetadataCompat.METADATA_KEY_DURATION, metadataDuration)
            
            mediaSession?.setMetadata(metadataBuilder.build())
        }
        
        // Always show notification when there's active media session
        showNotification()
    }
    
    private fun showNotification() {
        android.util.Log.d("MediaSessionHandler", "showNotification called")
        val metadata = currentMetadata ?: run {
            android.util.Log.w("MediaSessionHandler", "No metadata available for notification")
            return
        }
        val title = metadata["title"] as? String ?: "Unknown Title"
        val artist = metadata["artist"] as? String ?: "Unknown Artist"
        val duration = metadata["duration"] as? Long ?: -1L
        
        // Get current position from MediaSession
        val playbackState = mediaSession?.controller?.playbackState
        val position = playbackState?.position ?: 0L
        
        android.util.Log.d("MediaSessionHandler", "Creating notification: title=$title, artist=$artist, position=${position}ms, duration=${duration}ms")
        
        // Create intent to open app when notification is tapped
        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pendingIntent = PendingIntent.getActivity(
            context, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        val notificationBuilder = NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID)
            .setContentTitle(title)
            .setContentText(artist)
            .setSubText(if (isPlaying) "Playing" else "Paused")
            .setSmallIcon(android.R.drawable.ic_dialog_info)
            .setContentIntent(pendingIntent)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_TRANSPORT)
            .setOngoing(true)
            .setShowWhen(false)
            .setUsesChronometer(false) // Don't use chronometer for cached content with progress bar
            .setOnlyAlertOnce(true)
            .addAction(
                if (isPlaying) android.R.drawable.ic_media_pause else android.R.drawable.ic_media_play,
                if (isPlaying) "Pause" else "Play",
                MediaButtonReceiver.buildMediaButtonPendingIntent(
                    context,
                    if (isPlaying) PlaybackStateCompat.ACTION_PAUSE else PlaybackStateCompat.ACTION_PLAY
                )
            )
            .addAction(
                android.R.drawable.ic_menu_close_clear_cancel,
                "Stop",
                MediaButtonReceiver.buildMediaButtonPendingIntent(
                    context,
                    PlaybackStateCompat.ACTION_STOP
                )
            )
            .setStyle(
                androidx.media.app.NotificationCompat.MediaStyle()
                    .setMediaSession(mediaSession?.sessionToken)
                    .setShowActionsInCompactView(0, 1)
            )
        
        // Add progress bar if we have valid duration
        // Use metadata duration if position from playback state is not reliable
        val actualDuration = if (duration > 0) duration else -1L
        
        android.util.Log.d("MediaSessionHandler", "Progress check - position=$position, duration=$actualDuration, fromMetadata=${duration}ms")
        
        if (actualDuration > 0 && position >= 0) {
            val durationSeconds = (actualDuration / 1000).toInt()
            val positionSeconds = (position / 1000).toInt().coerceIn(0, durationSeconds)
            android.util.Log.d("MediaSessionHandler", "✅ Adding progress bar: $positionSeconds / $durationSeconds seconds")
            notificationBuilder.setProgress(durationSeconds, positionSeconds, false)
        } else {
            android.util.Log.w("MediaSessionHandler", "❌ No progress bar - duration: $actualDuration, position: $position")
            // Show indeterminate progress for live streams
            if (isPlaying) {
                notificationBuilder.setProgress(0, 0, true) // Indeterminate progress
            }
        }
        
        val notification = notificationBuilder.build()
        
        android.util.Log.d("MediaSessionHandler", "Showing notification with ID: $NOTIFICATION_ID")
        notificationManager?.notify(NOTIFICATION_ID, notification)
        android.util.Log.d("MediaSessionHandler", "Notification shown successfully")
    }
    
    private fun hideNotification() {
        notificationManager?.cancel(NOTIFICATION_ID)
    }
    
    private fun releaseMediaSession() {
        hideNotification()
        mediaSession?.release()
        mediaSession = null
    }
}
