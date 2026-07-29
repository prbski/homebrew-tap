class Lets < Formula
  desc "AI command finder: describe what you want, get a ready-to-run command"
  homepage "https://github.com/prbski/lets-cli"
  version "0.1.0"
  license "MIT"

  on_macos do
    if Hardware::CPU.arm?
      url "https://github.com/prbski/lets-cli/releases/download/v0.1.0/lets-0.1.0-aarch64-apple-darwin.tar.gz"
      sha256 "b417a6ec034f77560c7d8a886151282fae4e35827ad229f7a4f77c064a820e34"
    else
      url "https://github.com/prbski/lets-cli/releases/download/v0.1.0/lets-0.1.0-x86_64-apple-darwin.tar.gz"
      sha256 "db197987da5f637ed62d8fcc84f5c3b2ba77d63ef5622eb621c7329a754ff023"
    end
  end

  on_linux do
    if Hardware::CPU.arm?
      url "https://github.com/prbski/lets-cli/releases/download/v0.1.0/lets-0.1.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "65fe849e31aea631da518e9f382fc3129e7161915f8102aae9150e8bb5186819"
    else
      url "https://github.com/prbski/lets-cli/releases/download/v0.1.0/lets-0.1.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "4931f9ff8a7acb1ccadc6b591c6fcd4ef86fd465c8dc6e1134e3b53437e6245c"
    end
  end

  def install
    bin.install "lets"
    generate_completions_from_executable(bin/"lets", "completion")
    (man1/"lets.1").write Utils.safe_popen_read(bin/"lets", "man")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lets --version")
  end
end
