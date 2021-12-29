class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.org/"
  url "https://github.com/shiqizhenyes/nexus/releases/download/v3.34.0-01/nexus-3.34.0-01.zip"
  sha256 "3717b57b676d797194f9c66b595972d4bad27c7ce898dc0617970497f8ad5c40"
  license "EPL-1.0"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"bin/nexus"
    ENV["JAVA_HOME"] = libexec/".install4j/jre.bundle/Contents/Home/jre"
    bin.env_script_all_files libexec/"bin", :JAVA_HOME => ENV["JAVA_HOME"]
  end

  def post_install
    system "unzip", "-o", "-d", libexec, libexec/"install4j.zip"
    rm_f libexec/"install4j.zip"
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
