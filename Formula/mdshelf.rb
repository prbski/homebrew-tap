class Mdshelf < Formula
  desc "A Rust web server that serves folders of markdown files as websites."
  homepage "https://github.com/prbski/mdshelf"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.0.0/mdshelf-aarch64-apple-darwin.tar.xz"
      sha256 "d07191c87a99b7c0f2080ac65e8108d4c9c0471c167d4bc758d344aeb77c2139"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.0.0/mdshelf-x86_64-apple-darwin.tar.xz"
      sha256 "a7abbe04a941e399ca2e8d37babad61812d6913853916558b4dc8806de2561da"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.0.0/mdshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "e5f3dc47a6b08f0c305c523d30e827e26e33b0ea12f0792713cfca8c3e8ac0da"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.0.0/mdshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c3616533fe6965d92adeb071b957a15415a59af2b47347b72fa9c668def8ee13"
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
