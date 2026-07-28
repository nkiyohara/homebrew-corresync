class Corresync < Formula
  desc "Local-first guarded mail and calendar CLI and MCP server"
  homepage "https://github.com/nkiyohara/corresync"
  url "https://github.com/nkiyohara/corresync/releases/download/v0.7.0/corresync_0.7.0_source.tar.gz"
  sha256 "fe813ab846d4caf02f1c0165d5598f938c03082e5b6b5779e71b99a8c9dbf405"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X github.com/nkiyohara/corresync/internal/buildinfo.version=#{version}
      -X github.com/nkiyohara/corresync/internal/buildinfo.commit=2ba289c92e8bf3c567125b59acdde1cb7a499c70
      -X github.com/nkiyohara/corresync/internal/buildinfo.buildDate=2026-07-28T12:16:02.191004721Z
    ]
    system "go", "build", "-mod=vendor",
           *std_go_args(output: bin/"corresync", ldflags: ldflags.join(" ")),
           "./cmd/corresync"

    man1.install "manpages/corresync.1"
    bash_completion.install "completions/corresync.bash" => "corresync"
    zsh_completion.install "completions/_corresync"
    fish_completion.install "completions/corresync.fish"
    pkgshare.install "plugins"
    (pkgshare/".agents").install ".agents/plugins"
    (pkgshare/".claude-plugin").install ".claude-plugin/marketplace.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/corresync version --json")
  end
end
