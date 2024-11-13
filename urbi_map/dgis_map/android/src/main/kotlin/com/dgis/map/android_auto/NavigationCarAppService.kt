package com.dgis.map.android_auto

import androidx.car.app.CarAppService
import androidx.car.app.Session
import androidx.car.app.SessionInfo
import androidx.car.app.validation.HostValidator
import com.dgis.map.DgisMapInitializer
import com.dgis.map.DgisMapInitializer.VendorConfig
import com.dgis.map.map_api.Messages


/** Entry point for the car app */
class NavigationCarAppService : CarAppService() {
    override fun onCreateSession(sessionInfo: SessionInfo): Session {

        DgisMapInitializer.init(applicationContext, Messages.VendorConfigMessage.MOMRAH_PROD)
        return NavigationCarAppSession(sessionInfo, applicationContext)
    }

    override fun createHostValidator(): HostValidator {
        return HostValidator.ALLOW_ALL_HOSTS_VALIDATOR
    }
}
