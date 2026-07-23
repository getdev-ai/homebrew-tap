class Getdev < Formula
  desc "verify, secure, and ship AI-generated code — one binary, runs locally, nothing leaves your machine"
  homepage "https://getdev.ai"
  version "0.1.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.5/getdev-aarch64-apple-darwin.tar.xz"
      sha256 "2be3a782fd2c66dbf5076a564681a8fd8426c5786b17f5cc16f91f1b5ebea099"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.5/getdev-x86_64-apple-darwin.tar.xz"
      sha256 "0678ac6f4ff5cf595b1b724fab2b757cdd0a8e7b3ce2ee0fb14889bc9a42e2fb"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.5/getdev-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "34124f8dafd311c1ba9aacd1dbccbef67972d61d351ec753cbb85415c40b968f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.5/getdev-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c3ebf502cfb38c051574437e4d007f7d14e943d31606e38812780d2ab0af1955"
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
