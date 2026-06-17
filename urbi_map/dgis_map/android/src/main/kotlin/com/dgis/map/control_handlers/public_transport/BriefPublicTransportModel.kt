package com.dgis.map.control_handlers.public_transport


import ru.dgis.sdk.Duration
import ru.dgis.sdk.map.*
import ru.dgis.sdk.routing.*
import kotlin.math.max

class BriefPublicTransportModel(route: TrafficRoute, currentPosition: RoutePoint? = null) {
    private val _transfers: List<PublicTransportTransferRouteLongEntry> =
        route.route.publicTransportTransfers.entries

    enum class TransportIconType {
        ofType,
        combined,
        special
    }
    data class TransportIcon(
        val type: TransportIconType,
        val value: String,
        val color: Int?,
    ) {
        fun toMap(): Map<String, Any?> {
            return mapOf(
                "type" to type.name,
                "value" to value,
                "color" to color,
            )
        }

    }

    /** Информация о транспорте. */
    data class Transport(
        /** Иконка. */
        val icon: TransportIcon,

        /**
         * Названия или номера маршрутов.
         * Например, ["12", "345"] или ["Ленинская линия"].
         */
        val names: List<String>,
    ) {
        fun toMap(): Map<String, Any?> {
            return mapOf(
                "icon" to icon.toMap(),
                "names" to names,
            )
        }
    }

    /**
     * Заголовок.
     * Предполагаемое время проезда, например, "1 ч 42 мин."
     */
    val duration: Long = if (currentPosition != null)
        route.traffic.durations.calculateDuration(currentPosition).inSeconds
    else
        route.estimatedDuration.inSeconds

    /** Информация о транспорте. */
    val transports: List<Transport> =
        _transfers.mapNotNull { entry ->
            val transfer = entry.value

            Transport(
                icon = transfer.transportIcon ?: return@mapNotNull null,
                names = transfer.transportNames
            )
        }

    /**
     * Описание.
     * Количество пересадок и время пешком, например, ["1 пересадка", "Пешком 15 мин"].
     */
    val transferCount : Int = _transfers.transferCount
    val onFootDuration: Long = route.onFootDuration.inSeconds
    val publicTransportTransferRouteLongEntry: List<Map<String, Any?>> = _transfers.map { it.toMap() }

    fun toMap(): Map<String, Any>  {
        return mapOf(
            "duration" to duration,
            "transports" to transports.map { it.toMap() },
            "transferCount" to transferCount,
            "onFootDuration" to onFootDuration,
            "publicTransportTransferRouteLongEntry" to publicTransportTransferRouteLongEntry,
        )
    }
}


private val TrafficRoute.estimatedDuration: Duration
    get() = traffic.durations.calculateDuration(RoutePoint(RouteDistance(0)))

private val List<PublicTransportTransferRouteLongEntry>.transferCount: Int
    get() = max(0, count { !it.value.onFoot } - 1)

private val TrafficRoute.onFootDuration: Duration
    get() {
        val durations = traffic.durations
        var result = Duration.ZERO
        route.publicTransportTransfers.entries.forEach {
            if (it.value.onFoot) result += durations.calculateDuration(it)
        }
        return result
    }

private val PublicTransportTransfer.onFoot: Boolean
    get() = routeParts.isEmpty() || routeParts.first().transports.isEmpty()

private fun MillisecondsRouteAttribute.calculateDuration(entry: PublicTransportTransferRouteLongEntry): Duration {
    return calculateDuration(entry.point) - calculateDuration(entry.point + entry.length)
}

internal val PublicTransportTransfer.transportTypes: Set<PublicTransportType>
    get() {
        if (routeParts.isEmpty()) {
            return setOf()
        }
        return routeParts.first().transports.mapTo(mutableSetOf()) {
            it.type
        }
    }

private val PublicTransportTransfer.transportNames: List<String>
    get() {
        if (routeParts.isEmpty()) {
            return listOf()
        }
        return routeParts.first().transports.flatMapTo(LinkedHashSet()) {
            it.names
        }.toList()
    }

internal val PublicTransportTransfer.firstTransport: PublicTransportInfo?
    get() = routeParts.firstOrNull()?.transports?.firstOrNull()

internal val PublicTransportTransfer.color: Color?
    get() = firstTransport?.color?.let { Color(it) }

internal val PublicTransportType.isMetro: Boolean
    get() = this == PublicTransportType.METRO ||
            this == PublicTransportType.LIGHT_METRO ||
            this == PublicTransportType.MOSCOW_CENTRAL_DIAMETERS ||
            this == PublicTransportType.MOSCOW_CENTRAL_RING

private val PublicTransportTransfer.routeLogo: String?
    get() = firstTransport?.routeLogo

internal val PublicTransportTransfer.transportIcon: BriefPublicTransportModel.TransportIcon?
    get() {
        val types = transportTypes
        var icon: BriefPublicTransportModel.TransportIcon?

        icon = when (types.size) {
            1 -> types.first().let {
                BriefPublicTransportModel.TransportIcon(
                    type = BriefPublicTransportModel.TransportIconType.ofType,
                    value = it.name,
                    color = if (it.isMetro) color?.argb else null
                )
            }
            else -> {
                BriefPublicTransportModel.TransportIcon(
                    type = BriefPublicTransportModel.TransportIconType.combined,
                    value = BriefPublicTransportModel.TransportIconType.combined.name,
                    color = null
                )
            }
        }
        routeLogo?.takeIf(String::isNotEmpty)?.let {
            icon = BriefPublicTransportModel.TransportIcon(
                type = BriefPublicTransportModel.TransportIconType.special,
                value = it,
                color = null,
            )
        }

        return icon
    }

// - PUBLIC TRANSPORT FOR ROUTE

fun PublicTransportTransferRouteLongEntry.toMap(): Map<String, Any?> {
    // Point property - RoutePoint with distance
    val point: Map<String, Any?> = mapOf(
        "distance" to mapOf(
            "millimeters" to this.point.distance.millimeters
        )
    )
    
    // Length property - RouteDistance
    val length: Map<String, Any?> = mapOf(
        "millimeters" to this.length.millimeters
    )
    
    // Value property - PublicTransportTransfer
    val value: Map<String, Any?> = mapOf(
        "startPointName" to this.value.startPointName,
        "finishPointName" to this.value.finishPointName,
        "routeParts" to this.value.routeParts.map { routePart ->
            mapOf(
                "transports" to routePart.transports.map { transport ->
                    mapOf(
                        "type" to transport.type.name,
                        "names" to transport.names,
                        "suggestedCarNumbers" to transport.suggestedCarNumbers,
                        "boardingSuggest" to transport.boardingSuggest,
                        "routeLogo" to transport.routeLogo,
                        "color" to transport.color
                    )
                },
                "intermediateStops" to routePart.intermediateStops.map { stop ->
                    mapOf(
                        "name" to stop.name
                    )
                }
            )
        }
    )
    
    return mapOf(
        "point" to point,
        "length" to length,
        "value" to value
    )
}
