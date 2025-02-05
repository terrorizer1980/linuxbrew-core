class GstLibav < Formula
  desc "GStreamer plugins for Libav (a fork of FFmpeg)"
  homepage "https://gstreamer.freedesktop.org/"
  url "https://gstreamer.freedesktop.org/src/gst-libav/gst-libav-1.18.4.tar.xz"
  sha256 "344a463badca216c2cef6ee36f9510c190862bdee48dc4591c0a430df7e8c396"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-libav.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-libav/"
    regex(/href=.*?gst-libav[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "56c5478c06c134d37b87bc02470d60406465ef1ee464540bf1ac8d4fc1d51873"
    sha256 cellar: :any,                 big_sur:       "a2893bd458ce04c3cfca61b0ef0e719eb8826fa05d45d0fed94ef08630d5e008"
    sha256 cellar: :any,                 catalina:      "b089298e3075f69f65253c7144f488f4379a922964acc9a3cc533b4dad7c99e9"
    sha256 cellar: :any,                 mojave:        "e4700197650b63949b5c6d494d3b77e51ba94326f6afe723dd8efdd2744f6ad0"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm" => :build
  depends_on "ffmpeg"
  depends_on "gst-plugins-base"
  depends_on "xz" # For LZMA

  def install
    mkdir "build" do
      system "meson", *std_meson_args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  test do
    system "#{Formula["gstreamer"].opt_bin}/gst-inspect-1.0", "libav"
  end
end
