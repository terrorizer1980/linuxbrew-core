class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.13.27.tar.gz"
  sha256 "f23532d099311281b684ace68511c20e8c50718d806924fa42d20d24a8c64579"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "16e135961241c544a3b5688f3d5547b4b28570ee97e0ea6bb106426f8e3eff72"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ef7fcf7f6371f419ef38a2408cab871db200718d6487b252663896aeafbaad4"
    sha256 cellar: :any_skip_relocation, catalina:      "5ae5580f13a7fd320c699973393b71eb1902710a7d4cd49fd4882640ed90843c"
    sha256 cellar: :any_skip_relocation, mojave:        "e7382c7ee1ffb352fd59f1000ea0a0b4017a20dd11d1524703aeb990586c665e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8ddee159c7cad6292ad6e1a79ca238b1afbe7af40270ebfaa009f1ee3c06dd38" # linuxbrew-core
  end

  depends_on "pandoc" => :build
  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args

    args = %w[
      --standalone
      --to=man
    ]
    system "pandoc", *args, "docs/taskwarrior-tui.1.md", "-o", "taskwarrior-tui.1"
    man1.install "taskwarrior-tui.1"

    bash_completion.install "completions/taskwarrior-tui.bash"
    fish_completion.install "completions/taskwarrior-tui.fish"
    zsh_completion.install "completions/_taskwarrior-tui"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 2)
  end
end
