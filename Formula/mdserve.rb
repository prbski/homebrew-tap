class Mdserve < Formula
  desc "A Rust web server that serves folders of markdown files as websites."
  homepage "https://github.com/prbski/mdserve"
  version "0.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.4/mdserve-aarch64-apple-darwin.tar.xz"
      sha256 "ec576dba10012d28b73d966fa6c4c925e7bb12ea41777a8261f4cfcad7545f1e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.4/mdserve-x86_64-apple-darwin.tar.xz"
      sha256 "162227fd2d1a1f8bcd71a36be57d76ca90c540c1e1e2bcf63c44c0802a204102"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.4/mdserve-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ea73dca969f73cd9ed7277985b731fa2c3de3acfdff39e9298087da01050344e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdserve/releases/download/v0.0.4/mdserve-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c696043127e8bb5582a818eb7ffe471737eb08b61a0fd47b9daa49395d7279bc"
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
