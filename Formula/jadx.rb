class Jadx < Formula
  desc "Dex to Java decompiler"
  homepage "https://github.com/shiqizhenyes/jadx"
  url "https://github.com/shiqizhenyes/jadx/releases/download/v1.3.1/jadx-1.3.1.zip"
  sha256 "9549066794cbebfd3de6167265baa689da4e451006b381140542dd875b35eff9"
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
