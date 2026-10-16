class Corresync < Formula
  desc "Local-first guarded mail and calendar CLI and MCP server"
  homepage "https://github.com/nkiyohara/corresync"
  url "https://github.com/nkiyohara/corresync/releases/download/v0.8.7/corresync_0.8.7_source.tar.gz"
  sha256 "1ece413f9dcf2d32716257514aa6b4b3dcfe5448f5f1461e2f6801f8b15382c3"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X github.com/nkiyohara/corresync/internal/buildinfo.version=#{version}
      -X github.com/nkiyohara/corresync/internal/buildinfo.commit=014c97af2fe30a67c7ca654b067f99988b0e8536
      -X github.com/nkiyohara/corresync/internal/buildinfo.buildDate=2026-10-16T00:39:41.659269Z
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
