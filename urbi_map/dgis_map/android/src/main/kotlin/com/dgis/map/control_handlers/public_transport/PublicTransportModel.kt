package com.dgis.map.control_handlers.public_transport

import ru.dgis.sdk.Duration
import ru.dgis.sdk.map.Color
import ru.dgis.sdk.routing.*
import java.util.*

class PublicTransportModel(
    route: TrafficRoute,
    startName: String? = null,
    finishName: String? = null,
    currentPosition: RoutePoint? = null,
) {
    /** Краткая информация (отображаемая в "шапке" карточки). */
    val briefModel: BriefPublicTransportModel = BriefPublicTransportModel(route, currentPosition)

    /** Точки пересадки. */
    val transfers: List<Transfer> = run {
        val durations = route.traffic.durations
        var prevEndPoint: String? = null
        var prevLineColor: RouteColor? = null
        val entries = route.route.publicTransportTransfers.entries
        val result = entries.mapTo(mutableListOf()) { entry ->
            val transfer = entry.value
            val isFirst = prevEndPoint == null
            val transferStartPoint = transfer.startPointName.takeIf(String::isNotEmpty)
            val title = transferStartPoint ?: prevEndPoint ?: startName
            prevEndPoint = transfer.finishPointName
            val transportTypes = transfer.transportTypes
            val transports = transfer.transports
            val onFoot = transports.isEmpty()
            val isMetro = transportTypes.size == 1 && transportTypes.first().isMetro
            val stops = transfer.stops

            var description = when {
                onFoot -> {
                    TransferDescription(
                        type = TransferDescriptionType.onFoot,
                        value = entry.length.meters
                    )
                }
                transports.size > 1 -> {
                    null
                }
                else -> {
                    val type = transportTypes.first()
                    val names = transports.first().names
                    when (names.size) {
                        0 -> TransferDescription(
                            type = TransferDescriptionType.ofType,
                            value = type.name
                        )
                        1 -> if (type.isMetro) TransferDescription(
                            type = TransferDescriptionType.metro,
                            value = names.first()
                        ) else null
                        else -> null
                    }
                }
            }

            val lineColor = when {
                onFoot -> RouteColor(
                    type = RouteColorType.dimmed
                )
                transportTypes.size > 1 -> RouteColor(
                    type = RouteColorType.normal
                )
                else -> transfer.color?.toRouteColor() ?: RouteColor(
                    type = RouteColorType.normal
                )
            }

            description = description?.copy(
                color = if (isMetro && lineColor.type == RouteColorType.withValue) TextColor(
                    type = TextColorType.withValue,
                    value = lineColor.value

                ) else TextColor(
                    type = TextColorType.normal
                )
            )

            val transportIcon = transfer.transportIcon?.let {
                if (lineColor.type == RouteColorType.withValue) it.recolor(lineColor.value!!) else it
            }


            Transfer(
                title = title,
                duration = durations.calculateDuration(entry).inSeconds.toInt(),
                icon = when {
                    isFirst -> TransferIcon(
                        type = TransferIconType.start
                    )
                    transportIcon != null -> TransferIcon(
                        type = TransferIconType.transport,
                        value = transportIcon
                    )
                    else -> TransferIcon(
                        type = TransferIconType.empty,
                        value = prevLineColor ?: RouteColor(
                            type = RouteColorType.normal
                        )
                    )
                },
                lineColor = lineColor,
                description = description,
                transports = if (description == null) transports else listOf(),
                stopCount = when {
                    onFoot -> null
                    stops.isEmpty() -> 0
                    else -> stops.size
                },
                useStationsInsteadOfStops = transportTypes.useStationsInsteadOfStops,
                getOffAfter = stops.lastOrNull(),
                stops = stops,
                boardingDescription = transfer.boardingDescription,
                cars = transfer.cars
            ).also {
                prevLineColor = lineColor
            }
        }
        result += Transfer(
            title = prevEndPoint?.takeIf { it.isNotEmpty() } ?: finishName,
            icon = TransferIcon(
                type = TransferIconType.finish
            ),
            lineColor = null,
            description = TransferDescription(
                type = TransferDescriptionType.finish,
                color = TextColor(
                    type = TextColorType.highlighted
                )
            )
        )
        result
    }

    fun toMap(): Map<String, Any>  {
        return mapOf(
            "brief" to briefModel.toMap(),
            "transfers" to transfers.map { it.toMap() },
        )
    }
}


private fun MillisecondsRouteAttribute.calculateDuration(entry: PublicTransportTransferRouteLongEntry): Duration {
    return calculateDuration(entry.point) - calculateDuration(entry.point + entry.length)
}

private val PublicTransportTransfer.transports: List<BriefPublicTransportModel.Transport>
    get() {
        if (routeParts.isEmpty()) {
            return listOf()
        }
        return routeParts.first().transports.map {
            BriefPublicTransportModel.Transport(
                icon = BriefPublicTransportModel.TransportIcon(
                    type = BriefPublicTransportModel.TransportIconType.ofType,
                    value = it.type.name,
                    color = if (it.type.isMetro) color?.argb else null,
                ),
                names = it.names
            )
        }
    }

private val PublicTransportTransfer.stops: List<String>
    get() {
        if (routeParts.isEmpty()) {
            return listOf()
        }
        return routeParts.first().intermediateStops.map { it.name }
    }

private val PublicTransportTransfer.boardingDescription: String?
    get() = firstTransport?.boardingSuggest?.takeIf {
        it.isNotEmpty()
    }?.replaceFirstChar { if (it.isLowerCase()) it.titlecase(Locale.ROOT) else it.toString() }

private val PublicTransportTransfer.cars: List<Car>
    get() {
        val transport = firstTransport ?: return listOf()
        if (transport.boardingSuggest.isEmpty()) {
            return listOf()
        }
        val numbers = transport.suggestedCarNumbers
        return List(5) {
            Car(highlighted = numbers.contains(it + 1))
        }
    }

private val Set<PublicTransportType>.useStationsInsteadOfStops: Boolean
    get() = if (size != 1) {
        false
    } else {
        when (first()) {
            PublicTransportType.METRO -> true
            PublicTransportType.SUBURBAN_TRAIN -> true
            PublicTransportType.PREMETRO -> true
            PublicTransportType.LIGHT_METRO -> true
            PublicTransportType.MOSCOW_CENTRAL_RING -> true
            PublicTransportType.MOSCOW_CENTRAL_DIAMETERS -> true
            else -> false
        }
    }

private fun Color.toRouteColor(): RouteColor =
    RouteColor(
        type = RouteColorType.withValue,
        value = this.argb,
    )

private fun BriefPublicTransportModel.TransportIcon.recolor(color: Int): BriefPublicTransportModel.TransportIcon =
    when (this.type) {
        BriefPublicTransportModel.TransportIconType.combined -> this
        BriefPublicTransportModel.TransportIconType.ofType -> copy(color = color)
        BriefPublicTransportModel.TransportIconType.special -> copy(color = color)
    }
