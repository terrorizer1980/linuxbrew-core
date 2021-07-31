class Phive < Formula
  desc "Phar Installation and Verification Environment (PHIVE)"
  homepage "https://phar.io"
  url "https://github.com/phar-io/phive/releases/download/0.15.0/phive-0.15.0.phar"
  sha256 "72b32bf1de67b15b7bfb3439c4f7a987f257993127ea324556da7798e832941e"
  license "BSD-3-Clause"

  depends_on "php"

  def install
    bin.install "phive-#{version}.phar" => "phive"
  end

  test do
    assert_match "No PHARs configured for this project", shell_output("#{bin}/phive status")
  end
end
