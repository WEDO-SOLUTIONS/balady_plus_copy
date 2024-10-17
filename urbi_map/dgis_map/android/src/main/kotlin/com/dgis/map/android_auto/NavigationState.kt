package com.dgis.map.android_auto

import ru.dgis.sdk.navigation.State

enum class NavigationState {
    NAVIGATION,
    REROUTING,
    FINISHED,
    DISABLED
}

fun State.toNavigationState(): NavigationState {
    return when(this){
        State.DISABLED -> NavigationState.DISABLED
        State.NAVIGATION -> NavigationState.NAVIGATION
        State.ROUTE_SEARCH -> NavigationState.REROUTING
        State.FINISHED -> NavigationState.FINISHED
    }
}
