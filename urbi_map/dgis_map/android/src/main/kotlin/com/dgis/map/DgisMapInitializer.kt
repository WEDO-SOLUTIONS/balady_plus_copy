package com.dgis.map

import android.annotation.SuppressLint
import android.content.Context
import com.dgis.map.map_api.*
import ru.dgis.sdk.DGis
import ru.dgis.sdk.Duration
import ru.dgis.sdk.map.CalloutVisualizationMode
import ru.dgis.sdk.navigation.NavigationManager
import ru.dgis.sdk.platform.HttpOptions
import ru.dgis.sdk.platform.LogLevel
import ru.dgis.sdk.Context as SdkContext
import ru.dgis.sdk.platform.LogOptions
import ru.dgis.sdk.platform.VendorConfigFromAsset
import ru.dgis.sdk.platform.VendorConfigFromString
import ru.dgis.sdk.positioning.LocationSource
import ru.dgis.sdk.positioning.registerPlatformLocationSource
import ru.dgis.sdk.positioning.MagneticHeadingProvider
import ru.dgis.sdk.positioning.registerPlatformMagneticSource
import ru.dgis.sdk.routing.RouteDistance

object DgisMapInitializer {

    private var sdkContext: SdkContext? = null
    private var navigationManager: NavigationManager? = null

    @SuppressLint("StaticFieldLeak")
    private var locationSource: FusedLocationSource? = null

    fun init(
        appContext: Context,
        vendorConfig: VendorConfigMessage?,
        vendorConfigContentMessage: VendorConfigContentMessage? = null,
        logOptions: LogOptions? = null,
    ) {
        if (sdkContext != null) {
            // SDK has already been initialized
            return
        }

        ///TODO(ve): remove after refactorig android auto
        val vendorConfigFile = when (vendorConfig) {
            VendorConfigMessage.URBI_PRE_PROD -> "flutter_assets/assets/maps/configs/urbi-pre-prod-vendor-config.jsonx"
            VendorConfigMessage.MOMRAH_PROD -> "flutter_assets/assets/maps/configs/momrah-prod-vendor-config.jsonx"
            VendorConfigMessage.MOMRAH_STG -> "flutter_assets/assets/maps/configs/momrah-staging-vendor-config.jsonx"
            null -> "flutter_assets/assets/maps/configs/momrah-prod-vendor-config.jsonx"
        }

        val config = when{
            (vendorConfigContentMessage!=null) -> ru.dgis.sdk.platform.VendorConfig(
                fromString =VendorConfigFromString(vendorConfigContentMessage.content),
            )
            else ->ru.dgis.sdk.platform.VendorConfig(
                fromAsset = VendorConfigFromAsset(
                    vendorConfigFile
                ))
        }

        sdkContext = DGis.initialize(
            appContext,
            vendorConfig = config,
            logOptions = logOptions ?: LogOptions(
                systemLevel = LogLevel.ERROR, customLevel = LogLevel.ERROR
            ),
            httpOptions = HttpOptions(useCache = true),
        )

        if (locationSource == null) {
            locationSource = FusedLocationSource(appContext)
            registerPlatformLocationSource(sdkContext!!, locationSource)
            // BALADY-3956: null here disabled the SDK's default compass, leaving
            // BearingSource.AUTO with the GNSS course only (unreliable at low speed).
            registerPlatformMagneticSource(sdkContext!!, MagneticHeadingProvider(appContext))
        }
    }

    fun getSdkContext(): SdkContext {
        if (sdkContext == null) {
            throw Exception("SDK has not been initialized")
        }
        return sdkContext!!
    }

    fun getNavigationManager(): NavigationManager {
        if (navigationManager == null) {
            navigationManager = NavigationManager(getSdkContext()).apply {
                alternativeRoutesProviderSettings.alternativeRoutesEnabled = false
                routeSourceSettings.calloutVisualizationMode =
                    CalloutVisualizationMode.MULTIPLE_ROUTES
                alternativeRoutesProviderSettings.routeSearchDelay = Duration.ofSeconds(20)
                alternativeRoutesProviderSettings.betterRouteTimeCostThreshold =
                    Duration.ofSeconds(2 * 60)
                alternativeRoutesProviderSettings.betterRouteLengthThreshold =
                    RouteDistance(500 * 1000)
            }
        }
        return navigationManager!!
    }

    fun getLocationSource(): FusedLocationSource {
        return locationSource!!
    }

    enum class VendorConfig {
        URBI_PRE_PROD, MOMRAH_PROD, MOMRAH_STG,
    }
}
