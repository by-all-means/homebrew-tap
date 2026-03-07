class Spectralint < Formula
  desc "Static analysis for AI agent instruction files"
  homepage "https://github.com/by-all-means/spectralint"
  version "0.4.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.4.0/spectralint-aarch64-apple-darwin.tar.xz"
      sha256 "39371c4c739d4a4b0b38b571a96b55cc8aa8768602638f79df10b3747924c725"
    end
    if Hardware::CPU.intel?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.4.0/spectralint-x86_64-apple-darwin.tar.xz"
      sha256 "b0d4d4bf866569aebbab7ef39a718eb1847d3c44894238b228e8524dd63d8ce5"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.4.0/spectralint-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e0d1e39102f31ab25f05447ee6bda7bfacff1806f6a152eb91fad077e664b17e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.4.0/spectralint-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7b8f1533ba4737ff644e35ab93fd263d61af1d20c1dd2176e471fefd430174d2"
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
