class Subconverter < Formula
  desc "Utility to convert between various proxy subscription formats"
  homepage "https://github.com/tindy2013/subconverter"
  url "https://github.com/shiqizhenyes/subconverter/releases/download/v0.7.2/subconverter-0.7.2.zip"
  sha256 "026cd4dbfd5cd9436c8631672c9e4152ecbd823aba2194f87acae983b7a65c57"
  license "GPL-3.0"

  def install
    libexec.install Dir["*"]
    bin.install libexec/"bin/subconverter"
  end

  def post_install
    # mkdir_p "#{var}/cache/subconverter" unless (var/cache/"subconverter").exist?
    # mkdir "#{etc}/subconverter" unless (etc/"subconverter").exist?
    pkgetc.install libexec/"base"
    pkgetc.install libexec/"snippets"
    # mv libexec/"base" "#{etc}/subconverter/"
    # mv libexec/"config" "#{etc}/subconverter/"
    # mv libexec/"rules" "#{etc}/subconverter/"
    # mv libexec/"snippets" "#{etc}/subconverter/"
    # mv libexec/"cache" "#{var}/cache/subconverter/"
  end

  service do
    run [opt_bin/"subconverter", "run"]
  end

end
