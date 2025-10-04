class PipeAudit < Formula
  desc "Command-line interface for the pipa audit engine"
  homepage "https://github.com/lokryn-suite/pipe-audit-core-cli"
  version "0.1.8"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.8/pipe-audit-aarch64-apple-darwin.tar.xz"
      sha256 "3353574abf289b2c9529b9a7b6c74897314ca5222de4415ca62692c3da47f488"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.8/pipe-audit-x86_64-apple-darwin.tar.xz"
      sha256 "2f09599916cdcb3231f586f3045c4ea46bf4d326e58532c4e3e879c0cdd56e17"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.8/pipe-audit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5fc45fae7f07569156d408c884f7f43fcc4a68b0c871e7f1a793681222cb3833"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.8/pipe-audit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "84e7a93b9ab3ddbf9029dd66d12e1ade30a02a4c42ad6d78aebdc364ac412020"
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
