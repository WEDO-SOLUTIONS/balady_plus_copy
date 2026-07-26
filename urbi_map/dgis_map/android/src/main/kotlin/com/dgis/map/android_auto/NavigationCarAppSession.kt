package com.dgis.map.android_auto

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.content.res.Configuration
import android.graphics.Rect
import android.net.Uri
import android.util.Log
import android.view.Surface
import android.view.View
import androidx.car.app.AppManager
import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.ScreenManager
import androidx.car.app.SessionInfo
import androidx.lifecycle.DefaultLifecycleObserver
import androidx.lifecycle.LifecycleOwner
import com.dgis.map.android_auto.custom_renderer.CustomRenderer
import com.dgis.map.android_auto.settings.VoiceInstructionsScreen
import io.flutter.FlutterInjector
import ru.dgis.sdk.androidauto.AndroidAutoMapSession
import ru.dgis.sdk.map.Map
import ru.dgis.sdk.map.MapOptions
import ru.dgis.sdk.map.MapTheme
import ru.dgis.sdk.map.Padding

/** Session class for the navigation car app  */
internal class NavigationCarAppSession(sessionInfo: SessionInfo, val context: Context) :
    AndroidAutoMapSession(MapOptions()) {

    private var stableAreaPaddingProvider = StableAreaPaddingProvider(carContext)
    private var customRenderer = CustomRenderer(stableAreaPaddingProvider)
    private val sharedPrefs = SharedPrefs(context)
    private val flutterLoader = FlutterInjector.instance().flutterLoader().apply {
        startInitialization(context)
    }
    private val carMapController = CarMapController(
        sharedPrefs, flutterLoader, stableAreaPaddingProvider
    )
    private var navigationScreen: NavigationScreen? = null

    init {
        lifecycle.addObserver(object : DefaultLifecycleObserver {
            override fun onCreate(owner: LifecycleOwner) {
                sharedPrefs.setSharedPrefsChangeListener(::handlePrefsChanged)
                MainAppScreenStateNotifier.addListener(::mainAppStateListener)
            }

            override fun onDestroy(owner: LifecycleOwner) {
                sharedPrefs.resetSharedPrefsChangeListener()
                MainAppScreenStateNotifier.removeListener(::mainAppStateListener)
                carMapController.close()
                customRenderer.close()
            }
        })
    }

    override fun onCreateScreen(intent: Intent): Screen {
        setupLocale()
        navigationScreen = NavigationScreen(carContext, carMapController, customRenderer)

        if (carContext.checkSelfPermission(android.Manifest.permission.ACCESS_FINE_LOCATION) != PackageManager.PERMISSION_GRANTED) {
            carContext.getCarService(ScreenManager::class.java).push(navigationScreen!!)
            return RequestPermissionScreen(
                carContext, carMapController::onLocationOPermissionGranted
            )
        }

        carMapController.onLocationOPermissionGranted()
        if (intent.action == CarContext.ACTION_NAVIGATE && intent.dataString != null) {
            val geoPoint = parseGeoPoint(intent.dataString!!)
            if (geoPoint != null) {
                carMapController.setRouteParams(geoPoint.first, geoPoint.second)
                return navigationScreen!!
            }

            val query = parseNavigationQuery(intent.dataString!!)
            if (query != null) {
                carContext.getCarService(ScreenManager::class.java).push(navigationScreen!!)
                return PlaceListScreen(carContext, carMapController, query)
            }
        }
        return navigationScreen!!
    }

    override fun onNewIntent(intent: Intent) {
        if (intent.action == CarContext.ACTION_NAVIGATE) {
            handleNavigationIntent(intent)
        }
    }

    private fun handleNavigationIntent(intent: Intent) {
        carMapController.stopNavigation()

        val data = intent.dataString ?: return
        val point = parseGeoPoint(data)
        if (point != null) {
            carMapController.setRouteParams(point.first, point.second)
            return
        }

        val query = parseNavigationQuery(data) ?: return
        val placeListScreen = PlaceListScreen(carContext, carMapController, query)
        val screenManager = carContext.getCarService(ScreenManager::class.java)
        if (screenManager.top is PlaceListScreen) {
            screenManager.pop()
        }
        screenManager.push(placeListScreen)
    }

    private fun parseGeoPoint(data: String): Pair<Double, Double>? {
        val geo = data.substringAfter("geo:").substringBefore("?")
        val parts = geo.split(",")
        if (parts.size != 2) return null
        return try {
            val latitude = parts[0].toDouble()
            val longitude = parts[1].toDouble()
            if (latitude != 0.0 && longitude != 0.0) Pair(latitude, longitude) else null
        } catch (e: NumberFormatException) {
            // Values are not Doubles
            null
        }
    }

    private fun parseNavigationQuery(data: String): String? {
        val query = data.substringAfter("q=", "")
        if (query.isEmpty()) return null
        return try {
            val result = Uri.decode(query)
            result?.replace("+", " ")?.ifEmpty { null }
        } catch (e: Exception) {
            null
        }
    }

    override fun onMapReady(map: Map) {
        setMapTheme()
        carMapController.onMapReady(map)
        navigationScreen?.onMapReady()
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

    override fun onSurfaceStableAreaChanged(stableArea: Rect) {
        stableAreaPaddingProvider.onStableAreaChanged(stableArea)
    }

    private fun setMapTheme() {
        val theme = if (carContext.isDarkMode) MapTheme.defaultDarkTheme else MapTheme.defaultTheme
        setTheme(theme)
    }

    private fun setupLocale() {
        val locale = carMapController.getLocale()
        // Operate on a copy of the configuration: mutating the live Resources configuration in place
        // and passing the same instance back to updateConfiguration() can defeat its change detection,
        // so the new locale / layout direction may not be applied reliably.
        val configuration = Configuration(carContext.resources.configuration)
        configuration.setLocale(locale)
        configuration.setLayoutDirection(locale)
        carContext.resources.updateConfiguration(configuration, carContext.resources.displayMetrics)
        customRenderer.isRtl = configuration.layoutDirection == View.LAYOUT_DIRECTION_RTL
        customRenderer.label = carContext.getString(com.dgis.map.R.string.balady_maps)
        carContext.getCarService(AppManager::class.java).invalidate()
    }

    private fun handlePrefsChanged(key: String) {
        when (key) {
            SharedPrefs.languageKey -> {
                setupLocale()
                carContext.getCarService(ScreenManager::class.java).screenStack.forEach {
                    if (it is LocaleChangeListener) {
                        it.onLocaleChanged()
                    }
                }
            }
            SharedPrefs.flutterVoiceInstructionIndexKey -> {
                carMapController.syncVoiceInstructionsFromFlutter()
                carContext.getCarService(ScreenManager::class.java).screenStack
                    .filterIsInstance<VoiceInstructionsScreen>()
                    .forEach { it.refresh() }
            }
        }
    }

    private fun mainAppStateListener(state: MainAppScreenState) {
        if (state == MainAppScreenState.CREATED) {
            setupLocale()
        }
    }

    private companion object {
        const val tag = "NavigationCarAppSession"
    }
}
