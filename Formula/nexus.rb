class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.org/"
  url "https://github.com/shiqizhenyes/nexus/releases/download/v3.34.0-01/nexus-3.34.0-01.zip"
  sha256 "853524cc14e71916270e22ec1bff6f0f7e8b15034d1665d3b5b010b7e40dd78e"
  license "EPL-1.0"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"bin/nexus"
    ENV["JAVA_HOME"] = libexec/".install4j/jre.bundle/Contents/Home/jre"
    bin.env_script_all_files libexec/"bin", :JAVA_HOME => ENV["JAVA_HOME"]
  end

  def post_install
    system "pwd"
    system "unzip", "-o", "-d", "libexec/install4j.zip", "libexec"
    mkdir_p "#{var}/log/nexus" unless (var/"log/nexus").exist?
    mkdir_p "#{var}/nexus" unless (var/"nexus").exist?
    mkdir "#{etc}/nexus" unless (etc/"nexus").exist?
  end

  service do
    run [opt_bin/"nexus", "start"]
  end

  # test do
  #   mkdir "data"
  #   fork do
  #     ENV["NEXUS_KARAF_DATA"] = testpath/"data"
  #     exec "#{bin}/nexus", "server"
  #   end
  #   sleep 100
  #   assert_match "<title>Nexus Repository Manager</title>", shell_output("curl --silent --fail http://localhost:8081")
  # end
end
