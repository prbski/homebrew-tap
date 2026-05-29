class Mdshelf < Formula
  desc "A Rust web server that serves folders of markdown files as websites."
  homepage "https://github.com/prbski/mdshelf"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.0.2/mdshelf-aarch64-apple-darwin.tar.xz"
      sha256 "2d2b787f13365379ba400d9404f05c57694052222fcc07cb01d81cd04b1dd3f0"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.0.2/mdshelf-x86_64-apple-darwin.tar.xz"
      sha256 "a57c8be4eedaa8cdb4360dbf59c21e0f094f73960d4f8aaf6362aebdd0011fea"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.0.2/mdshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "8caf4b544afeeb94b13fe56c65b071ccf00294ac20ed1360515a996d857272e9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.0.2/mdshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e79d9251728a11149d77250f927c85e9982f82a7f154b5e3e07da14d73c2cac2"
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
