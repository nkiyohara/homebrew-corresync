class Corresync < Formula
  desc "Local-first guarded mail and calendar CLI and MCP server"
  homepage "https://github.com/nkiyohara/corresync"
  url "https://github.com/nkiyohara/corresync/releases/download/v0.8.0/corresync_0.8.0_source.tar.gz"
  sha256 "56fb8f6eba028c48f04f5ec217a94af822bcd0b3f4f712ce589fcc1592015131"
  license "Apache-2.0"

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w -buildid=
      -X github.com/nkiyohara/corresync/internal/buildinfo.version=#{version}
      -X github.com/nkiyohara/corresync/internal/buildinfo.commit=246338c4c341fd46f16283da3f09f857a17a4f6b
      -X github.com/nkiyohara/corresync/internal/buildinfo.buildDate=2026-07-29T11:01:45.195248166Z
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
