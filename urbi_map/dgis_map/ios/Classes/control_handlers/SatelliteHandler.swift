//
//  SatelliteHandler.swift
//  dgis_map
//

import Foundation
import DGis

class SatelliteHandler {

    private var sdk: Container
    private var map: Map
    private var satelliteTileSource: Source?
    private var cachedTileUri: String?
    private var cachedLayerName: String?
    private var isVisible = false

    init(sdkContext: Container, map: Map) {
        self.sdk = sdkContext
        self.map = map
    }

    func toggleSatellite(_ message: SatelliteMapMessage,
                         completion: @escaping (Result<Bool, any Error>) -> Void) {
        if message.enabled == true {
            let tileUri = message.rasterTileUri ?? ""
            let layerName = message.layerName ?? ""
            let needsRecreate = satelliteTileSource == nil
                || cachedTileUri != tileUri
                || cachedLayerName != layerName

            if needsRecreate {
                if let old = satelliteTileSource,
                   map.sources.contains(old) {
                    map.removeSource(source: old)
                }
                satelliteTileSource = RasterTileSource(
                    context: try! self.sdk.context,
                    sublayerName: layerName,
                    sourceTemplate: RasterUrlTemplate.defaultSource(DGis.DefaultRasterUrlTemplate(
                        urlTemplate: tileUri))
                )
                cachedTileUri = tileUri
                cachedLayerName = layerName
            }

            if let source = satelliteTileSource,
               !map.sources.contains(source) {
                map.addSource(source: source)
            }
        } else {
            if let source = satelliteTileSource,
               map.sources.contains(source) {
                map.removeSource(source: source)
            }
        }

        isVisible = message.enabled
        completion(Result.success(isVisible))
    }
}
