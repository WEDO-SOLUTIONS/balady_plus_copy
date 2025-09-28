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
                android.util.Log.d("MediaSessionHandler", "Setting playback state: $playing")
                setPlaybackState(playing)
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
        
        val metadataBuilder = MediaMetadataCompat.Builder()
            .putString(MediaMetadataCompat.METADATA_KEY_TITLE, title)
            .putString(MediaMetadataCompat.METADATA_KEY_ARTIST, artist)
            .putString(MediaMetadataCompat.METADATA_KEY_GENRE, "Live Stream")
            .putString(MediaMetadataCompat.METADATA_KEY_ALBUM, "Live Radio")
            .putLong(MediaMetadataCompat.METADATA_KEY_DURATION, -1L) // -1 for live streams
        
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
    
    private fun setPlaybackState(playing: Boolean) {
        isPlaying = playing
        
        val state = if (playing) PlaybackStateCompat.STATE_PLAYING else PlaybackStateCompat.STATE_PAUSED
        
        val playbackState = PlaybackStateCompat.Builder()
            .setActions(
                PlaybackStateCompat.ACTION_PLAY or
                PlaybackStateCompat.ACTION_PAUSE or
                PlaybackStateCompat.ACTION_STOP or
                PlaybackStateCompat.ACTION_SEEK_TO
            )
            .setState(state, if (playing) 500L else 0L, 1.0f) // Show progress when playing
            .build()
        
        mediaSession?.setPlaybackState(playbackState)
        
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
        android.util.Log.d("MediaSessionHandler", "Creating notification for: $title by $artist")
        
        // Create intent to open app when notification is tapped
        val intent = context.packageManager.getLaunchIntentForPackage(context.packageName)
        val pendingIntent = PendingIntent.getActivity(
            context, 0, intent,
            PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
        )
        
        val notification = NotificationCompat.Builder(context, NOTIFICATION_CHANNEL_ID)
            .setContentTitle(title)
            .setContentText("$artist • Live Stream")
            .setSubText(if (isPlaying) "Live • Playing" else "Live • Paused")
            .setSmallIcon(if (isPlaying) android.R.drawable.ic_media_play else android.R.drawable.ic_media_pause)
            .setContentIntent(pendingIntent)
            .setVisibility(NotificationCompat.VISIBILITY_PUBLIC)
            .setPriority(NotificationCompat.PRIORITY_HIGH) // Higher priority for lock screen
            .setCategory(NotificationCompat.CATEGORY_TRANSPORT) // Media category
            .setOngoing(true) // Keep notification visible even when paused
            .setShowWhen(false)
            .setOnlyAlertOnce(true) // Don't alert repeatedly
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
            .build()
        
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
