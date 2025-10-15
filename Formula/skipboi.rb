class Skipboi < Formula
  desc "Simple macOS CLI for controlling Apple Music"
  homepage "https://github.com/IanKnighton/skipboi"
  url "https://github.com/IanKnighton/skipboi/archive/refs/tags/v1.0.0.tar.gz"
  sha256 "" # Will be updated by CI
  license "MIT"

  depends_on :macos => :catalina
  depends_on xcode: ["14.0", :build]

  def install
    system "swift", "build", "-c", "release", "--disable-sandbox"
    bin.install ".build/release/skipboi"
  end

  test do
    # Since skipboi requires Apple Music, we just test help command
    assert_match "skipboi - A simple macOS CLI for controlling Apple Music", shell_output("#{bin}/skipboi help")
  end
end
