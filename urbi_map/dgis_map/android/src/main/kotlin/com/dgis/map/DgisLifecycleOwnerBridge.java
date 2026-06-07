package com.dgis.map;

import android.view.View;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.ViewTreeLifecycleOwner;

// Kotlin does not resolve this AndroidX class in this plugin setup, while Java sees
// the public bytecode API correctly.
public final class DgisLifecycleOwnerBridge {
    private DgisLifecycleOwnerBridge() {
    }

    public static void setViewTreeLifecycleOwner(View view, LifecycleOwner lifecycleOwner) {
        ViewTreeLifecycleOwner.set(view, lifecycleOwner);
    }
}
