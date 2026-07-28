class OwaBridge < Formula
  desc "Local-first Outlook Web CLI and MCP server"
  homepage "https://github.com/nkiyohara/owa-bridge"
  url "https://github.com/nkiyohara/owa-bridge/releases/download/v0.6.2/owa-bridge_0.6.2_source.tar.gz"
  sha256 "bb254228f45c6eb40301a1b3e4515927d5c046db80d15c20812e15c633760022"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.version=#{version}
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.commit=a36219ac198d82e3264f48094e05d8363a5e7f2c
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.buildDate=2026-07-28T10:04:15.31872568Z
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
