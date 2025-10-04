class PipeAudit < Formula
  desc "Command-line interface for the pipa audit engine"
  homepage "https://github.com/lokryn-suite/pipe-audit-core-cli"
  version "0.1.9"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.9/pipe-audit-aarch64-apple-darwin.tar.xz"
      sha256 "e8c621b3fecaf6ea746cb5cffa33740ebffacfb7e7268d4f8711340f192a431b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.9/pipe-audit-x86_64-apple-darwin.tar.xz"
      sha256 "d825d0cf0dec7960dbde6dd309e42a4c8eeaf9056adaccc7d0952c73bded1d50"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.9/pipe-audit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2c0a80f94ad5f64a557489f4d368eb284d015c3ff1506933ddd964ee5551ce05"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.9/pipe-audit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2a1603801c98a308007b1ab2473fc0e55e23bf046dc973fc5b8b08ad02a28f7c"
    end
  end
  license "GPL-3.0-or-later"

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
    bin.install "pipa" if OS.mac? && Hardware::CPU.arm?
    bin.install "pipa" if OS.mac? && Hardware::CPU.intel?
    bin.install "pipa" if OS.linux? && Hardware::CPU.arm?
    bin.install "pipa" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
