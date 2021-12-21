class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/shiqizhenyes/jadx"
  url "https://github.com/shiqizhenyes/jadx/releases/download/v1.2.0/jadx-1.2.0.zip"
  sha256 "d59d8e3960ffae4bbcd750b0385f37e98bd6f4e88c1ab63951370283fa452aef"
  license "Apache-2.0"

  head do
    url "https://github.com/shiqizhenyes/jadx.git"
    depends_on "gradle" => :build
  end

  def install
    if build.head?
      system "gradle", "clean", "dist"
      libexec.install Dir["build/jadx/*"]
    else
      libexec.install Dir["*"]
    end
    bin.install libexec/"bin/jadx"
    bin.install libexec/"bin/jadx-gui"
    bin.env_script_all_files libexec/"bin", Language::Java.overridable_java_home_env
  end

end
