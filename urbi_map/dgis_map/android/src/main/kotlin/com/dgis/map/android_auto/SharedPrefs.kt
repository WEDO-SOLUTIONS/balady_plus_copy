package com.dgis.map.android_auto

import android.content.Context
import android.content.SharedPreferences
import org.json.JSONObject
import androidx.core.content.edit
import com.dgis.map.android_auto.settings.NotificationVolume
import com.dgis.map.map_api.SoundToggleType
import java.util.Locale

class SharedPrefs(val context: Context) : AutoCloseable {

    private var sharedPrefsChangeListener: ((key: String) -> Unit)? = null

    private val sharedPreferences =
        context.getSharedPreferences(sharedPreferencesName, Context.MODE_PRIVATE)

    private val prefsChangeListener =
        SharedPreferences.OnSharedPreferenceChangeListener { _: SharedPreferences, key: String? ->
            if (key != null) {
                sharedPrefsChangeListener?.invoke(key.substringAfter(keyPrefix))
            }
        }

    fun getLanguage(): Language {
        return when (getString(languageKey)) {
            "english" -> Language.ENGLISH
            "arabic" -> Language.ARABIC
            else -> if (context.resources.configuration.locales.get(0).language.lowercase()
                    .contains("en")
            ) Language.ENGLISH else Language.ARABIC
        }
    }

    fun getString(key: String): String? {
        return sharedPreferences.getString("$keyPrefix$key", null)
    }

    fun putString(key: String, value: String?) {
        sharedPreferences.edit { putString("$keyPrefix$key", value) }
    }

    // Amount of instructions that user will hear during the driving
    // 0: All events, 1: Important, 2: Off
    var voiceInstructionsValue: SoundToggleType
        get() {
            val name = sharedPreferences.getString(
                "$keyPrefix$voiceInstructionsKey",
                SoundToggleType.ALL.name
            )
            return try {
                SoundToggleType.valueOf(name!!)
            } catch (e: IllegalArgumentException) {
                SoundToggleType.ALL
            }
        }
        set(value) {
            sharedPreferences.edit { putString("$keyPrefix$voiceInstructionsKey", value.name) }
        }

    // If traffic value shown by default
    var trafficValue: Boolean
        get() {
            return sharedPreferences.getBoolean("$keyPrefix$trafficKey", false)
        }
        set(value) {
            sharedPreferences.edit { putBoolean("$keyPrefix$trafficKey", value) }
        }

    // Is parking lots shown by default
    var parkingValue: Boolean
        get() {
            return sharedPreferences.getBoolean("$keyPrefix$parkingKey", false)
        }
        set(value) {
            sharedPreferences.edit {
                putBoolean("$keyPrefix$parkingKey", value)
            }
        }

    // Avoid Toll Road setting to use across Android Auto. Use it as the source of truth
    // to initialize and set up all others settings
    var avoidTollRoads: Boolean
        get() {
            return sharedPreferences.getBoolean("$keyPrefix$avoidTollRoadKey", false)
        }
        set(value) {
            sharedPreferences.edit {
                putBoolean("$keyPrefix$avoidTollRoadKey", value)
            }
        }

    // Avoid Unpaved Road setting to use across Android Auto. Use it as the source of truth
    // to initialize and set up all others settings
    var avoidUnpavedRoads: Boolean
        get() {
            return sharedPreferences.getBoolean("$keyPrefix$avoidUnpavedRoadsKey", false)
        }
        set(value) {
            sharedPreferences.edit {
                putBoolean("$keyPrefix$avoidUnpavedRoadsKey", value)
            }
        }

    var suggestBetterRoad: Boolean
        get() {
            return sharedPreferences.getBoolean("$keyPrefix$suggestBetterRoadKey", true)
        }
        set(value) {
            sharedPreferences.edit {
                putBoolean("$keyPrefix$suggestBetterRoadKey", value)
            }
        }

    // Volume of the navigator voice during the navigation
    var volumeValue: NotificationVolume
        get() {
            val str =
                sharedPreferences.getString("$keyPrefix$volumeKey", NotificationVolume.Quiet.name)
            return try {
                NotificationVolume.valueOf(str!!)
            } catch (e: IllegalArgumentException) {
                NotificationVolume.Quiet
            }
        }
        set(value) {
            sharedPreferences.edit { putString("$keyPrefix$volumeKey", value.name) }
        }

    fun setSharedPrefsChangeListener(sharedPrefsChangeListener: (key: String) -> Unit) {
        this.sharedPrefsChangeListener = sharedPrefsChangeListener
        sharedPreferences.registerOnSharedPreferenceChangeListener(prefsChangeListener)
    }

    fun resetSharedPrefsChangeListener() {
        this.sharedPrefsChangeListener = null
        sharedPreferences.unregisterOnSharedPreferenceChangeListener(prefsChangeListener)
    }

    companion object {
        private const val sharedPreferencesName = "FlutterSharedPreferences"
        private const val keyPrefix = "flutter."
        const val languageKey = "settings.language"
        const val navigatorVoiceKey = "navigator.voice"
        private const val voiceInstructionsKey = "auto.voiceInstructions"
        private const val trafficKey = "auto.traffic"
        private const val parkingKey = "auto.parking"

        private const val avoidTollRoadKey = "auto.navigation.avoidTollRoads"
        private const val avoidUnpavedRoadsKey = "auto.navigation.avoidUnpavedRoads"
        private const val suggestBetterRoadKey = "auto.navigation.suggestBetterRoad"

        private const val volumeKey = "auto.volume"
    }

    override fun close() {
        sharedPreferences.unregisterOnSharedPreferenceChangeListener(prefsChangeListener)
    }
}

enum class Language {
    ENGLISH, ARABIC
}