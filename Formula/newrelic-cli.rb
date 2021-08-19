class NewrelicCli < Formula
  desc "Command-line interface for New Relic"
  homepage "https://github.com/newrelic/newrelic-cli"
  url "https://github.com/newrelic/newrelic-cli/archive/v0.33.0.tar.gz"
  sha256 "0cf44f27a37a47218ec2850de21001c84fa2f2b5a8fbeb52a08f2d95ce8d21f5"
  license "Apache-2.0"
  head "https://github.com/newrelic/newrelic-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "36fb4409c6b35e0d1f8b7dd02ff6108227ba84e13099f0e87b15aaf0c4e0f332"
    sha256 cellar: :any_skip_relocation, big_sur:       "b4cdbd4eaeae7dd01974aed032d360d3056389f416b95abef91802c248f7ee5f"
    sha256 cellar: :any_skip_relocation, catalina:      "0ae9addca5944050a24aae726b0154599ee1a724cac61e9fc529b8637912baa0"
    sha256 cellar: :any_skip_relocation, mojave:        "3aa9819cda08cb4fd813b96832fb69719a4c3b6e9d15baa941ce5c1aa7b49d47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "eb763f5f7f500667efbc87e24fbe1e990f57a2a7b6474d7a94da565f2521fe35"
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
