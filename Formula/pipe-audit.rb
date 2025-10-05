class PipeAudit < Formula
  desc "Command-line interface for the pipa audit engine"
  homepage "https://github.com/lokryn-suite/pipe-audit-core-cli"
  version "0.1.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.10/pipe-audit-aarch64-apple-darwin.tar.xz"
      sha256 "140d3898c0be3c1b408436fc0d263254d860ea73bba2630b8f484bba502d6981"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.10/pipe-audit-x86_64-apple-darwin.tar.xz"
      sha256 "a0eaeab2ffbf12b9f34f2d2c95528fb12452d59052c6467ac95be3b36184e66b"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.10/pipe-audit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1466ade03cb9cbd16cd373105685232bcbf90086f1c653d26f7692d828cfb1f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.10/pipe-audit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "66186687323112106018d437ac4198cb7d5af3b2cf3bd87d98fb40fa54cac6ca"
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
