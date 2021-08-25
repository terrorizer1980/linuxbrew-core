class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.34.9.tar.gz"
  sha256 "6f0b080afeb06cac2db3d9417ff94beb74f2ea0d3e6726cecd780829dbc0f043"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9646e1e23d606d5483fc314b0ded7a9cd7a3961ec84658cbfecda23eaaf9474d"
    sha256 cellar: :any_skip_relocation, big_sur:       "de2ecc8a4d4a22e86b696f1eab9dd50681cdb22880fcdc3244fd7f84674f0eed"
    sha256 cellar: :any_skip_relocation, catalina:      "fb3bc88628b640af816a86bf147d43a027c0ff48eac25869ddd41483a8024d45"
    sha256 cellar: :any_skip_relocation, mojave:        "6c51591365356da961501578e98444e597ba63878e3af90886fb3ffcfccdfc1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "608b2faa5e11d132963a97465089991697742bb80d958f41794fc521b8073f8b" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    ENV["PROJECT_VER"] = version
    system "make", "compile-only"
    on_macos do
      bin.install "bin/darwin/newrelic"
    end
    on_linux do
      bin.install "bin/linux/newrelic"
    end

    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "bash")
    (bash_completion/"newrelic").write output
    output = Utils.safe_popen_read("#{bin}/newrelic", "completion", "--shell", "zsh")
    (zsh_completion/"_newrelic").write output
  end

  test do
    output = shell_output("#{bin}/newrelic config list")

    assert_match "loglevel", output
    assert_match "plugindir", output
    assert_match version.to_s, shell_output("#{bin}/newrelic version 2>&1")
  end
end
