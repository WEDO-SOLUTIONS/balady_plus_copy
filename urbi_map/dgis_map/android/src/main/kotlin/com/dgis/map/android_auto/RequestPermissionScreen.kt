package com.dgis.map.android_auto

import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.provider.Settings
import androidx.car.app.CarContext
import androidx.car.app.Screen
import androidx.car.app.model.Action
import androidx.car.app.model.CarColor
import androidx.car.app.model.CarIcon
import androidx.car.app.model.MessageTemplate
import androidx.car.app.model.OnClickListener
import androidx.car.app.model.ParkedOnlyOnClickListener
import androidx.car.app.model.Template
import androidx.core.content.ContextCompat.startActivity
import androidx.core.graphics.drawable.IconCompat
import com.dgis.map.R


/** Screen for asking the user to grant location permission.  */
class RequestPermissionScreen(
    carContext: CarContext, val onLocationPermissionGranted: () -> Unit
) : Screen(carContext) {

    override fun onGetTemplate(): Template {
        val listener: OnClickListener = ParkedOnlyOnClickListener.create {
            if (carContext.checkSelfPermission(android.Manifest.permission.ACCESS_FINE_LOCATION) == PackageManager.PERMISSION_GRANTED) {
                onLocationPermissionGranted()
                finish()
            } else {
                val intent = Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS).apply {
                    data = Uri.fromParts("package", carContext.packageName, null)
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                }
                startActivity(carContext, intent, null)
            }
        }
        val action =
            Action.Builder().setTitle(getString(R.string.grant_access_action)).setBackgroundColor(
                CarColor.PRIMARY
            ).setOnClickListener(listener).build()
        val icon = CarIcon.Builder(
            IconCompat.createWithResource(
                carContext, R.drawable.logo
            )
        ).build()
        return MessageTemplate.Builder(getString(R.string.location_permission_request_message))
            .setIcon(icon).addAction(action).build()
    }
}