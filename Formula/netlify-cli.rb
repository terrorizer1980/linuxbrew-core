require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.8.5.tgz"
  sha256 "eb80c606b83b97a5a693289af81cf8099abcd2de56694cdf74ef9abb40bb6e6a"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4bb5c5cbfc0e1ba7dbe8ccde784e849e3ac45c6fd0bfd1400be292db17eddab5"
    sha256 cellar: :any_skip_relocation, big_sur:       "0982581b5d28735b75597b8d0644d682f7fa0045acd5628cba25e6e7f61a20c4"
    sha256 cellar: :any_skip_relocation, catalina:      "0982581b5d28735b75597b8d0644d682f7fa0045acd5628cba25e6e7f61a20c4"
    sha256 cellar: :any_skip_relocation, mojave:        "0982581b5d28735b75597b8d0644d682f7fa0045acd5628cba25e6e7f61a20c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ab984aa96d9b918414f91e09c03503c20f22b4045ac907cf81cfd4227b92ee72" # linuxbrew-core
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
