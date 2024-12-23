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
        private var store: StoreOf<MapFeature>?
        private var storeSubscription: AnyCancellable?
        private let authenticationSubject = PassthroughSubject<Void, Never>()

        override init() {
            first = true
            auth = false
            super.init()
        }
        
        // store 업데이트 메서드 추가
         func updateStore(_ store: StoreOf<MapFeature>) {
             self.store = store
             storeSubscription?.cancel()
             storeSubscription = store.publisher
                 .map(\.allRestaurants)
                 .removeDuplicates()
                 .delay(for: .seconds(2), scheduler: DispatchQueue.main)
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
            let mapviewInfo: MapviewInfo = MapviewInfo(viewName: "mapview", viewInfoName: "map", defaultPosition: defaultPosition, defaultLevel: 10)
            
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
            print("Authentication succeeded")
            auth = true
            authenticationSubject.send()
            let view = controller?.getView("mapview") as? KakaoMap
            let manager = view?.getLabelManager()
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
        
            let anchorPoint = CGPoint(x: 0.5, y: 1.0)
            let textLineStyles = [
                PoiTextLineStyle(
                    textStyle: TextStyle(
                        fontSize: 30,
                        fontColor: UIColor.black,
                        strokeThickness: 2,
                        strokeColor: UIColor.white
                    )
                )
            ]
            
            let textStyle = PoiTextStyle(textLineStyles: textLineStyles)
            
            let koreanIcon = HomeRestaurantCategory.korean.emoji.toImage()
            let japaneseIcon = HomeRestaurantCategory.japanese.emoji.toImage()
            let chinesIcon = HomeRestaurantCategory.chinese.emoji.toImage()
            let westernIcon = HomeRestaurantCategory.western.emoji.toImage()
            let asianIcon = HomeRestaurantCategory.asian.emoji.toImage()
            let etcIcon = HomeRestaurantCategory.etc.emoji.toImage()

            
            let koreanIconStyle = PoiIconStyle(symbol: koreanIcon, anchorPoint: anchorPoint)
            let japaneseIconStyle = PoiIconStyle(symbol: japaneseIcon, anchorPoint: anchorPoint)
            let chineseIconStyle = PoiIconStyle(symbol: chinesIcon, anchorPoint: anchorPoint)
            let westernIconStyle = PoiIconStyle(symbol: westernIcon, anchorPoint: anchorPoint)
            let asianIconStyle = PoiIconStyle(symbol: asianIcon, anchorPoint: anchorPoint)
            let etcIconStyle = PoiIconStyle(symbol: etcIcon, anchorPoint: anchorPoint)
            
            
            let koreanPoiStyle = PoiStyle(
                styleID: "한식",
                styles: [PerLevelPoiStyle(iconStyle: koreanIconStyle, textStyle: textStyle, level: 0)]
            )
            
            let chinesePoiStyle = PoiStyle(
                styleID: "중식",
                styles: [PerLevelPoiStyle(iconStyle: chineseIconStyle, textStyle: textStyle, level: 0)]
            )
            
            let japanesePoiStyle = PoiStyle(
                styleID: "일식",
                styles: [PerLevelPoiStyle(iconStyle: japaneseIconStyle, textStyle: textStyle, level: 0)]
            )
            
            let westernPoiStyle = PoiStyle(
                styleID: "양식",
                styles: [PerLevelPoiStyle(iconStyle: westernIconStyle, textStyle: textStyle, level: 0)]
            )
            
            let asianPoiStyle = PoiStyle(
                styleID: "아시안",
                styles: [PerLevelPoiStyle(iconStyle: asianIconStyle, textStyle: textStyle, level: 0)]
            )
            
            let etcPoiStyle = PoiStyle(
                styleID: "기타",
                styles: [PerLevelPoiStyle(iconStyle: etcIconStyle, textStyle: textStyle, level: 0)]
            )
            
            let styles = [
                koreanPoiStyle,
                japanesePoiStyle,
                chinesePoiStyle,
                westernPoiStyle,
                asianPoiStyle,
                etcPoiStyle
            ]
            
            styles.forEach { manager?.addPoiStyle($0) }
                        
            // POI 생성
            if let layer = manager?.getLodLabelLayer(layerID: "restaurants") {
//                var poiOptions: [PoiOptions] = []
//                var positions: [MapPoint] = []
                
                for (index, restaurant) in restaurants.enumerated() {
                    let options = PoiOptions(styleID: restaurant.category.title)
                    options.rank = index
                    options.transformType = .decal
                    options.clickable = true
                    options.addText(PoiText(text: restaurant.name, styleIndex: 0))
                    
                    
//                    poiOptions.append(options)
//                    positions.append(MapPoint(
//                        longitude: restaurant.longitude ?? 0.0,
//                        latitude: restaurant.latitude ?? 0.0
//                    ))
                    
                    let poi1 = layer.addLodPoi(option: options, at: MapPoint(
                        longitude: restaurant.longitude ?? 0.0,
                        latitude: restaurant.latitude ?? 0.0
                    ))
                    
                    poi1?.userObject = restaurant as AnyObject
                    _ = poi1?.addPoiTappedEventHandler(target: self, handler: KakaoMapCoordinator.didTapPoi(_:))
                }
                
                layer.showAllLodPois()
            }
            
        }
        
        func didTapPoi(_ param: PoiInteractionEventParam) {
            let resaurant = param.poiItem.userObject as? RestaurantCard
            store?.send(.tapMarker(resaurant!))
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        KakaoMapView(draw: .constant(false))
//    }
//}


