class Mdserve < Formula
  desc "A Rust web server that serves folders of markdown files as websites."
  homepage "https://github.com/prbski/mdserve"
  version "0.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.1/mdserve-aarch64-apple-darwin.tar.xz"
      sha256 "47390cb21f4c0920259eee32a4153c639317d472750d01754a54c9fea8dcc1de"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.1/mdserve-x86_64-apple-darwin.tar.xz"
      sha256 "f8f6de09282174c36191e32eea123023aefa2214a11443e4201f30eea6b65cec"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.1/mdserve-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "67e942a657b3cdc939a0cce6dfbb5aadf7896e8154bb5b0d97a7007194f8fb84"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.1/mdserve-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "01e279c9a7a392861791fdc1314066b0c4a6481e07d942443691d61ed0f75e4c"
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
    bin.install "mdserve" if OS.mac? && Hardware::CPU.arm?
    bin.install "mdserve" if OS.mac? && Hardware::CPU.intel?
    bin.install "mdserve" if OS.linux? && Hardware::CPU.arm?
    bin.install "mdserve" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
