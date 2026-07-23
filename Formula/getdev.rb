class Getdev < Formula
  desc "verify, secure, and ship AI-generated code — one binary, runs locally, nothing leaves your machine"
  homepage "https://getdev.ai"
  version "0.1.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.6/getdev-aarch64-apple-darwin.tar.xz"
      sha256 "9307c7a1b3583e4a71893a97392432088d8082b375563768fcb67cb5d74bed20"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.6/getdev-x86_64-apple-darwin.tar.xz"
      sha256 "402f830e1756a967a13e831a00552fb19684e9f2fe1e7fc488bf6990ca4432ee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.6/getdev-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d7eeb24370546189e0278da6718a58b63997068a98e2dd4bec6fc2d191ccbc8a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.6/getdev-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a358c84b51dcbfd62b6f487ef9ae39a119e035715d6a5b9a78672e7b696c09b6"
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
