require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.20.tgz"
  sha256 "f9b329a56c4d48be1cc67395ec79e24a8f9dd4d1ed95ef59689f5a1cb18e251d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fde5b99c1f82700c213cd821997ed372cd52e6e60f0455e23cf6986b80b6819d" # linuxbrew-core
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
