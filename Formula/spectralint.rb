class Spectralint < Formula
  desc "Static analysis for AI agent instruction files"
  homepage "https://github.com/by-all-means/spectralint"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.3.0/spectralint-aarch64-apple-darwin.tar.xz"
      sha256 "5a497f8bde7c855d6d9a513eb4f57991a69b421964987502478bf9d2cd61fe9c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.3.0/spectralint-x86_64-apple-darwin.tar.xz"
      sha256 "8c37d18f2d4e02aad072765cd166530debd414646c957ae863292ea146b39a21"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.3.0/spectralint-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "56565ea2b2b6eaa7c0946605b4daacbd5d2c78ac95ab7657e8b59106cb276e11"
    end
    if Hardware::CPU.intel?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.3.0/spectralint-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "31f5e0d7d0d564c915205cf077a6634bfd84acbb437a8d0cb68fba05fe3d24ec"
    end
  end
  license "MIT"

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
    bin.install "spectralint" if OS.mac? && Hardware::CPU.arm?
    bin.install "spectralint" if OS.mac? && Hardware::CPU.intel?
    bin.install "spectralint" if OS.linux? && Hardware::CPU.arm?
    bin.install "spectralint" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
