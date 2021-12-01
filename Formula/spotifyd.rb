class Spotifyd < Formula
  version "v0.4.2"
  desc "A spotify daemon"
  homepage "https://github.com/shiqizhenyes/spotifyd"

  bottle :unneeded

  if OS.mac?
    url "https://github.com/shiqizhenyes/spotifyd/releases/download/#{version}/spotifyd-macos-full.tar.gz"
    sha256 "2ce847c69f34453b248fe456733453208c59a2c2042a308410549472412d301f"
  end

  depends_on "dbus"

  def install
    bin.install "spotifyd"
  end

  test do
    system "#{bin}/spotifyd", "--version"
  end
end
