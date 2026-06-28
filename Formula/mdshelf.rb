class Mdshelf < Formula
  desc "A Rust web server that serves folders of markdown files as websites."
  homepage "https://github.com/prbski/mdshelf"
  version "1.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.0.4/mdshelf-aarch64-apple-darwin.tar.xz"
      sha256 "554033ea1b3eb01ba670c4079bc5713215bcc5899a7b2b64ba78b0d7da5d9fcd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.0.4/mdshelf-x86_64-apple-darwin.tar.xz"
      sha256 "4b8389c3460ec433682a472b928546819c71b196cd0a66be7c4ca5f736b72e2f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.0.4/mdshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "b2cc178c4206e2605944e4f4834f3f9b0f2cd877ca36ea23430ff849ebdd8795"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.0.4/mdshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "96e8ba225ae80160a2ea95bf967e2af147622c89647bf2c7017c6f53843ca877"
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
