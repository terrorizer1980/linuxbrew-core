class Nuclei < Formula
  desc "HTTP/DNS scanner configurable via YAML templates"
  homepage "https://nuclei.projectdiscovery.io/"
  url "https://github.com/projectdiscovery/nuclei/archive/v2.5.0.tar.gz"
  sha256 "d321e91a91ecf456353c09f176a9c7c2e85c73b626218fdd4a7ff5b79a36b8e5"
  license "MIT"
  head "https://github.com/projectdiscovery/nuclei.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "141503ef8c0670760fb5f9ef46dc5821e353fc920e32b70d0e5a0f9e68f3c7e0"
    sha256 cellar: :any_skip_relocation, big_sur:       "65c6cac7975a786ed3ebfa8ff2ebad5c53d9dafc4713b878e3e5290cf318078d"
    sha256 cellar: :any_skip_relocation, catalina:      "1636f995b0805125b7d661f68acdc576d1fbacf805edb95b46d948f5e11af31b"
    sha256 cellar: :any_skip_relocation, mojave:        "34caac5f4d2a41738a9ca2bd208c4a3196c1e4d889566e892c5824317dbb12e9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6eef46438eebf69ce81a9c9b6da113d04d47e35c35cb79cdcf6419b68a98bb79" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    cd "v2/cmd/nuclei" do
      system "go", "build", *std_go_args, "main.go"
    end
  end

  test do
    (testpath/"test.yaml").write <<~EOS
      id: homebrew-test

      info:
        name: Homebrew test
        author: bleepnetworks
        severity: INFO
        description: Check DNS functionality

      dns:
        - name: \"{{FQDN}}\"
          type: A
          class: inet
          recursion: true
          retries: 3
          matchers:
            - type: word
              words:
                - \"IN\tA\"
    EOS
    system "nuclei", "-target", "google.com", "-t", "test.yaml"
  end
end
