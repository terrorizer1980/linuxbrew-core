class Byteman < Formula
  desc "Java bytecode manipulation tool for testing, monitoring and tracing"
  homepage "https://byteman.jboss.org/"
  url "https://downloads.jboss.org/byteman/4.0.16/byteman-download-4.0.16-bin.zip"
  sha256 "4d3a25d7cbe1432be3689854775e692e18f539d8d75328c4e1ad8cf33989c80b"
  license "LGPL-2.1-or-later"
  head "https://github.com/bytemanproject/byteman", branch: "main"

  livecheck do
    url "https://byteman.jboss.org/downloads.html"
    regex(/href=.*?byteman-download[._-]v?(\d+(?:\.\d+)+)-bin\.zip/i)
  end

  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]
    doc.install Dir["docs/*"], "README"
    libexec.install ["bin", "lib", "contrib"]
    pkgshare.install ["sample"]

    env = { JAVA_HOME: "${JAVA_HOME:-#{Formula["openjdk"].opt_prefix}}", BYTEMAN_HOME: libexec }
    Pathname.glob("#{libexec}/bin/*") do |file|
      target = bin/File.basename(file, File.extname(file))
      # Drop the .sh from the scripts
      target.write_env_script(libexec/"bin/#{File.basename(file)}", env)
    end
  end

  test do
    (testpath/"src/main/java/BytemanHello.java").write <<~EOS
      class BytemanHello {
        public static void main(String... args) {
          System.out.println("Hello, Brew!");
        }
      }
    EOS

    (testpath/"brew.btm").write <<~EOS
      RULE trace main entry
      CLASS BytemanHello
      METHOD main
      AT ENTRY
      IF true
      DO traceln("Entering main")
      ENDRULE

      RULE trace main exit
      CLASS BytemanHello
      METHOD main
      AT EXIT
      IF true
      DO traceln("Exiting main")
      ENDRULE
    EOS

    system "#{Formula["openjdk"].bin}/javac", "src/main/java/BytemanHello.java"

    actual = shell_output("#{bin}/bmjava -l brew.btm -cp src/main/java BytemanHello")
    assert_match("Hello, Brew!", actual)
  end
end
