package com.dgis.map.views.util

import android.os.Handler
import android.os.Looper
import java.util.concurrent.Executor

/** Выполняет действия на UI-потоке, не делая отправку, если вызов уже происходит на UI-потоке */
internal object DirectUiThreadExecutor : Executor {
    private val handler = Handler(Looper.getMainLooper())
    override fun execute(r: Runnable) {
        if (handler.looper.thread != Thread.currentThread()) {
            handler.post(r)
        }
        else {
            r.run()
        }
    }
}
