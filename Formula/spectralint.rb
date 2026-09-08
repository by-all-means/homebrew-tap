class Spectralint < Formula
  desc "Static analysis for AI agent instruction files"
  homepage "https://github.com/by-all-means/spectralint"
  version "0.7.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.7.2/spectralint-aarch64-apple-darwin.tar.xz"
      sha256 "360a5a48b7472c8f60e5e02362300ae466cb1cbaeaba9106904e4b6a7bba7634"
    end
    if Hardware::CPU.intel?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.7.2/spectralint-x86_64-apple-darwin.tar.xz"
      sha256 "b47ea2f1d912c2781373305bca5a9d86620b560677c8879b086da1c4f981b754"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.7.2/spectralint-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d34a024f76c40e20b77f560e843e9690d299d0879f9b32490a4fd148dc1680d5"
    end
    if Hardware::CPU.intel?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.7.2/spectralint-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "91a61f95f3c4322425fbb24689ff7f7b902373426ae45cdf660703e4e3bf38eb"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "spectralint"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "spectralint"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "spectralint"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "spectralint"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
