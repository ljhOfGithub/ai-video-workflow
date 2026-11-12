import AVFoundation
import Foundation
import Vision

struct TextBox: Encodable {
    let text: String
    let confidence: Float
    let left: Double
    let top: Double
    let width: Double
    let height: Double
}

struct Sample: Encodable {
    let requestedSeconds: Double
    let actualSeconds: Double
    let textBoxes: [TextBox]
}

struct Report: Encodable {
    let sampleIntervalSeconds: Double
    let videoEndSeconds: Double
    let languages: [String]
    let samples: [Sample]
}

struct InputError: LocalizedError {
    let message: String
    var errorDescription: String? { message }
}

@main
struct OCRVideo {
    static func main() async {
        do {
            try await run(Array(CommandLine.arguments.dropFirst()))
        } catch {
            FileHandle.standardError.write(Data("OCR 失败：\(error.localizedDescription)\n".utf8))
            exit(EXIT_FAILURE)
        }
    }

    static func run(_ arguments: [String]) async throws {
        guard (2...3).contains(arguments.count) else {
            throw InputError(message: "用法：ocr-video 视频路径 报告.json [语言列表，例如 zh-Hans,en-US]")
        }

        let video = URL(fileURLWithPath: arguments[0]).standardizedFileURL
        let output = URL(fileURLWithPath: arguments[1]).standardizedFileURL
        guard output.pathExtension.lowercased() == "json",
              video.resolvingSymlinksInPath() != output.resolvingSymlinksInPath() else {
            throw InputError(message: "报告需为独立的 JSON 文件。")
        }

        let languages = arguments.count == 3
            ? arguments[2].split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            : ["zh-Hans", "en-US"]
        let recognition = VNRecognizeTextRequest()
        recognition.recognitionLevel = .accurate
        let supported = try recognition.supportedRecognitionLanguages()
        guard !languages.isEmpty, languages.allSatisfy(supported.contains) else {
            throw InputError(message: "语言列表为空或当前系统不支持：\(languages.joined(separator: ", "))")
        }
        recognition.recognitionLanguages = languages

        let asset = AVURLAsset(url: video)
        guard let track = try await asset.loadTracks(withMediaType: .video).first else {
            throw InputError(message: "输入没有可读取的视频轨道。")
        }
        let timeRange = try await track.load(.timeRange)
        let end = CMTimeRangeGetEnd(timeRange)
        guard end.seconds.isFinite, end.seconds > 0 else {
            throw InputError(message: "视频轨道时长无效。")
        }

        let generator = AVAssetImageGenerator(asset: asset)
        generator.appliesPreferredTrackTransform = true
        generator.requestedTimeToleranceBefore = .zero
        generator.requestedTimeToleranceAfter = .zero

        var samples: [Sample] = []
        var halfSeconds: Int64 = 0
        while true {
            let requested = CMTime(value: halfSeconds, timescale: 2)
            guard CMTimeCompare(requested, end) < 0 else { break }
            do {
                let frame = try await generator.image(at: requested)
                let handler = VNImageRequestHandler(cgImage: frame.image)
                try handler.perform([recognition])
                let boxes = (recognition.results ?? []).compactMap { observation -> TextBox? in
                    guard let candidate = observation.topCandidates(1).first else { return nil }
                    let bounds = observation.boundingBox
                    return TextBox(
                        text: candidate.string,
                        confidence: candidate.confidence,
                        left: bounds.minX,
                        top: 1 - bounds.maxY,
                        width: bounds.width,
                        height: bounds.height
                    )
                }
                samples.append(Sample(
                    requestedSeconds: requested.seconds,
                    actualSeconds: frame.actualTime.seconds,
                    textBoxes: boxes
                ))
            } catch {
                throw InputError(message: "\(requested.seconds) 秒：\(error.localizedDescription)")
            }
            halfSeconds += 1
        }

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let report = Report(
            sampleIntervalSeconds: 0.5,
            videoEndSeconds: end.seconds,
            languages: languages,
            samples: samples
        )
        try encoder.encode(report).write(to: output, options: .atomic)
    }
}
