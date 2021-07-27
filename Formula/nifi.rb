class Nifi < Formula
  desc "Easy to use, powerful, and reliable system to process and distribute data"
  homepage "https://nifi.apache.org"
  url "https://www.apache.org/dyn/closer.lua?path=/nifi/1.14.0/nifi-1.14.0-bin.tar.gz"
  mirror "https://archive.apache.org/dist/nifi/1.14.0/nifi-1.14.0-bin.tar.gz"
  sha256 "858e12bce1da9bef24edbff8d3369f466dd0c48a4f9892d4eb3478f896f3e68b"
  license "Apache-2.0"

  depends_on "openjdk@11"

  def install
    libexec.install Dir["*"]

    (bin/"nifi").write_env_script libexec/"bin/nifi.sh",
                                  Language::Java.overridable_java_home_env("11").merge(NIFI_HOME: libexec)
  end

  test do
    system bin/"nifi", "status"
  end
end
