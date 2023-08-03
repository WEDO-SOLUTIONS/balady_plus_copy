package com.dgis.map.extensions

fun <T> unsafeLazy(initializer: () -> T): Lazy<T> {
    return lazy(
        LazyThreadSafetyMode.NONE,
        initializer
    )
}