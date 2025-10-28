package com.dgis.map.android_auto

import android.graphics.Rect
import androidx.car.app.CarContext
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.asStateFlow
import ru.dgis.sdk.map.Padding

class StableAreaPaddingProvider(private val carContext: CarContext) {
    private val paddingStateFlow = MutableStateFlow(Padding())

    val paddingFlow = paddingStateFlow.asStateFlow()

    fun onStableAreaChanged(stableArea: Rect) {
        val displayMetrics = carContext.resources.displayMetrics
        val left = stableArea.left
        val top = stableArea.top
        val right = displayMetrics.widthPixels - stableArea.right
        val bottom = displayMetrics.heightPixels - stableArea.bottom

        paddingStateFlow.value = Padding(left, top, right, bottom)
    }
}
