import Foundation
import DGis

class EverGisLayerHandler {
    private enum ParseError: Error {
        case error(String)
    }

    private let endPointData = EverGisEndPointData(
        baseUrl: "https://ever.2gis.ru/sp/",
        username: "mapnessuser",
        password: "W92Xu{[L'1eSD"
    )

    private let sdkContext: Context
    
    private lazy var everGisLayerManager = EverGisLayerManager(
        context: self.sdkContext,
        endpointData: self.endPointData
    )
    
    private var layers: [String: EverGisLayer] = [:]
    private var filters: [EverGisAttributeFilter] = []

    private var future: Cancellable?
    
    init(sdkContext: Context) {
        self.sdkContext = sdkContext
    }
    
    func getLayers(_ map: Map, _ completion: @escaping ([EverGisLayerMessage]?, FlutterError?) -> Void) {
        self.future = self.everGisLayerManager.getLayers().sink(
            receiveValue: {
                [weak self] availableLayers in
                guard let availableLayers = availableLayers else {
                    completion(
                        nil,
                        FlutterError(
                            code: "IllegalArgumentException",
                            message: "No available Evergis layers",
                            details: nil
                        )
                    )
                    return
                }

                for layer in availableLayers {
                    guard self?.layers[layer.alias] == nil else { continue }
                    self?.layers[layer.alias] = layer
                    map.addSource(source: layer)
                }

                let message = availableLayers
                    .map { layer in
                        EverGisLayerMessage.make(
                            withName: layer.name,
                            alias: layer.alias
                        )
                    }
                completion(message, nil)
            },
            failure: { error in
                completion(
                    nil,
                    FlutterError(
                        code: "FetchLayersError",
                        message: error.description,
                        details: nil
                    ))
            }
        )
    }
    
    func setLayerVisible(alias: String, isVisible: Bool, completion: @escaping (FlutterError?) -> Void) {
        guard let layer = self.layers[alias] else {
            completion(FlutterError(
                code: "FetchLayersError",
                message: "Layer with alias \(alias) not found",
                details: nil
            ))
            return
        }
        if isVisible {
            layer.drawLayer()
        } else {
            layer.clearLayer()
        }
        
        completion(nil)
    }
    
    func cancel() {
        self.future?.cancel()
    }

    func applyEverGisFiltersLayerAlias(
        layerAlias: String,
        stringFilters: [EGStringFilterMessage],
        doubleFilters: [EGDoubleFilterMessage],
        intFilters: [EGIntFilterMessage],
        dateRangeFilters: [EGDateRangeFilterMessage],
        complexDateFilters: [EGComplexDateFilterMessage],
        completion: @escaping (FlutterError?) -> Void
    ) {
        guard let layer = self.layers[layerAlias] else {
            completion(FlutterError(
                code: "FetchLayersError",
                message: "Layer with alias \(layerAlias) not found",
                details: nil
            ))
            return
        }

        filters.removeAll()

        do {
            filters.append(contentsOf: stringFilters.map(mapMessageToFilter(_:)))
            filters.append(contentsOf: intFilters.map(mapMessageToFilter(_:)))
            filters.append(contentsOf: doubleFilters.map(mapMessageToFilter(_:)))
            try filters.append(contentsOf: dateRangeFilters.map(mapMessageToFilter(_:)))
            try filters.append(contentsOf: complexDateFilters.map(mapMessageToFilter(_:)).flatMap { $0 })

            layer.filter = filters
            completion(nil)
        } catch ParseError.error(let message){
            completion(FlutterError(code: "EvergisError", message: message, details: nil))
        } catch {
            completion(FlutterError(code: "EvergisError", message: "ACHTUNG", details: nil))
        }
    }

    private func mapMessageToFilter(_ message: EGStringFilterMessage) -> EverGisAttributeFilter {
        return EverGisAttributeFilter.createStringFilter(
            attributeName: message.attrName,
            type: .cONTAINS,
            value: message.value
        )
    }

    private func mapMessageToFilter(_ message: EGIntFilterMessage) -> EverGisAttributeFilter {
        return EverGisAttributeFilter.createIntFilter(
            attributeName: message.attrName,
            type: NumericalFilterType.eQUAL,
            value: message.value.int64Value
        )
    }

    private func mapMessageToFilter(_ message: EGDoubleFilterMessage) -> EverGisAttributeFilter {
        return EverGisAttributeFilter.createDoubleInRangeFilter(
            attributeName: message.attrName,
            min: message.from.doubleValue,
            max: message.to.doubleValue
        )
    }

    private func mapMessageToFilter(_ message: EGDateRangeFilterMessage) throws -> EverGisAttributeFilter {
        guard message.from != nil || message.to != nil else {
            throw ParseError.error("Both 'from' and 'to' arguments are null")
        }

        if let from = message.from, let to = message.to {
            return EverGisAttributeFilter.createDatetimePeriodFilter(
                attributeName: message.attrName,
                begin: from,
                end: to
            )
        }

        if message.from == nil, let to = message.to {
            return EverGisAttributeFilter.createDatetimeFilter(
                attributeName: message.attrName,
                type: .lESS_OR_EQUAL,
                value: to
            )
        }

        if let from = message.from, message.to == nil {
            return EverGisAttributeFilter.createDatetimeFilter(
                attributeName: message.attrName,
                type: .mORE_OR_EQUAL,
                value: from
            )
        }

        throw ParseError.error("Illegal arguments")
    }

    private func mapMessageToFilter(_ message: EGComplexDateFilterMessage) throws -> [EverGisAttributeFilter] {
        guard message.from != nil || message.to != nil else {
            throw ParseError.error("Both 'from' and 'to' arguments are null")
        }

        if let from = message.from, let to = message.to {
            return [
                EverGisAttributeFilter.createDatetimeFilter(
                    attributeName: message.attrFromName,
                    type: .mORE_OR_EQUAL,
                    value: from
                ),
                EverGisAttributeFilter.createDatetimeFilter(
                    attributeName: message.attrToName,
                    type: .lESS_OR_EQUAL,
                    value: to
                )
            ]
        }

        if message.from == nil, let to = message.to {
            return [EverGisAttributeFilter.createDatetimeFilter(
                attributeName: message.attrToName,
                type: .lESS_OR_EQUAL,
                value: to
            )]
        }

        if let from = message.from, message.to == nil {
            return [EverGisAttributeFilter.createDatetimeFilter(
                attributeName: message.attrFromName,
                type: .mORE_OR_EQUAL,
                value: from
            )]
        }

        throw ParseError.error("Illegal arguments")
    }
}
