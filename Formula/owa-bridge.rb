class OwaBridge < Formula
  desc "Local-first Outlook Web CLI and MCP server"
  homepage "https://github.com/nkiyohara/owa-bridge"
  url "https://github.com/nkiyohara/owa-bridge/releases/download/v0.3.1/owa-bridge_0.3.1_source.tar.gz"
  sha256 "156c51cf0169b99621894a13a8e3c6a081cb8ca0727f96d00a95da9b8a57db6e"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.version=#{version}
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.commit=2eb65385d70a66dad62a22ea2407a607dd60845d
      -X github.com/nkiyohara/owa-bridge/internal/buildinfo.buildDate=2026-07-20T12:01:52.264513177Z
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
