class Asroute < Formula
  desc "CLI to interpret traceroute -a output to show AS names traversed"
  homepage "https://github.com/stevenpack/asroute"
  url "https://github.com/stevenpack/asroute/archive/v0.1.0.tar.gz"
  sha256 "dfbf910966cdfacf18ba200b83791628ebd1b5fa89fdfa69b989e0cb05b3ca37"
  license "MIT"
  head "https://github.com/stevenpack/asroute.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "816be1190f677bb1ba13d1b1fd92a0ca7550341810310b59be200227936afc9c"
    sha256 cellar: :any_skip_relocation, big_sur:       "dded44d666d600e065f0a49e0c26eaa56597f1235ff937703c8dff298f665453"
    sha256 cellar: :any_skip_relocation, catalina:      "873d80ef73a84598637218e467a0887477e113a9f26d8dd1f1a4b6a4571b11b8"
    sha256 cellar: :any_skip_relocation, mojave:        "6dbd83956cb0d73b74fd8fa6706206c7d9701eeb6a44f0e6eebcaebd9b96fbc2"
    sha256 cellar: :any_skip_relocation, high_sierra:   "77fd60fff4aa4abf7e9fd7bb7e14961b3eaab1aae0f074a318d874ecd869d32b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "af4bd6a174d6e746ef65f56362c0c819766f773c0866e7ac0fadd9b457eab0da" # linuxbrew-core
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    bin.install "target/release/asroute"
  end

  test do
    system "echo '[AS13335]' | asroute"
  end
end
