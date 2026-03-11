class Spectralint < Formula
  desc "Static analysis for AI agent instruction files"
  homepage "https://github.com/by-all-means/spectralint"
  version "0.5.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.5.0/spectralint-aarch64-apple-darwin.tar.xz"
      sha256 "6d88f9e163041ffee342baff15809d1b7219594ffe4e576bf99f434e667b941e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.5.0/spectralint-x86_64-apple-darwin.tar.xz"
      sha256 "8aff6c7c1c0ec407d8c83244c150d60d9d3a5307d314cfdb16daf7b1893e8914"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.5.0/spectralint-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "000dcc82073be79c3465ee7bda037bb1e8c11d8e38de993e11704a9d40176806"
    end
    if Hardware::CPU.intel?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.5.0/spectralint-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a839ca2307d44c14903df66b7e5dad1fe246f3625f1d293bafd4df3736d674a1"
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
