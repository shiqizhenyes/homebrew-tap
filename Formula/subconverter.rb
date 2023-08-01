class Subconverter < Formula
  desc "Utility to convert between various proxy subscription formats"
  homepage "https://github.com/tindy2013/subconverter"
  url "https://github.com/shiqizhenyes/subconverter/releases/download/v0.7.2/subconverter-0.7.2.zip"
  sha256 "1d68f26d8b0610d6fd536722f76302b8ba2ab696fee6093967f9bde5979088f5"
  license "GPL-3.0"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"bin/subconverter"
  end

  def post_install
    mkdir_p "#{var}/cache/subconverter" unless (var/cache/"subconverter").exist?
    mkdir "#{etc}/subconverter" unless (etc/"subconverter").exist?
    # mv libexec/"base" "#{etc}/subconverter/"
    # mv libexec/"config" "#{etc}/subconverter/"
    # mv libexec/"rules" "#{etc}/subconverter/"
    mv libexec/"snippets" "#{etc}/subconverter/"
    # mv libexec/"cache" "#{var}/cache/subconverter/"
  end

  service do
    run [opt_bin/"subconverter", "run"]
  end

end
