class Spectralint < Formula
  desc "Static analysis for AI agent instruction files"
  homepage "https://github.com/by-all-means/spectralint"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.1.0/spectralint-aarch64-apple-darwin.tar.xz"
      sha256 "23b0a2f6ddeff63903a1810bf99a813dad66b316e175015f432953912f7be454"
    end
    if Hardware::CPU.intel?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.1.0/spectralint-x86_64-apple-darwin.tar.xz"
      sha256 "f26c30ce8dc4bf3d62725dc42f0bb760d316c4809ee228e64057051c9a26b5e6"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.1.0/spectralint-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "11c6e47f572decee90de5425cc514d910cd9a81f5ece619b857ad806017e10a6"
    end
    if Hardware::CPU.intel?
      url "https://github.com/by-all-means/spectralint/releases/download/v0.1.0/spectralint-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "7b6bb65d3f7aa51fced6a344f945bd8e7d1f4fd5e2ea1c9965e1c620edff9fc9"
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
