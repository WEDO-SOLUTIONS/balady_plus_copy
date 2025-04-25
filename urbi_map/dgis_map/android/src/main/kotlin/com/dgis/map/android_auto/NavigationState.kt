package com.dgis.map.android_auto

import ru.dgis.sdk.navigation.State

enum class NavigationState {
    NAVIGATION,
    REROUTING,
    FREE_ROAM,
    FINISHED,
    DISABLED
}

fun State.toNavigationState(hasOptions: Boolean): NavigationState {
    return when (this) {
        State.DISABLED -> NavigationState.DISABLED
        State.NAVIGATION -> if (hasOptions) NavigationState.NAVIGATION else NavigationState.FREE_ROAM
        State.ROUTE_SEARCH -> if (hasOptions) NavigationState.REROUTING else NavigationState.FREE_ROAM
        State.FINISHED -> NavigationState.FINISHED
    }
}
