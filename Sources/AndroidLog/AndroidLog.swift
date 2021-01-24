import ndk.log
import Logging

public struct AndroidLogHandler: LogHandler {

   public let label: String

   public var metadata = Logger.Metadata() {
      didSet {
         self.prettyMetadata = prettify(metadata)
      }
   }

   public var logLevel: Logger.Level = .info

   // MARK: -

   private var prettyMetadata: String?

   public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
      get {
         return metadata[metadataKey]
      } set {
         metadata[metadataKey] = newValue
      }
   }

   // MARK: -

   public init(label: String) {
      self.label = label
   }

   public func log(level: Logger.Level, message: Logger.Message, metadata: Logger.Metadata?, source: String, file: String, function: String, line: UInt) {
      var combinedPrettyMetadata = prettyMetadata
      if let metadataOverride = metadata, !metadataOverride.isEmpty {
         combinedPrettyMetadata = prettify(self.metadata.merging(metadataOverride) { return $1 })
      }
      var formedMessage = message.description
      if combinedPrettyMetadata != nil {
         formedMessage += " -- " + combinedPrettyMetadata!
      }
      #if os(Android)
      // ANDROID_LOG_DEBUG
      _ = formedMessage.withCString {
         __android_log_print_1($0)
      }
      #else
      print(formedMessage)
      #endif
   }
}

extension AndroidLogHandler {

   private func prettify(_ metadata: Logger.Metadata) -> String? {
      if metadata.isEmpty {
         return nil
      }
      return metadata.map {
         "\($0)=\($1)"
      }.joined(separator: " ")
   }
}

public struct AndroidLogger {

   @discardableResult
   public static func info(_ message: String) -> Int32 {
      #if os(Android)
      return "ANDROID: \(message)".withCString {
         __android_log_print_1($0)
      }
      #else
      print("NOT AN ANDROID: " + message)
      return 0
      #endif
   }
}
