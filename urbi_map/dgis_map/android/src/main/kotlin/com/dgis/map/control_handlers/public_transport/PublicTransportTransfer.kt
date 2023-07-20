package com.dgis.map.control_handlers.public_transport

enum class RouteColorType {
    normal,
    dimmed,
    withValue
}

/** Цвет линии маршрута. */
data class RouteColor(
    val type: RouteColorType,
    val value: Int? = null,
) {
    fun toMap(): Map<String, Any?> {
        return mapOf(
            "type" to type.name,
            "value" to value
        )
    }
}

enum class TransferIconType {
    start,
    finish,
    empty,
    transport
}

/** Иконка точки пересадки. */
data class TransferIcon(
    val type: TransferIconType,
    val value: Any? = null,
) {
    fun toMap(): Map<String, Any?> {
        val mappedValue = when (value) {
            is BriefPublicTransportModel.TransportIcon -> value.toMap()
            is RouteColor -> value.toMap()
            else -> value
        }
        return mapOf(
            "type" to type.name,
            "value" to mappedValue
        )
    }
}


enum class TextColorType {
    normal,
    highlighted,
    withValue,
}

/** Цвет текста. */
data class TextColor(
    val type: TextColorType,
    val value: Int? = null
) {
    fun toMap(): Map<String, Any?> {
        return mapOf(
            "type" to type.name,
            "value" to value
        )
    }
}

/** Вагон. */
data class Car(val highlighted: Boolean) {
    fun toMap(): Map<String, Any?> {
        return mapOf(
            "highlighted" to highlighted
        )
    }
}

enum class TransferDescriptionType {
    onFoot,
    metro,
    ofType,
    finish
}

data class TransferDescription(
    val type: TransferDescriptionType,
    val value: Any? = null,
    val color: TextColor = TextColor(
        type = TextColorType.normal,
        value = null,
    ),
) {
    fun toMap(): Map<String, Any?> {
        return mapOf(
            "type" to type.name,
            "value" to value,
            "color" to color.toMap()
        )
    }
}

data class Transfer(
    /**
     * Заголовок.
     * Название точки пересадки или startName/finishName для начальной/конечной точки.
     */
    val title: String?,

    /**
     * Время движения до следующей точки.
     * Например, "1 ч 42 мин".
     */
    val duration: Int? = null,

    /** Иконка. */
    val icon: TransferIcon,

    /**
     * Цвет линии до следующей точки.
     * Отсутствует у конечной точки.
     */
    val lineColor: RouteColor?,

    /**
     * Описание.
     * В зависимости от типа транспорта может быть:
     * - Расстояние пешком, например, "Пешком 15 мин".
     * - Название станции метро, например, "Ленинская линия".
     * - Название типа транспорта, например, "Электричка".
     */
    val description: TransferDescription?,

    /** Информация о транспорте. */
    val transports: List<BriefPublicTransportModel.Transport> = listOf(),

    /**
     * Количество остановок.
     * Например, "4 остановки" или "Без остановок".
     */
    val stopCount: Int? = null,

    val useStationsInsteadOfStops: Boolean = false,

    /**
     * После какой остановки необходимо выходить.
     * Например, "Выходите после: Морской проспект"
     */
    val getOffAfter: String? = null,

    /** Остановки. */
    val stops: List<String> = listOf(),

    /**
     * Описание предлагаемой посадки.
     * Например, "Садитесь в начало поезда".
     */
    val boardingDescription: String? = null,

    /** Вагоны, среди которых предлагаемые для посадки подсвечены. */
    val cars: List<Car> = listOf(),
) {
    fun toMap(): Map<String, Any?> {
        return mapOf(
            "title" to title,
            "duration" to duration,
            "icon" to icon.toMap(),
            "lineColor" to lineColor?.toMap(),
            "description" to description?.toMap(),
            "transports" to transports.map { it.toMap() },
            "stopCount" to stopCount,
            "useStationsInsteadOfStops" to useStationsInsteadOfStops,
            "getOffAfter" to getOffAfter,
            "stops" to stops,
            "boardingDescription" to boardingDescription,
            "cars" to cars.map { it.toMap() },
        )
    }
}
