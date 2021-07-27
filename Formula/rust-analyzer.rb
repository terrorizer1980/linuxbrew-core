class RustAnalyzer < Formula
  desc "Experimental Rust compiler front-end for IDEs"
  homepage "https://rust-analyzer.github.io/"
  url "https://github.com/rust-analyzer/rust-analyzer.git",
       tag:      "2021-07-26",
       revision: "5983d3745ac8490c1c2798fdc963aa9fc803dd03"
  version "2021-07-26"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0bdb824e6ab7ca15b7c70e692a533443d2f4f22de967f2ae10e92541832b1267"
    sha256 cellar: :any_skip_relocation, big_sur:       "f6005b5cc7647c88e17bcc5a428cc38d9172d833730dfa015ca6bead92d0d7c4"
    sha256 cellar: :any_skip_relocation, catalina:      "82274b506260df817ad4dd4cd0cebb8967c2029fa187aa6c119b2c2d71bef7f3"
    sha256 cellar: :any_skip_relocation, mojave:        "189e6409c7d674ccce05289498ed405334170c0cd78135c1bcca98c91e687bde"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e33c127ec8c37779f9822d82f14c7381ba4fa7d72ee65148786d7be5884e34ad"
  end

  depends_on "rust" => :build

  def install
    cd "crates/rust-analyzer" do
      system "cargo", "install", "--bin", "rust-analyzer", *std_cargo_args
    end
  end

  test do
    def rpc(json)
      "Content-Length: #{json.size}\r\n" \
        "\r\n" \
        "#{json}"
    end

    input = rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id":1,
      "method":"initialize",
      "params": {
        "rootUri": "file:/dev/null",
        "capabilities": {}
      }
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"initialized",
      "params": {}
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "id": 1,
      "method":"shutdown",
      "params": null
    }
    EOF

    input += rpc <<-EOF
    {
      "jsonrpc":"2.0",
      "method":"exit",
      "params": {}
    }
    EOF

    output = /Content-Length: \d+\r\n\r\n/

    assert_match output, pipe_output("#{bin}/rust-analyzer", input, 0)
  end
end
