import Foundation
import ComposableArchitecture
import Models

public struct GeocodingError: Error {
    let message: String
}

public struct KakaoGeocodingClient {
    
    public var fetchAddressInfo: (String) async throws -> GeocodingResponse
    
    public static let live = Self { address in
        
        guard let apiKey = Bundle.main.infoDictionary?["KAKAO_API_KEY"] as? String else { throw HTTPError.missingAPIKey }
        
        let baseURL = "https://dapi.kakao.com/v2/local/search/address"
        
        guard let encodedAddress = address.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)?query=\(encodedAddress)") else {
            throw HTTPError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.addValue("KakaoAK \(apiKey)", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        print("🔄 cURL: \(request.cURL())")
        
//        print("📥 Response: \(response)")
//        print("📦 Data: \(String(data: data, encoding: .utf8) ?? "nil")")
        
        guard let httpResponse = response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
            throw HTTPError.networkError
        }
        
        let decoder = JSONDecoder()
        let result = try decoder.decode(GeocodingResponse.self, from: data)
        
//        guard let firstDocument = result. else {
//            throw GeocodingError(message: "No results found")
//        }
        
        return result
    }
}

// DependencyKey 준수
extension KakaoGeocodingClient: DependencyKey {
    public static let liveValue = Self.live
}

// DependencyValues extension
public extension DependencyValues {
    var kakaoGeocodingClient: KakaoGeocodingClient {
        get { self[KakaoGeocodingClient.self] }
        set { self[KakaoGeocodingClient.self] = newValue }
    }
}

extension KakaoGeocodingClient {
    public static let preview = Self {_ in
        return GeocodingResponse.preview
    }
}

extension URLRequest {
    func cURL() -> String {
        var result = "curl -v"
        
        if let method = httpMethod {
            result += " -X \(method)"
        }
        
        if let headers = allHTTPHeaderFields {
            for (header, value) in headers {
                result += " -H '\(header): \(value)'"
            }
        }
        
        if let url = url {
            result += " '\(url.absoluteString)'"
        }
        
        return result
    }
}
