//
//  KaKaoMapView.swift
//  Feature
//
//  Created by sungyeon on 12/4/24.
//

import SwiftUI
import KakaoMapsSDK
import ComposableArchitecture
import Combine
import Models

struct KakaoMapView: UIViewRepresentable {
    @Binding var draw: Bool
    let store: StoreOf<MapFeature>

    func makeUIView(context: Self.Context) -> KMViewContainer {
        //need to correct view size
        let view: KMViewContainer = KMViewContainer(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))

        context.coordinator.createController(view)
        context.coordinator.updateStore(store) // store 업데이트

        return view
    }

    /// Updates the presented `UIView` (and coordinator) to the latest
    /// configuration.
    func updateUIView(_ uiView: KMViewContainer, context: Self.Context) {
        if draw {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                if context.coordinator.controller?.isEnginePrepared == false {
                    context.coordinator.controller?.prepareEngine()
                }
                
                if context.coordinator.controller?.isEngineActive == false {
                    context.coordinator.controller?.activateEngine()
                }
            }
        }
        else {
            context.coordinator.controller?.pauseEngine()
//            context.coordinator.controller?.resetEngine()
        }
    }
    
    func makeCoordinator() -> KakaoMapCoordinator {
        return KakaoMapCoordinator()
    }

    /// Cleans up the presented `UIView` (and coordinator) in
    /// anticipation of their removal.
    static func dismantleUIView(_ uiView: KMViewContainer, coordinator: KakaoMapCoordinator) {
        coordinator.controller?.resetEngine()
    }
    
    class KakaoMapCoordinator: NSObject, MapControllerDelegate {
        
        private var storeSubscription: AnyCancellable?

        override init() {
            first = true
            auth = false
            super.init()
        }
        
        // store 업데이트 메서드 추가
         func updateStore(_ store: StoreOf<MapFeature>) {
             storeSubscription?.cancel()
             storeSubscription = store.publisher
                 .map(\.allRestaurants)
                 .removeDuplicates()
                 .sink { [weak self] restaurants in
                     if !restaurants.isEmpty {
                         self?.createRestaurantPois(restaurants: restaurants)
                     }
                 }
         }
        
        func createController(_ view: KMViewContainer) {
            container = view
            controller = KMController(viewContainer: view)
            controller?.delegate = self
        }
        
        func addViews() {
            let defaultPosition: MapPoint = MapPoint(longitude: 126.978365, latitude: 37.566691)
            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition)
            
            controller?.addView(mapviewInfo)
        }
        
        func addViewSucceeded(_ viewName: String, viewInfoName: String) {
            print("OK")
            let view = controller?.getView("mapview")
            view?.viewRect = container!.bounds
        }
        
        func containerDidResized(_ size: CGSize) {
            let mapView: KakaoMap? = controller?.getView("mapview") as? KakaoMap
            mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
            if first {
                let cameraUpdate: CameraUpdate = CameraUpdate.make(target: MapPoint(longitude: 126.978365, latitude: 37.566691), mapView: mapView!)
                mapView?.moveCamera(cameraUpdate)
                first = false
            }
        }
        
        func authenticationSucceeded() {
            auth = true
        }
        
        var controller: KMController?
        var container: KMViewContainer?
        var first: Bool
        var auth: Bool
        
        func createRestaurantPois(restaurants: [RestaurantCard]) {
            let view = controller?.getView("mapview") as? KakaoMap
            let manager = view?.getLabelManager()
            
            // 레이어가 없다면 생성
            let restaurantLayer = LodLabelLayerOptions(
                layerID: "restaurants",
                competitionType: .none,
                competitionUnit: .symbolFirst,
                orderType: .rank,
                zOrder: 0,
                radius: 20.0
            )
            let _ = manager?.addLodLabelLayer(option: restaurantLayer)
            
            // POI 스타일 생성
            let restaurantSymbol = UIImage(named: "restaurant_pin") // 적절한 이미지로 변경 필요
            let anchorPoint = CGPoint(x: 0.5, y: 1.0)
            
            let textLineStyles = [
                PoiTextLineStyle(
                    textStyle: TextStyle(
                        fontSize: 15,
                        fontColor: UIColor.black,
                        strokeThickness: 2,
                        strokeColor: UIColor.white
                    )
                )
            ]
            
            let iconStyle = PoiIconStyle(symbol: restaurantSymbol, anchorPoint: anchorPoint)
            let textStyle = PoiTextStyle(textLineStyles: textLineStyles)
            let poiStyle = PoiStyle(
                styleID: "restaurantStyle",
                styles: [PerLevelPoiStyle(iconStyle: iconStyle, textStyle: textStyle, level: 0)]
            )
            manager?.addPoiStyle(poiStyle)
            
            // POI 생성
            if let layer = manager?.getLodLabelLayer(layerID: "restaurants") {
                var poiOptions: [PoiOptions] = []
                var positions: [MapPoint] = []
                
                for (index, restaurant) in restaurants.enumerated() {
                    let options = PoiOptions(styleID: "restaurantStyle")
                    options.rank = index
                    options.transformType = .decal
                    options.clickable = true
                    options.addText(PoiText(text: restaurant.name, styleIndex: 0))
                    
                    poiOptions.append(options)
                    positions.append(MapPoint(
                        longitude: restaurant.longitude ?? 0.0,
                        latitude: restaurant.latitude ?? 0.0
                    ))
                }
                
                let _ = layer.addLodPois(options: poiOptions, at: positions)
                layer.showAllLodPois()
            }
        }
        
        func createLodPois() {
            let view = controller?.getView("mapview") as? KakaoMap
            let manager = view?.getLabelManager()
            
            for index in 0 ... (_layerNames.count - 1) {
                let layer = manager?.getLodLabelLayer(layerID: _layerNames[index])
                let datas = testLodDatas(layerIndex: index)
                let _ = layer?.addLodPois(options: datas.0, at: datas.1)    // 대량의 POI를 add할때는 개별로 add하기 보다는 addPois를 사용하는 것이 효율적이다.
                layer?.showAllLodPois()
            }
        }
        
        func testLodDatas(layerIndex: Int) -> ([PoiOptions], [MapPoint]) {
            var datas = [PoiOptions]()
            var positions = [MapPoint]()
            
            var coords = [MapPoint]()
            var boundary = [GeoCoordinate]()
            
            coords.append(MapPoint(longitude: 126.627459, latitude: 35.129776))
            coords.append(MapPoint(longitude: 126.875658, latitude: 37.492889))
            coords.append(MapPoint(longitude: 128.774832, latitude: 35.126031))
            
            boundary.append(GeoCoordinate(longitude: 2.694945, latitude: 3.590908))
            boundary.append(GeoCoordinate(longitude: 0.269494, latitude: 0.179662))
            boundary.append(GeoCoordinate(longitude: 0.359326, latitude: 0.628808))
            
            for index in 1 ... 1000 {
                let options = PoiOptions(styleID: "customStyle" + String(layerIndex))
                options.rank = index              
                let coord = coords[layerIndex].wgsCoord
                
                options.transformType = .decal
                options.clickable = true
                options.addText(PoiText(text: _layerNames[layerIndex], styleIndex: 0))
                options.addText(PoiText(text: String(index), styleIndex: 1))
                
                datas.append(options)
                positions.append(MapPoint(longitude: coord.longitude + Double.random(in: 0...boundary[layerIndex].longitude),
                                          latitude: coord.latitude + Double.random(in: 0...boundary[layerIndex].latitude)))
            }
            
            return (datas, positions)
        }
        
//        override func containerDidResized(_ size: CGSize) {
//            let mapView: KakaoMap? = mapController?.getView("mapview") as? KakaoMap
//            mapView?.viewRect = CGRect(origin: CGPoint(x: 0.0, y: 0.0), size: size)
//        }
        
        let _layerNames: [String] = ["korea", "seoul", "busan"]
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        KakaoMapView(draw: .constant(false))
//    }
//}


