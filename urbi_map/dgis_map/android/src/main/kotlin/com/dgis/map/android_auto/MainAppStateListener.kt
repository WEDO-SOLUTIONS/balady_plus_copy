package com.dgis.map.android_auto

private typealias AppStateListener = (MainAppScreenState) -> Unit

object MainAppScreenStateNotifier {
    private var stateInternal: MainAppScreenState = MainAppScreenState.DESTROYED
    private val listeners = mutableListOf<AppStateListener>()

    val state: MainAppScreenState
        get() = stateInternal

    fun setState(state: MainAppScreenState) {
        stateInternal = state
        notifyListeners()
    }

    fun addListener(listener: AppStateListener) {
        listeners.add(listener)
    }

    fun removeListener(listener: AppStateListener) {
        listeners.remove(listener)
    }

    private fun notifyListeners() {
        listeners.forEach { it(stateInternal) }
    }
}

enum class MainAppScreenState {
    CREATED, STARTED, RESUMED, PAUSED, STOPPED, DESTROYED
}
