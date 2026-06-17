package com.dgis.map.control_handlers

import io.flutter.plugin.common.EventChannel
import ru.dgis.sdk.LevelId
import ru.dgis.sdk.map.IndoorBuilding
import ru.dgis.sdk.map.Map

class IndoorControlHandler(
    map: Map,
    private val eventSink: EventChannel.EventSink? = null,
) : AutoCloseable {

    private val indoorManager = map.indoorManager

    private var focusedBuildingChannel: AutoCloseable? = null
    private var activeIndexChannel: AutoCloseable? = null

    private var _lastKnownLevelId: LevelId? = null

    val currentLevelId: LevelId?
        get() {
            val building = indoorManager.focusedBuilding
            if (building != null) {
                val levelId = building.levels.getOrNull(building.defaultLevelIndex.toInt())?.id
                if (levelId != null) {
                    _lastKnownLevelId = levelId
                }
                return levelId
            }
            return _lastKnownLevelId
        }

    private var focusedBuilding: IndoorBuilding? = null
        set(value) {
            field = value
            activeIndexChannel?.close()
            if (value != null) {
                val levelId = value.levels.getOrNull(value.defaultLevelIndex.toInt())?.id
                if (levelId != null) {
                    _lastKnownLevelId = levelId
                }
            }
            activeIndexChannel = value?.activeLevelIndexChannel?.connect { index ->
                eventSink?.success(
                    mapOf(
                        "event" to Events.activeLevelIndex.name,
                        "value" to index
                    )
                )
            }
        }

    init {
        focusedBuildingChannel = indoorManager.focusedBuildingChannel.connect { building ->
            focusedBuilding = building
            if (building == null) {
                eventSink?.success(
                    mapOf(
                        "event" to Events.hideLevels.name,
                    )
                )
                return@connect
            }
            val levels = building.levels.map { it.name }
            eventSink?.success(
                mapOf(
                    "event" to Events.levelNames.name,
                    "value" to levels,
                    "objectId" to building.id.objectId
                )
            )
        }
    }

    fun selectIndoorLevel(index: Long) {
        indoorManager.focusedBuilding?.activeLevelIndex = index
    }

    override fun close() {
        focusedBuildingChannel?.close()
    }

    companion object {
        private enum class Events {
            levelNames,
            hideLevels,
            activeLevelIndex,
        }
    }
}
