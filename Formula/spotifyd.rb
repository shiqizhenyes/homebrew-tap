class SpotifyTui < Formula
  version "v0.2.24"
  desc "A spotify daemon"
  homepage "https://github.com/Spotifyd/spotifyd"

  bottle :unneeded

  if OS.mac?
    url "https://github.com/Spotifyd/spotifyd/releases/download/#{version}/spotify-tui-macos.tar.gz"
    sha512 "eb33035860ee9b2974e929f20f5b9c6eb0b2526f717b6ea4cde3dc98c4220f2e8fed8b9bf97eda78e84d1b0c6f340e3ac93ca3a573e9a6cb12a31919828a0b35"
  elsif OS.linux?
    url "https://github.com/Spotifyd/spotifyd/releases/download/#{version}/spotify-tui-linux.tar.gz"
    sha512 "bae35cd544f7d89457209a30532b053160214063b951e02c22cf121c03af1fdf5847dff245650c9a23df9d4113c9fea0d101af3c41ae23ba3c3fa35aaa4b291c"
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
