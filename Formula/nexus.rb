class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.org/"
  url "https://github.com/shiqizhenyes/nexus/releases/download/v3.34.0-01/nexus-3.34.0-01.zip"
  sha256 "4604cf0f97a8c43a57e25f8bf65cfb54596414ad77de0ab20f7499b7937f80a9"
  license "EPL-1.0"

  def install
    (bin/"nexus").write_env_script libexec/"bin/nexus"
  end

  def post_install
    mkdir_p "#{var}/log/nexus" unless (var/"log/nexus").exist?
    mkdir_p "#{var}/nexus" unless (var/"nexus").exist?
    mkdir "#{etc}/nexus" unless (etc/"nexus").exist?
    mkdir "#{share}/nexus/sonatype-work" unless (share/"nexus/sonatype-work").exist?
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
