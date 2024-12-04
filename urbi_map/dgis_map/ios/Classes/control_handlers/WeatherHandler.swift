//
//  WeatherHandler.swift
//  dgis_map
//
//  Created by vladimir efimov on 08.12.2023.
//


import Foundation
import DGis

class WeatherHandler {
    
    private var sdk: Container
       private var map: Map
       private var temperatureTileSource: Source?
       private var precipitationTileSource: Source?
       private var isHeatmapVisible = false

       init(sdkContext: Container, map: Map) {
           self.sdk = sdkContext
           self.map = map
       }

    
       func toggleHeatmap(_ message: WeatherMapMessage,
                          completion: @escaping (NSNumber?, FlutterError?) -> Void) {
           if message.enabled == true {
               switch message.type?.value {
               case .temperature:
                   if let precipitationTileSource = precipitationTileSource,
                      map.sources.contains(precipitationTileSource) {
                       map.removeSource(source: precipitationTileSource)
                   }

                   if temperatureTileSource == nil {
                       temperatureTileSource =  RasterTileSource(
                        context: try! self.sdk.context,
                          sublayerName: message.layerName ?? "",
                        sourceTemplate: RasterUrlTemplate.defaultSource(DGis.DefaultRasterUrlTemplate(
                            urlTemplate: message.rasterTileUri ?? ""))
                       )
                   }

                   if let temperatureTileSource = temperatureTileSource,
                      !map.sources.contains(temperatureTileSource) {
                       map.addSource(source: temperatureTileSource)
                   }

               case .precipitation:
                   if let temperatureTileSource = temperatureTileSource,
                      map.sources.contains(temperatureTileSource) {
                       map.removeSource(source: temperatureTileSource)
                   }

                   if precipitationTileSource == nil {
                      
                       precipitationTileSource =  RasterTileSource(
                        context: try! self.sdk.context,
                        sublayerName: message.layerName ?? "",
                        sourceTemplate: RasterUrlTemplate.defaultSource(DGis.DefaultRasterUrlTemplate(
                            urlTemplate:  message.rasterTileUri ?? ""))
                       )
                   }

                   if let precipitationTileSource = precipitationTileSource,
                      !map.sources.contains(precipitationTileSource) {
                       map.addSource(source: precipitationTileSource)
                   }

               default:
                   break
               }
           } else {
               if let precipitationTileSource = precipitationTileSource,
                  map.sources.contains(precipitationTileSource) {
                   map.removeSource(source: precipitationTileSource)
               }

               if let temperatureTileSource = temperatureTileSource,
                  map.sources.contains(temperatureTileSource) {
                   map.removeSource(source: temperatureTileSource)
               }
           }

           isHeatmapVisible = message.enabled
           completion(NSNumber(value: self.isHeatmapVisible), nil)
       }
}
