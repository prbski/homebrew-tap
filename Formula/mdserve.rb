class Mdserve < Formula
  desc "A Rust web server that serves folders of markdown files as websites."
  homepage "https://github.com/prbski/mdserve"
  version "0.0.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.3/mdserve-aarch64-apple-darwin.tar.xz"
      sha256 "20c51dc7d3daa79ded7e2f075e5bd62d0e45a72575f9de23e2e063f8f5435c28"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.3/mdserve-x86_64-apple-darwin.tar.xz"
      sha256 "25dff418418ddcdffdcc8017b138b84bbb5367680cbbf1021dd2fd15bda9a013"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.3/mdserve-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "414d55f1d17c2f527301fff7f55b18a7018d8530ea4611c2eed8aa143bf0b01a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.3/mdserve-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "2b0c8bc1e29d2cade80dc7bdbb4a8e75e01ee384cd7ad071124af05543d9ea53"
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
