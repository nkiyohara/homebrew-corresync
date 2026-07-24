class OwaBridge < Formula
  desc "Local-first Outlook Web CLI and MCP server"
  homepage "https://github.com/nkiyohara/owa-bridge"
  url "https://github.com/nkiyohara/owa-bridge/releases/download/v0.5.0/owa-bridge_0.5.0_source.tar.gz"
  sha256 "a0c00bb6b08b6ea0198ece9ca1d8dd16a3eb09973f4c249be179dc8f3529fdcc"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.version=#{version}
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.commit=a0e7e19c8bd464e12dba2602ad6793a1690c1aea
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.buildDate=2026-07-24T12:16:11.672509343Z
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
