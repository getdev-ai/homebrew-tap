class Getdev < Formula
  desc "verify, secure, and ship AI-generated code — one binary, runs locally, nothing leaves your machine"
  homepage "https://getdev.ai"
  version "0.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.2/getdev-aarch64-apple-darwin.tar.xz"
      sha256 "c7fab5d8eace3c73bc2b05f122ef392534ebaba716018543520f67cfb43efa0d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.2/getdev-x86_64-apple-darwin.tar.xz"
      sha256 "d01fdcdd92ca4c6d4b3e57c497f835c16eeddc811e790b2f02df24e80a372def"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.2/getdev-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ec3292ab711b6aebcbffd8ddcc4675b279f7e1aa6556a991cc5b544163ef9727"
    end
    if Hardware::CPU.intel?
      url "https://github.com/getdev-ai/cli/releases/download/v0.1.2/getdev-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "993b5e7defec5cad7e4ab94204f99e96629619db945acbc335139bb42c9a87f5"
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
