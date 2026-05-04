class Mdshelf < Formula
  desc "A Rust web server that serves folders of markdown files as websites."
  homepage "https://github.com/prbski/mdshelf"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v0.9.0/mdshelf-aarch64-apple-darwin.tar.xz"
      sha256 "7ec8535ee1a6b86804ebc9a83f89539ec29efccca5d0f88b39d66691f15004b0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v0.9.0/mdshelf-x86_64-apple-darwin.tar.xz"
      sha256 "f0b29a1d8cb1ff8d121156691de15e1628b10c41c3f87d8d0e9914ace7fbca69"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v0.9.0/mdshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c2d74663e8d5fbcb87cfb902dc0fb7f605410ab922118aa580c51b73e6d5f958"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v0.9.0/mdshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2d8cad76b8001d59e7b8b7d6a31b465aad32d97c93d8634f20ef516d9a22b031"
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
    bin.install "mdshelf" if OS.mac? && Hardware::CPU.arm?
    bin.install "mdshelf" if OS.mac? && Hardware::CPU.intel?
    bin.install "mdshelf" if OS.linux? && Hardware::CPU.arm?
    bin.install "mdshelf" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
