class OpenjdkAT8 < Formula
  desc "Development kit for the Java programming language"
  homepage "https://openjdk.java.net/"
  url "https://github.com/shiqizhenyes/openjdk8/releases/download/1.8.0%2B275/openjdk8u275-ga.tar.xz"
  version "1.8.0+275"
  sha256 "6a83e8bd8caebf5dc8989a22925ac5598c9edb2ba8dcfad7472a5ff99a14c0e7"
  license "GPL-2.0-only"

  keg_only :versioned_formula

  depends_on "autoconf" => :build
  depends_on "pkg-config" => :build
  depends_on "freetype"

  on_linux do
    depends_on "alsa-lib"
    depends_on "cups"
    depends_on "fontconfig"
    depends_on "libx11"
    depends_on "libxext"
    depends_on "libxrandr"
    depends_on "libxrender"
    depends_on "libxt"
    depends_on "libxtst"
    depends_on "unzip"
    depends_on "zip"

    ignore_missing_libraries %w[libjvm.so libawt_xawt.so]
  end

  # Oracle doesn't serve JDK 7 downloads anymore, so use Zulu JDK 7 for bootstrapping.
  resource "boot-jdk" do
    on_macos do
      url "https://cdn.azul.com/zulu/bin/zulu7.42.0.13-ca-jdk7.0.282-macosx_x64.tar.gz"
      sha256 "37767a8ec40ff63dd43020365cf6c3e95841213cfe73aaa04ee0cffca779b2e7"
    end
    on_linux do
      url "https://cdn.azul.com/zulu/bin/zulu7.42.0.13-ca-jdk7.0.282-linux_x64.tar.gz"
      sha256 "38ec78e7f41f9130cecce5c8c9963d066f7deee5b3ba4dfcca32e197fd933bf9"
    end
  end

  def install
    _, _, update = version.to_s.rpartition("+")
    java_options = ENV.delete("_JAVA_OPTIONS")

    boot_jdk = buildpath/"boot-jdk"
    resource("boot-jdk").stage(boot_jdk)

    # Work around clashing -I/usr/include and -isystem headers,
    # as superenv already handles this detail for us.
    inreplace "common/autoconf/flags.m4",
              '-isysroot \"$SYSROOT\"', ""
    inreplace "common/autoconf/toolchain.m4",
              '-isysroot \"$SDKPATH\" -iframework\"$SDKPATH/System/Library/Frameworks\"', ""
    inreplace "hotspot/make/bsd/makefiles/saproc.make",
              '-isysroot "$(SDKPATH)" -iframework"$(SDKPATH)/System/Library/Frameworks"', ""

    if OS.mac?
      # Fix macOS version detection. After 10.10 this was changed to a 6 digit number,
      # but this Makefile was written in the era of 4 digit numbers.
      inreplace "hotspot/make/bsd/makefiles/gcc.make" do |s|
        s.gsub! "$(subst .,,$(MACOSX_VERSION_MIN))", ENV["HOMEBREW_MACOS_VERSION_NUMERIC"]
        s.gsub! "MACOSX_VERSION_MIN=10.7.0", "MACOSX_VERSION_MIN=#{MacOS.version}"
      end

      # Fix Xcode 13 detection.
      inreplace "common/autoconf/toolchain.m4",
                "if test \"${XC_VERSION_PARTS[[0]]}\" != \"6\"",
                "if test \"${XC_VERSION_PARTS[[0]]}\" != \"13\""
    end

    if OS.linux?
      # Fix linker errors on brewed GCC
      inreplace "common/autoconf/flags.m4", "-Xlinker -O1", ""
      inreplace "hotspot/make/linux/makefiles/gcc.make", "-Xlinker -O1", ""
    end

    args = %W[
      --with-boot-jdk-jvmargs=#{java_options}
      --with-boot-jdk=#{boot_jdk}
      --with-debug-level=release
      --with-conf-name=release
      --with-jvm-variants=server
      --with-milestone=fcs
      --with-native-debug-symbols=none
      --with-update-version=#{update}
      --with-vendor-bug-url=#{tap.issues_url}
      --with-vendor-name=#{tap.user}
      --with-vendor-url=#{tap.issues_url}
      --with-vendor-vm-bug-url=#{tap.issues_url}
    ]

    if OS.mac?
      args << "--with-toolchain-type=clang"

      # Work around SDK issues with JavaVM framework.
      if MacOS.version <= :catalina
        sdk_path = MacOS::CLT.sdk_path(MacOS.version)
        ENV["SDKPATH"] = ENV["SDKROOT"] = sdk_path
        javavm_framework_path = sdk_path/"System/Library/Frameworks/JavaVM.framework/Frameworks"
        args += %W[--with-extra-cflags=-F#{javavm_framework_path}
                   --with-extra-cxxflags=-F#{javavm_framework_path}
                   --with-extra-ldflags=-F#{javavm_framework_path}]
      end
    else
      args += %W[--with-toolchain-type=gcc
                 --x-includes=#{HOMEBREW_PREFIX}/include
                 --x-libraries=#{HOMEBREW_PREFIX}/lib
                 --with-cups=#{HOMEBREW_PREFIX}
                 --with-fontconfig=#{HOMEBREW_PREFIX}]
    end

    chmod 0755, %w[configure common/autoconf/autogen.sh]

    system "common/autoconf/autogen.sh"
    system "./configure", *args

    ENV["MAKEFLAGS"] = "JOBS=#{ENV.make_jobs}"
    system "make", "bootcycle-images", "CONF=release"

    cd "build/release/images" do
      jdk = libexec

      if OS.mac?
        libexec.install Dir["j2sdk-bundle/*"].first => "openjdk.jdk"
        jdk /= "openjdk.jdk/Contents/Home"
      else
        libexec.install Dir["j2sdk-image/*"]
      end

      bin.install_symlink Dir[jdk/"bin/*"]
      include.install_symlink Dir[jdk/"include/*.h"]
      include.install_symlink Dir[jdk/"include/*/*.h"]
      man1.install_symlink Dir[jdk/"man/man1/*"]
    end
  end

  def caveats
    on_macos do
      <<~EOS
        For the system Java wrappers to find this JDK, symlink it with
          sudo ln -sfn #{opt_libexec}/openjdk.jdk /Library/Java/JavaVirtualMachines/openjdk-8.jdk
      EOS
    end
  end

  test do
    (testpath/"HelloWorld.java").write <<~EOS
      class HelloWorld {
        public static void main(String args[]) {
          System.out.println("Hello, world!");
        }
      }
    EOS

    system bin/"javac", "HelloWorld.java"

    assert_match "Hello, world!", shell_output("#{bin}/java HelloWorld")
  end
end
