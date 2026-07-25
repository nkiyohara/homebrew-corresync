class OwaBridge < Formula
  desc "Local-first Outlook Web CLI and MCP server"
  homepage "https://github.com/nkiyohara/owa-bridge"
  url "https://github.com/nkiyohara/owa-bridge/releases/download/v0.6.0/owa-bridge_0.6.0_source.tar.gz"
  sha256 "37b6db3b09861306a6557226af8c1e9882e9bd15f1b18e82224931b7ef8fc99f"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.version=#{version}
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.commit=d19c5a12da03d470416eca3a8072eb9b1fbd2018
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.buildDate=2026-07-25T12:23:00.741101918Z
    ]
    system "go", "build", "-mod=vendor",
           *std_go_args(output: bin/"owa", ldflags: ldflags.join(" ")),
           "./cmd/owa"

    man1.install "manpages/owa.1"
    bash_completion.install "completions/owa.bash" => "owa"
    zsh_completion.install "completions/_owa"
    fish_completion.install "completions/owa.fish"
    pkgshare.install "plugins"
    (pkgshare/".agents").install ".agents/plugins"
    (pkgshare/".claude-plugin").install ".claude-plugin/marketplace.json"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/owa version --json")
  end
end
