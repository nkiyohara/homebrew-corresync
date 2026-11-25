class Corresync < Formula
  desc "Local-first guarded mail and calendar CLI and MCP server"
  homepage "https://github.com/nkiyohara/corresync"
  url "https://github.com/nkiyohara/corresync/releases/download/v0.9.5/corresync_0.9.5_source.tar.gz"
  sha256 "c8d545ddf32241b10ae4d66f7ad7e42542a81df7437289a46bbfc0cb6ef0b950"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X github.com/nkiyohara/corresync/internal/buildinfo.version=#{version}
      -X github.com/nkiyohara/corresync/internal/buildinfo.commit=e63b7f0be19e2aa053af4a7206b911886ad4fc6c
      -X github.com/nkiyohara/corresync/internal/buildinfo.buildDate=2026-11-25T12:24:59.735797Z
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
