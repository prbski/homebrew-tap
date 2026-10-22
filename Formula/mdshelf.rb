class Mdshelf < Formula
  desc "A Rust web server that serves folders of markdown files as websites."
  homepage "https://github.com/prbski/mdshelf"
  version "1.1.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.3/mdshelf-aarch64-apple-darwin.tar.xz"
      sha256 "ebcb6ff81cb3f4eff94cfc57b8a9d154283f169ba7c8cae5e4f23485297cc0ab"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.3/mdshelf-x86_64-apple-darwin.tar.xz"
      sha256 "6dc54cb6008017a9c58e057bac26a78eed5c8aeaea7663f8eb6f25dc17945026"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.3/mdshelf-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5ef023d341fa632c87757c06c4eb716aae3182d15520ccd09811b4a1d4c420f9"
    end
    if Hardware::CPU.intel?
      url "https://github.com/prbski/mdshelf/releases/download/v1.1.3/mdshelf-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "5bc64b9410c9e73248019db7e16df081a3513c06fa1a74c2fe28c5909769df08"
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
