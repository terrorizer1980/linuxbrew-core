class Typedb < Formula
  desc "Distributed hyper-relational database for knowledge engineering"
  homepage "https://vaticle.com/"
  url "https://github.com/vaticle/typedb/releases/download/2.3.2/typedb-all-mac-2.3.2.zip"
  sha256 "92293446fcfc002443f2fc5f2bbfee4f42b08f1016123dcee70be13928b96899"
  license "AGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c45c0019dbef9dafc3e247dc43b452fc5616229bccd5fc0cc4a53a8759206134"
  end

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"typedb"
    bin.env_script_all_files(libexec, Language::Java.java_home_env("11"))
  end

  test do
    assert_match "A STRONGLY-TYPED DATABASE", shell_output("#{bin}/typedb server status")
  end
end
