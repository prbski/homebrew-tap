class Mdshelf < Formula
  desc "A Rust web server that serves folders of markdown files as websites."
  homepage "https://github.com/prbski/mdshelf"
  version "0.9.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v0.9.1/mdshelf-aarch64-apple-darwin.tar.xz"
      sha256 "191c0e5e155a6b8b54104ed99f18fcffebece23c4d92e5888df2fb241118537e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v0.9.1/mdshelf-x86_64-apple-darwin.tar.xz"
      sha256 "f2406a37123c3a438e715ec0dd92676e1a404c1370b125223fb3356ab0e69f6c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v0.9.1/mdshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "c5aeb162c34f23c12c64caf90078c689816d07f3b96ee4b70c3e0d0a6b72ad4e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v0.9.1/mdshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "577510712e6b6324931ebc8bd0a2aef15b47d7d247dbf38dac7f961c8b537589"
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
