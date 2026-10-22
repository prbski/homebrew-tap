class Mdshelf < Formula
  desc "A Rust web server that serves folders of markdown files as websites."
  homepage "https://github.com/prbski/mdshelf"
  version "1.1.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.2/mdshelf-aarch64-apple-darwin.tar.xz"
      sha256 "43a8cd9bee566234f4d2d63d349558ae3fa5365298547c2e0cfc85e8d12ebd3c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.2/mdshelf-x86_64-apple-darwin.tar.xz"
      sha256 "6c9bb18dcafab837194a7a3cd51be9bc5f76e8f9430d1031799325fd5a819b63"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.2/mdshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6b78ec29f0fedb037090cf76001ac25f5457753b44769c8eccc9993d98f3b05e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.2/mdshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a346284430fb9c1f067a1c3aa10f107b457e0ee0da31454c3019290afde6da0f"
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
