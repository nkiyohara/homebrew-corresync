class Corresync < Formula
  desc "Local-first guarded mail and calendar CLI and MCP server"
  homepage "https://github.com/nkiyohara/corresync"
  url "https://github.com/nkiyohara/corresync/releases/download/v0.10.0/corresync_0.10.0_source.tar.gz"
  sha256 "4182e6e4aa2d92e62c2b091e2ec3a74acb9d0730753a055df83169b8c328a790"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X github.com/nkiyohara/corresync/internal/buildinfo.version=#{version}
      -X github.com/nkiyohara/corresync/internal/buildinfo.commit=12cd15f7dd88ca37adb633f33a14b6dde8523222
      -X github.com/nkiyohara/corresync/internal/buildinfo.buildDate=2026-11-25T15:09:55.10206Z
    ]
    system "go", "build", "-mod=vendor",
           *std_go_args(output: bin/"corr", ldflags: ldflags.join(" ")),
           "./cmd/corr"
    bin.install_symlink "corr" => "corresync"

    man1.install "manpages/corr.1"
    bash_completion.install "completions/corr.bash" => "corr"
    zsh_completion.install "completions/_corr"
    fish_completion.install "completions/corr.fish"
    pkgshare.install "plugins"
    (pkgshare/".agents").install ".agents/plugins"
    (pkgshare/".claude-plugin").install ".claude-plugin/marketplace.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/corr version --json")
    assert_match version.to_s, shell_output("#{bin}/corresync version --json")
  end
end
