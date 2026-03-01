class Spectralint < Formula
  desc "Static analysis for AI agent instruction files"
  homepage "https://github.com/by-all-means/spectralint"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.2.0/spectralint-aarch64-apple-darwin.tar.xz"
      sha256 "340672e048356fc33d9eb3ac56586160c3e31ed2bfb90cf78176f78e52183d71"
    end
    if Hardware::CPU.intel?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.2.0/spectralint-x86_64-apple-darwin.tar.xz"
      sha256 "6f02fc632d9db568538a1d1d7a33f795a200c93434bfb87d70f57e343ea3832d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.2.0/spectralint-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "86adbffec8212682ed699718b9fb429b5210ab05b7feff9dd100cb8d97491d03"
    end
    if Hardware::CPU.intel?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.2.0/spectralint-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "ed26687877e21016fd962a334d13a2f6d36a5d93127b601b34f3865a5bda8117"
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
