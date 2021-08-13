class Eksctl < Formula
  desc "Simple command-line tool for creating clusters on Amazon EKS"
  homepage "https://eksctl.io"
  url "https://github.com/weaveworks/eksctl.git",
      tag:      "0.61.0",
      revision: "67f0732f631149e01d8c3f8a56340bdad1482548"
  license "Apache-2.0"
  head "https://github.com/weaveworks/eksctl.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ef8c6ea61303b26a7be8821194bbd05571fe69c01a70079e12386ba0c3f4e027"
    sha256 cellar: :any_skip_relocation, big_sur:       "1dd5d5e8b24a4889185691b9f57ecb5205a113cf1eebe14b194c3f087b32de0e"
    sha256 cellar: :any_skip_relocation, catalina:      "b09610d74ced457b57f51870d655006af1af66a2fc548b656df41d10cd562016"
    sha256 cellar: :any_skip_relocation, mojave:        "81f27f2a766f7f1806801897442f978d612e1e60f699d22ac05104ea2c11265f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a594703a8d422977eed80a68f72124cb506bfdf1c6b8f9383203b6a520120b2b" # linuxbrew-core
  end

  depends_on "counterfeiter" => :build
  depends_on "go" => :build
  depends_on "go-bindata" => :build
  depends_on "mockery" => :build
  depends_on "aws-iam-authenticator"

  def install
    ENV["GOBIN"] = HOMEBREW_PREFIX/"bin"
    system "make", "build"
    bin.install "eksctl"

    bash_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "bash")
    (bash_completion/"eksctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "zsh")
    (zsh_completion/"_eksctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/eksctl", "completion", "fish")
    (zsh_completion/"eksctl.fish").write fish_output
  end

  test do
    assert_match "The official CLI for Amazon EKS",
      shell_output("#{bin}/eksctl --help")

    assert_match "Error: couldn't create node group filter from command line options: --cluster must be set",
      shell_output("#{bin}/eksctl create nodegroup 2>&1", 1)
  end
end
