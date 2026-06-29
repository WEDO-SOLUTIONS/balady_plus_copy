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
                // Mirrors the Android handler: use the WMS-style template
                // pointed at the ESRI WMTS RESTful endpoint. JPEG payloads
                // are 3–5× smaller than the default PNG path and the WMS
                // source lets the SDK ask the server for the actual pixel
                // size it needs (retina-friendly on high-DPR devices).
                satelliteTileSource = RasterTileSource(
                    context: try! self.sdk.context,
                    sublayerName: layerName,
                    sourceTemplate: RasterUrlTemplate.wmsSource(DGis.WmsRasterUrlTemplate(
                        urlTemplate: "https://server.arcgisonline.com/arcgis/rest/services/World_Imagery/MapServer/WMTS/tile/1.0.0/World_Imagery/default/default028mm/{z}/{y}/{x}.jpg"))
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
