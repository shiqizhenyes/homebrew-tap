class Spotifyd < Formula
  version "v0.2.24"
  desc "A spotify daemon"
  homepage "https://github.com/Spotifyd/spotifyd"

  bottle :unneeded

  if OS.mac?
    url "https://github.com/Spotifyd/spotifyd/releases/download/#{version}/spotifyd-macos-full.tar.gz"
    sha256 "93b0d8e5d5ea4549fbdf5ec468a790ca28609cff876f2d09251e46a9ae323afa"
  elsif OS.linux?
    url "https://github.com/Spotifyd/spotifyd/releases/download/#{version}/spotifyd-linux-full.tar.gz"
    sha256 "a3d01b7d74e49fa5c67946b9648f5b9c44de8290196b1858667503d8d53aa9e5"
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
