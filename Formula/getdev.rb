class Getdev < Formula
  desc "verify, secure, and ship AI-generated code — one binary, runs locally, nothing leaves your machine"
  homepage "https://getdev.ai"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.1/getdev-aarch64-apple-darwin.tar.xz"
      sha256 "9e210a8f9bb5e5581088acde8ef9dd1c0fbfd6b1e673773168c9965dd1bb53e5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.1/getdev-x86_64-apple-darwin.tar.xz"
      sha256 "9d131b59126fb7c530e13d00305945ce1c95c1d9940cbdf7fae0decb2e6ecef2"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.1/getdev-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ca3de7ad71cbfcf8126b30f8ba1655f02db090a56eb77f6ab0860443568fce3c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.1/getdev-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "23d0b7a28078e1e96a170c17c283580265ee1cfe9e12c979c36b42cfcbe6dd28"
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
