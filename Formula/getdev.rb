class Getdev < Formula
  desc "verify, secure, and ship AI-generated code — one binary, runs locally, nothing leaves your machine"
  homepage "https://getdev.ai"
  version "0.1.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.4/getdev-aarch64-apple-darwin.tar.xz"
      sha256 "2ef9b35f59a9fa7f510665ee1766121533d647e881ff69b1e92890ad2e1db654"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.4/getdev-x86_64-apple-darwin.tar.xz"
      sha256 "0ac3563d9d7a230d9b7412c86b4d94194d6ea86cb8c7316592d0caadd133ff4a"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.4/getdev-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ffa264b2b0616cf429d31a56dd4a379784b2b4d11132b9adda028e27a51bacab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.4/getdev-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "07e35b1ff6db07f50047097ccb137508f739fadc512bedb2a42eea3b60013b83"
    end
  end
  license "Apache-2.0"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "getdev" if OS.mac? && Hardware::CPU.arm?
    bin.install "getdev" if OS.mac? && Hardware::CPU.intel?
    bin.install "getdev" if OS.linux? && Hardware::CPU.arm?
    bin.install "getdev" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
