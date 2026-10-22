class Mdshelf < Formula
  desc "A Rust web server that serves folders of markdown files as websites."
  homepage "https://github.com/prbski/mdshelf"
  version "1.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.1/mdshelf-aarch64-apple-darwin.tar.xz"
      sha256 "0317ab583b01f986bcf837c86671d1fa5a102b155bd1c5d9b91e8a49a86f8845"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.1/mdshelf-x86_64-apple-darwin.tar.xz"
      sha256 "762e167b04ac412949c45f94b80a3a70d0cf17ae8f7a4c59083c57b3f3a2b934"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.1/mdshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "65a2901518926407c23532c34a5c2690d516f89131f0caaf6afe80a61328a87b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.1/mdshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a9b9eb3cc956faa37a169e80126881be5498f77e01f93ddc0d29508feb80fec9"
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
