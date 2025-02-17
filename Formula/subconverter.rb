class Subconverter < Formula
  desc "Utility to convert between various proxy subscription formats"
  homepage "https://github.com/tindy2013/subconverter"
  url "https://github.com/shiqizhenyes/subconverter/releases/download/v0.8.1/subconverter-0.8.1.tar.gz"
  sha256 "e978a967828c41c0e445f749ea7befb77dd27f10afa9ff774ede740f43f7d871"
  license "GPL-3.0"

  def install
    libexec.install Dir["*"]
    # bin.install libexec/"bin/subconverter"
    bin.write_exec_script (libexec/"subconverter")
  end

  def post_install
    # mkdir_p "#{var}/cache/subconverter" unless (var/cache/"subconverter").exist?
    # mkdir "#{etc}/subconverter" unless (etc/"subconverter").exist?
    # pkgetc.install libexec/"base"
    # pkgetc.install libexec/"snippets"
    mkdir_p "#{var}/log/subconverter" unless (var/"log/subconverter").exist?
    # mv libexec/"base" "#{etc}/subconverter/"
    # mv libexec/"config" "#{etc}/subconverter/"
    # mv libexec/"rules" "#{etc}/subconverter/"
    # mv libexec/"snippets" "#{etc}/subconverter/"
    # mv libexec/"cache" "#{var}/cache/subconverter/"
  end

  service do
    run [opt_bin/"subconverter", "run"]
    process_type :background
    keep_alive true
    run_type :interval
    interval 60
    log_path "#{var}/log/subconverter/access.log"
    error_log_path "#{var}/log/subconverter/error.log"
  end

end
