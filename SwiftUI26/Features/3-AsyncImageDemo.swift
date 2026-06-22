import SwiftUI

/// **AsyncImage Caching** (SDK 27)
///
/// `AsyncImage` now applies standard HTTP caching automatically — scroll an
/// image off-screen and back, and it is served from the cache instead of
/// re-downloaded. Two new entry points add control:
///
/// * `AsyncImage(request:)` takes a `URLRequest`, so you set the cache policy
///   (or any request property) per image.
/// * `.asyncImageURLSession(_:)` supplies a custom `URLSession` whose
///   `URLCache` you size yourself.
struct AsyncImageDemo: View {
    // A custom session with a generously sized cache, shared by every
    // AsyncImage in this screen's subtree.
    private static let imageSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.urlCache = URLCache(
            memoryCapacity: 64 * 1024 * 1024,
            diskCapacity: 256 * 1024 * 1024
        )
        return URLSession(configuration: configuration)
    }()

    private let photos = Photo.sample

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 8),
        count: 2
    )

    var body: some View {
        ScrollView {
            Text("Each image loads through a URLRequest with a "
                 + "\"return cached data else load\" policy.")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal)

            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(photos) { photo in
                    AsyncImage(
                        request: URLRequest(url: photo.url, cachePolicy: .returnCacheDataElseLoad)
                    ) { image in
                        image
                            .resizable()
                            .scaledToFit()
                            .padding(8)
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(height: 140)
                    .frame(maxWidth: .infinity)
                    .background(.quinary, in: RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding()
        }
        .asyncImageURLSession(Self.imageSession)
        .navigationTitle("AsyncImage")
    }
}

struct Photo: Identifiable {
    let id: Int
    var url: URL

    // GitHub's "explore" topic icons — small, stable PNGs, one per topic.
    static let sample: [Photo] = [
        "swift", "javascript", "typescript", "python", "java",
        "kotlin", "ruby", "go", "rust", "php",
        "csharp", "cpp", "scala", "dart", "react",
        "angular", "nodejs", "django", "flutter", "android",
        "docker", "kubernetes", "linux", "git", "graphql",
        "mongodb", "redis", "html", "css"
    ].enumerated().map { index, topic in
        Photo(
            id: index,
            url: URL(string: "https://raw.githubusercontent.com/github/explore/main/topics/\(topic)/\(topic).png")!
        )
    }
}

#Preview {
    NavigationStack { AsyncImageDemo() }
}
