class Kepubify < Formula
  desc "Convert ebooks from epub to kepub"
  homepage "https://pgaskin.net/kepubify/"
  url "https://github.com/pgaskin/kepubify/archive/v4.0.1.tar.gz"
  sha256 "30e497e3a8490bcf571d01a7bb6cc2410689fccd7f9a516c31a166460d901aa8"
  license "MIT"
  head "https://github.com/pgaskin/kepubify.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b6cd624dfcd004722ed211e192749443e2ca43117d499eb28929c420589978f5"
    sha256 cellar: :any_skip_relocation, big_sur:       "d7b68d8c1c34a5fe214b38c88eb5a18c11bff5698026e57d440f6f77c8f29297"
    sha256 cellar: :any_skip_relocation, catalina:      "c8f88fe65e8d02bd957a70630d43fd4007b2c5e8f65c65789353de8b138c765f"
    sha256 cellar: :any_skip_relocation, mojave:        "e2fdeb917185ea975bb51d87f5e50d214d4d4c8d961b16ab3634ba32dc713eb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "330ae960284d9b3c1e91bc0a7469e2af6a338f0f1361953590d4bd69c68071d3" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = HOMEBREW_CACHE/"go_cache"

    %w[
      kepubify
      covergen
      seriesmeta
    ].each do |p|
      system "go", "build", "-o", bin/p,
                   "-ldflags", "-s -w -X main.version=#{version}",
                   "-tags", "zip117",
                   "./cmd/#{p}"
    end
  end

  test do
    pdf = test_fixtures("test.pdf")
    output = shell_output("#{bin}/kepubify #{pdf} 2>&1", 1)
    assert_match "Error: invalid extension", output

    system bin/"kepubify", test_fixtures("test.epub")
    assert_predicate testpath/"test_converted.kepub.epub", :exist?
  end
end
