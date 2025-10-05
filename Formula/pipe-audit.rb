class PipeAudit < Formula
  desc "Command-line interface for the pipa audit engine"
  homepage "https://github.com/lokryn-suite/pipe-audit-core-cli"
  version "0.1.12"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.12/pipe-audit-aarch64-apple-darwin.tar.xz"
      sha256 "4129738dc8732eeb2258083d2e37bce0dc49eea0d8d20f045ab65c9a02dcd4fc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.12/pipe-audit-x86_64-apple-darwin.tar.xz"
      sha256 "00157a05347ad61ff7167fd45c6ad69901f3545c4fa992bb933f2ea6ecae16ee"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.12/pipe-audit-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5cf8e4568e4f7b9b85bf0b1def5f11b83d7384f20e0da7df38d184db2978f732"
    end
    if Hardware::CPU.intel?
      url "https://github.com/lokryn-suite/pipe-audit-core-cli/releases/download/v0.1.12/pipe-audit-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "318aecbfe9323d66c5510aa1341d6692bca5070a36307e7f3b49fa80e8c6bcf3"
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
