class Ksync < Formula
  desc "Sync files between your local system and a kubernetes cluster"
  homepage "https://ksync.github.io/ksync/"
  url "https://github.com/ksync/ksync.git",
      tag:      "0.4.7-hotfix",
      revision: "14ec9e24670b90ee45d4571984e58d3bff02c50e"
  license "Apache-2.0"
  head "https://github.com/ksync/ksync.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4fe9c12efd8e73fd794edecca04b0270e4dc2229adad3953f25635c3432fc313"
    sha256 cellar: :any_skip_relocation, big_sur:       "0e497912738482d6fa2d1161c6a26b62a781b25ba4280f7ac8e2487b757cda9d"
    sha256 cellar: :any_skip_relocation, catalina:      "ccee0b1bd4f7d3af674d1c2901965e7140b4408a794a781fc8e7640276936f98"
    sha256 cellar: :any_skip_relocation, mojave:        "6128a2e80da17e718001cd9a9a240d27b4dcac7a3e893b2e00316b886c04a3d3"
  end

  depends_on "go" => :build

  # Support go 1.17, remove after next release
  # Patch is equivalent to https://github.com/ksync/ksync/pull/544,
  # but does not apply cleanly
  patch :DATA

  def install
    project = "github.com/ksync/ksync"
    ldflags = %W[
      -w
      -X #{project}/pkg/ksync.GitCommit=#{Utils.git_short_head}
      -X #{project}/pkg/ksync.GitTag=#{version}
      -X #{project}/pkg/ksync.BuildDate=#{time.rfc3339(9)}
      -X #{project}/pkg/ksync.VersionString=#{tap.user}
      -X #{project}/pkg/ksync.GoVersion=go#{Formula["go"].version}
    ].join(" ")
    system "go", "build", *std_go_args(ldflags: ldflags), "#{project}/cmd/ksync"
  end

  test do
    # Basic build test. Potential for more sophisticated tests in the future
    # Initialize the local client and see if it completes successfully
    expected = "level=fatal"
    assert_match expected.to_s, shell_output("#{bin}/ksync init --local --log-level debug", 1)
  end
end
