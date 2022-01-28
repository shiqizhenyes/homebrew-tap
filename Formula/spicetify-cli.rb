class SpicetifyCli < Formula
    version "v2.8.4"
    desc "Commandline tool to customize Spotify client. Supports Windows, MacOS and Linux."
    homepage "https://github.com/shiqizhenyes/spotifyd"
  
    if OS.mac?
      url "https://github.com/shiqizhenyes/spicetify-cli/releases/download/#{version}/spicetify-darwin-amd64.tar.gz"
      sha256 "6be3f1ac9effc2182bcab201e07b38cdb0fe7e7b742c681bfb2c69da32853a38"
    end
  
    def install
      libexec.install Dir["*"]
      bin.install_symlink Dir[libexec/"spicetify"]
    end
  
    test do
      system "#{bin}/spicetify", "--version"
    end
  end