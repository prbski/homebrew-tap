class Mdshelf < Formula
  desc "A Rust web server that serves folders of markdown files as websites."
  homepage "https://github.com/prbski/mdshelf"
  version "1.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.0/mdshelf-aarch64-apple-darwin.tar.xz"
      sha256 "99c0553be365ec9f88e0ffae9435771cb4a41020c4a8670264e2c44253840617"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.0/mdshelf-x86_64-apple-darwin.tar.xz"
      sha256 "2b8d91e1249c9934286012d0854f900e9bb93012a9550dd422a1e79001f2856d"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.0/mdshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3ee366d089ba311bc8829c8b47cd6acf775f99cffc82fc4e7ee504067d740d07"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.0/mdshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "1107be2e58dca0e52febb8be4e39a76dc306bbf13d7a6fd41c3e603a3340b55c"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "aarch64-unknown-linux-gnu":         {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
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
      bin.install "mdshelf"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "mdshelf"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "mdshelf"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "mdshelf"
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
