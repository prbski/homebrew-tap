class Mdserve < Formula
  desc "A Rust web server that serves folders of markdown files as websites."
  homepage "https://github.com/prbski/mdserve"
  version "0.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.2/mdserve-aarch64-apple-darwin.tar.xz"
      sha256 "f02b4138a5d52d4fafa9869a3e3d24a72c91329455f83a8f830110e5f7ddb105"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.2/mdserve-x86_64-apple-darwin.tar.xz"
      sha256 "60e00564cc2604b3e19349aea84f7821d62f38d5c1b1ca0ae04167e63f6bed07"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.2/mdserve-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6045af52ef5a2377961d7c8ed28d669085c931f11a7cf9d4a2a55f893a6ac977"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.2/mdserve-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "50bc4f5c5fe6e5d252e8ea8d435d1eb713df5f2b96ed76f7f6f6a0e4b5a6dde4"
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
