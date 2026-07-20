class OwaBridge < Formula
  desc "Local-first Outlook Web CLI and MCP server"
  homepage "https://github.com/nkiyohara/owa-bridge"
  url "https://github.com/nkiyohara/owa-bridge/releases/download/v0.3.2/owa-bridge_0.3.2_source.tar.gz"
  sha256 "b26142f153cdf89fa11fe148eb0604e00b5ac5f44c99f571dd72529a1800f779"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.version=#{version}
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.commit=ce23a87e95403fab4117ca7e3a674a0f300fb51e
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.buildDate=2026-07-20T12:23:26.639722835Z
    ]
    system "go", "build", "-mod=vendor",
           *std_go_args(output: bin/"owa", ldflags: ldflags.join(" ")),
           "./cmd/owa"

    man1.install "manpages/owa.1"
    bash_completion.install "completions/owa.bash" => "owa"
    zsh_completion.install "completions/_owa"
    fish_completion.install "completions/owa.fish"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/owa version --json")
  end
end
