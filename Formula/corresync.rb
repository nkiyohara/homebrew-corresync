class Corresync < Formula
  desc "Local-first guarded mail and calendar CLI and MCP server"
  homepage "https://github.com/nkiyohara/corresync"
  url "https://github.com/nkiyohara/corresync/releases/download/v0.9.2/corresync_0.9.2_source.tar.gz"
  sha256 "92af7f82868c9c06d4aad98ea2d90eb0e74407cc8e9ff34ddba7907ba95fabdb"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X github.com/nkiyohara/corresync/internal/buildinfo.version=#{version}
      -X github.com/nkiyohara/corresync/internal/buildinfo.commit=470e97ceaddf3d458e915aaa0327ebe90ef1989c
      -X github.com/nkiyohara/corresync/internal/buildinfo.buildDate=2026-10-22T15:36:52.049393Z
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
