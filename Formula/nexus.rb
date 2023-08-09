class Nexus < Formula
  desc "Repository manager for binary software components"
  homepage "https://www.sonatype.org/"
  url "https://github.com/shiqizhenyes/nexus/releases/download/3.58.1-02/nexus-3.58.1-02.zip"
  sha256 "d962a6a52b0226dd5c00ce754e48e6d7113f00f6848a58b0aafb03fb20cd4930"
  license "EPL-1.0"

  def install
    libexec.install Dir["*"]
    ENV["JAVA_HOME"] = "/usr/local/opt/openjdk@8/libexec/openjdk.jdk/Contents/Home/"
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
    run [opt_bin/"nexus", "run"]
    process_type :background
    keep_alive true
    run_type :interval
    interval 60
    log_path "#{var}/log/nexus/access.log"
    error_log_path "#{var}/log/nexus/error.log"
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
