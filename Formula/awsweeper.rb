class Awsweeper < Formula
  desc "CLI tool for cleaning your AWS account"
  homepage "https://github.com/jckuester/awsweeper/"
  url "https://github.com/jckuester/awsweeper/archive/v0.11.1.tar.gz"
  sha256 "6bd1db96a1fad22df4c22a0ce95f49f91de14c962b5599b3b9d8a730e287767d"
  license "MPL-2.0"
  head "https://github.com/jckuester/awsweeper.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "0d73492221e06ae265d9e81fc3583dbf286f386beb7a711f0283822e9ba8759f"
    sha256 cellar: :any_skip_relocation, catalina:     "04820fc239d4bd2f470e5bba636969ca8487bdf9ef73208d470a08a733e8bf02"
    sha256 cellar: :any_skip_relocation, mojave:       "6bf1b5e08c686bf2e75f1054385ad598fbefe3ea8048c3d3c9e82193683f097a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "a92d5e179b92901932556b29f587bff4b0eef6cf5f9b65cba4cf40ac38d391f4" # linuxbrew-core
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/jckuester/awsweeper/internal.version=#{version}
      -X github.com/jckuester/awsweeper/internal.date=#{time.strftime("%F")}
    ]

    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
  end

  test do
    (testpath/"filter.yml").write <<~EOS
      aws_autoscaling_group:
      aws_instance:
        - tags:
            Name: foo
    EOS

    assert_match "Error: failed to configure provider (name=aws",
      shell_output("#{bin}/awsweeper --dry-run #{testpath}/filter.yml 2>&1", 1)
  end
end
