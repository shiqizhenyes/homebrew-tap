class Spotifyd < Formula
  version "v0.3.0"
  desc "A spotify daemon"
  homepage "https://github.com/Spotifyd/spotifyd"

  bottle :unneeded

  if OS.mac?
    url "https://github.com/Spotifyd/spotifyd/releases/download/#{version}/spotifyd-macos-full.tar.gz"
    sha256 "7d0004856618062901117a4f5d24355561b4343b02272e93284bb186d6763a6a"
  elsif OS.linux?
    url "https://github.com/Spotifyd/spotifyd/releases/download/#{version}/spotifyd-linux-full.tar.gz"
    sha256 "f50004ba045050591d07d3efb9f8b7e7e71605744a1fed6bf8a05ba8f7787ea5"
  end

  depends_on "dbus"
  depends_on "portaudio"

  def install
    bin.install "spotifyd"
  end

  test do
    system "#{bin}/spotifyd", "--version"
  end
end
