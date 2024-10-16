package com.dgis.map.android_auto

import android.content.Context
import android.content.SharedPreferences

class SharedPrefs(context: Context) : AutoCloseable {

    private var sharedPrefsChangeListener: ((key: String) -> Unit)? = null

    private val sharedPreferences =
        context.getSharedPreferences(sharedPreferencesName, Context.MODE_PRIVATE)

    private val prefsChangeListener =
        SharedPreferences.OnSharedPreferenceChangeListener { _: SharedPreferences, key: String? ->
            if (key != null) {
                sharedPrefsChangeListener?.invoke(key.substringAfter(keyPrefix))
            }
        }

    fun getString(key: String): String? {
        return sharedPreferences.getString("$keyPrefix$key", null)
    }

    fun putString(key: String, value: String?) {
        sharedPreferences.edit().putString("$keyPrefix$key", value).apply()
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
    }

    override fun close() {
        sharedPreferences.unregisterOnSharedPreferenceChangeListener(prefsChangeListener)
    }
}