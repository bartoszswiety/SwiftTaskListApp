import Foundation

public struct Safe<Base: Decodable>: Decodable {
    public let value: Base?

    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            value = try container.decode(Base.self)
        } catch {
            assertionFailure("ERRORX: \(error)")
            // TODO: automatically send a report about a corrupted data
            value = nil
        }
    }
}

extension KeyedDecodingContainer {
    public func decode<T: Decodable>(_ key: Key, as _: T.Type = T.self) throws -> T {
        return try decode(T.self, forKey: key)
    }

    public func decodeIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) throws -> T? {
        return try decodeIfPresent(T.self, forKey: key)
    }
}

extension KeyedDecodingContainer {
    public func decodeSafely<T: Decodable>(_ key: KeyedDecodingContainer.Key) -> T? {
        return decodeSafely(T.self, forKey: key)
    }

    public func decodeSafely<T: Decodable>(_: T.Type, forKey key: KeyedDecodingContainer.Key) -> T? {
        let decoded = try? decode(Safe<T>.self, forKey: key)
        return decoded?.value
    }

    public func decodeSafelyIfPresent<T: Decodable>(_ key: KeyedDecodingContainer.Key) -> T? {
        return decodeSafelyIfPresent(T.self, forKey: key)
    }

    public func decodeSafelyIfPresent<T: Decodable>(_: T.Type, forKey key: KeyedDecodingContainer.Key) -> T? {
        let decoded = ((try? decodeIfPresent(Safe<T>.self, forKey: key)) as Safe<T>??)
        return decoded??.value
    }
}

extension KeyedDecodingContainer {
    public func decodeSafelyArray<T: Decodable>(of _: T.Type, forKey key: KeyedDecodingContainer.Key) -> [T] {
        let array = decodeSafely([Safe<T>].self, forKey: key)
        return array?.compactMap { $0.value } ?? []
    }
}

extension JSONDecoder {
    public func decodeSafelyArray<T: Decodable>(of _: T.Type, from data: Data) -> [T] {
        guard let array = try? decode([Safe<T>].self, from: data) else { return [] }
        return array.compactMap { $0.value }
    }
}

public struct Id<Entity>: Hashable {
    public let raw: String
    public init(_ raw: String) {
        self.raw = raw
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(raw.hashValue)
    }

    public static func == (lhs: Id, rhs: Id) -> Bool {
        return lhs.raw == rhs.raw
    }
}

extension Id: Codable {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let raw = try container.decode(String.self)
        if raw.isEmpty {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Cannot initialize Id from an empty string"
            )
        }
        self.init(raw)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(raw)
    }
}
