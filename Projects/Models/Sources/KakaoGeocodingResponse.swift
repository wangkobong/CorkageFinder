import Foundation

public struct GeocodingResponse: Codable {
    public let documents: [Document]
    public let meta: Meta
    
    public struct Document: Codable {
        public let address: Address
        public let addressName: String
        public let addressType: String
        public let roadAddress: RoadAddress?
        public let x: String
        public let y: String
        
        enum CodingKeys: String, CodingKey {
            case address
            case addressName = "address_name"
            case addressType = "address_type"
            case roadAddress = "road_address"
            case x, y
        }
    }
    
    public struct Address: Codable {
        public let addressName: String
        public let bCode: String
        public let hCode: String
        public let mainAddressNo: String
        public let mountainYn: String
        public let region1depthName: String
        public let region2depthName: String
        public let region3depthHName: String
        public let region3depthName: String
        public let subAddressNo: String
        public let x: String
        public let y: String
        
        enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case bCode = "b_code"
            case hCode = "h_code"
            case mainAddressNo = "main_address_no"
            case mountainYn = "mountain_yn"
            case region1depthName = "region_1depth_name"
            case region2depthName = "region_2depth_name"
            case region3depthHName = "region_3depth_h_name"
            case region3depthName = "region_3depth_name"
            case subAddressNo = "sub_address_no"
            case x, y
        }
    }
    
    public struct RoadAddress: Codable {
        public let addressName: String
        public let buildingName: String
        public let mainBuildingNo: String
        public let region1depthName: String
        public let region2depthName: String
        public let region3depthName: String
        public  let roadName: String
        public let subBuildingNo: String
        public let undergroundYn: String
        public let x: String
        public let y: String
        public let zoneNo: String
        
        enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case buildingName = "building_name"
            case mainBuildingNo = "main_building_no"
            case region1depthName = "region_1depth_name"
            case region2depthName = "region_2depth_name"
            case region3depthName = "region_3depth_name"
            case roadName = "road_name"
            case subBuildingNo = "sub_building_no"
            case undergroundYn = "underground_yn"
            case x, y
            case zoneNo = "zone_no"
        }
    }
    
    public struct Meta: Codable {
        public let isEnd: Bool
        public let pageableCount: Int
        public let totalCount: Int
        
        enum CodingKeys: String, CodingKey {
            case isEnd = "is_end"
            case pageableCount = "pageable_count"
            case totalCount = "total_count"
        }
    }
}

extension GeocodingResponse.Document {
    var coordinates: (latitude: Double, longitude: Double) {
        (Double(y) ?? 0, Double(x) ?? 0)
    }
}

extension GeocodingResponse {
   public static let preview = GeocodingResponse(
       documents: [
           Document(
               address: Address(
                   addressName: "서울 강남구 역삼동 858",
                   bCode: "1168010100",
                   hCode: "1168010100",
                   mainAddressNo: "858",
                   mountainYn: "N",
                   region1depthName: "서울",
                   region2depthName: "강남구",
                   region3depthHName: "역삼1동",
                   region3depthName: "역삼동",
                   subAddressNo: "",
                   x: "127.028003",
                   y: "37.497175"
               ),
               addressName: "서울 강남구 테헤란로 521",
               addressType: "ROAD_ADDR",
               roadAddress: RoadAddress(
                   addressName: "서울 강남구 테헤란로 521",
                   buildingName: "파르나스타워",
                   mainBuildingNo: "521",
                   region1depthName: "서울",
                   region2depthName: "강남구",
                   region3depthName: "역삼동",
                   roadName: "테헤란로",
                   subBuildingNo: "",
                   undergroundYn: "N",
                   x: "127.028003",
                   y: "37.497175",
                   zoneNo: "06164"
               ),
               x: "127.028003",
               y: "37.497175"
           )
       ],
       meta: Meta(
           isEnd: true,
           pageableCount: 1,
           totalCount: 1
       )
   )
}
