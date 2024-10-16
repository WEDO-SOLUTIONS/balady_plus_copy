package com.dgis.map.android_auto

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.util.Log
import android.view.Surface
import androidx.car.app.AppManager
import androidx.car.app.Screen
import androidx.car.app.ScreenManager
import androidx.car.app.SessionInfo
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.dgis.map.android_auto.custom_renderer.CustomRenderer
import ru.dgis.sdk.androidauto.AndroidAutoMapSession
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.map.MapOptions
import ru.dgis.sdk.map.MapTheme
import java.util.Locale

/** Session class for the navigation car app  */
internal class NavigationCarAppSession(sessionInfo: SessionInfo, val context: Context) :
    AndroidAutoMapSession(MapOptions()) {

    private var customRenderer = CustomRenderer()
    private val sharedPrefs = SharedPrefs(context)
    private val carMapController = CarMapController(sharedPrefs)
    private var navigationScreen: NavigationScreen? = null

    init {
        lifecycle.addObserver(object : DefaultLifecycleObserver {
            override fun onCreate(owner: LifecycleOwner) {
                sharedPrefs.setSharedPrefsChangeListener(::handlePrefsChanged)
            }

            override fun onDestroy(owner: LifecycleOwner) {
                sharedPrefs.resetSharedPrefsChangeListener()
            }
        })
    }

    override fun onCreateScreen(intent: Intent): Screen {
        setupLocale()
        navigationScreen = NavigationScreen(carContext, carMapController, customRenderer)

        return if (carContext.checkSelfPermission(android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
            carMapController.onLocationOPermissionGranted()
            navigationScreen!!
        } else {
            carContext.getCarService(ScreenManager::class.java).push(navigationScreen!!)
            RequestPermissionScreen(
                carContext, carMapController::onLocationOPermissionGranted
            )
        }
    }

    override fun onMapReady(map: Map) {
        setMapTheme()
        carMapController.onMapReady(map, getLocale())
    }

    override fun onMapReadyException(exception: Exception) {
        Log.e(tag, "onMapReadyException: $exception")
    }

    override fun onCarConfigurationChanged(newConfiguration: Configuration) {
        setMapTheme()
        setupLocale()
    }

    override fun onSurfaceAvailable(surface: Surface, width: Int, height: Int) {
        customRenderer.setSurface(surface)
    }

    override fun onSurfaceClicked(x: Float, y: Float) {}

    override fun onSurfaceDestroyed(surface: Surface) {
        customRenderer.resetSurface()
    }

    private fun setMapTheme() {
        val theme = if (carContext.isDarkMode) MapTheme.defaultDarkTheme else MapTheme.defaultTheme
        setTheme(theme)
    }

    private fun setupLocale() {
        val locale = getLocale()
        val configuration = carContext.resources.configuration
        configuration.setLocale(locale)
        configuration.setLayoutDirection(locale)
        carContext.resources.updateConfiguration(configuration, carContext.resources.displayMetrics)
        carContext.getCarService(AppManager::class.java).invalidate()
    }

    private fun handlePrefsChanged(key: String) {
        when (key) {
            SharedPrefs.languageKey -> setupLocale()
        }
    }

    private fun getLocale(): Locale {
        val locale = when (sharedPrefs.getString(SharedPrefs.languageKey)) {
            "english" -> Locale("en")
            "arabic" -> Locale("ar")
            else -> if (context.resources.configuration.locales.get(0).language.lowercase()
                    .contains("en")
            ) Locale("en") else Locale("ar")
        }
        return locale
    }

    private companion object {
        const val tag = "NavigationCarAppSession"
    }
}