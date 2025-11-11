class PipeAudit < Formula
  desc "Command-line interface for the pipa audit engine"
  homepage "https://github.com/lokryn-suite/pipe-audit-core-cli"
  version "0.2.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.2.1/pipe-audit-aarch64-apple-darwin.tar.xz"
      sha256 "2f18e095fc5a4d071628af23217d32fc641b0724b00b4ab4c9b1a69199eb2ca7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.2.1/pipe-audit-x86_64-apple-darwin.tar.xz"
      sha256 "64260ea5bfe8362981317bdfbd3c7d4b20486371196e06680e356e80a9dd2331"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.2.1/pipe-audit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1b764abda1c4a2c6755379b47bd0cc65f4ba83cb048773bef4585117e05d0880"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.2.1/pipe-audit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2497461fa8f3c0c5d5feca5230904a6a09de77acdb0c13968c72dba39f392524"
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
