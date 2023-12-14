package com.dgis.map

import android.util.Log
import org.json.JSONArray
import org.json.JSONObject
import org.json.JSONTokener

data class VendorConfig(val overrides: Map<String, String>) {
    companion object {
        fun from(content: String): VendorConfig? {
            val content = JSONTokener(content).nextValue() as JSONArray
            val config = content.getJSONObject(0)
            val overrides = config.getJSONObject("overrides")
            return VendorConfig(overrides.keys().asSequence().associateWith {
                overrides.getString(it)
            })
        }
    }
}

enum class CustomOverrides(val key: String) {
    TWINS_API("Modules/twins/webapi_url")
}

