class GoJsonnetAT0160 < Formula
  desc "Go implemention of configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/go-jsonnet/archive/v0.16.0.tar.gz"
  sha256 "8ca930c892d34a119c1970431d159000321fe323734f06a1253bd78fc3625b84"
  license "Apache-2.0"
  revision 1
  head "https://github.com/google/go-jsonnet.git"

  bottle do
    root_url "https://github.com/darthferretus/homebrew-bizone/releases/download/go-jsonnet@0.16.0-0.16.0_1"
    cellar :any_skip_relocation
    sha256 "d1316710b277cac58b12e5953a9e02c6d72969b6ac3f755962ed3d6036652de5" => :catalina
    sha256 "5f733f804bb06b779defe065570fb6c0ebbb29013df2d12eb74b3e360b58f185" => :x86_64_linux
  end

  keg_only :versioned_formula

  depends_on "go" => :build

  def install
    system "go", "build", "-o", bin/"jsonnet", "./cmd/jsonnet"
    system "go", "build", "-o", bin/"jsonnetfmt", "./cmd/jsonnetfmt"
  end

  test do
    (testpath/"example.jsonnet").write <<~EOS
      {
        person1: {
          name: "Alice",
          welcome: "Hello " + self.name + "!",
        },
        person2: self.person1 { name: "Bob" },
      }
    EOS

    expected_output = {
      "person1" => {
        "name"    => "Alice",
        "welcome" => "Hello Alice!",
      },
      "person2" => {
        "name"    => "Bob",
        "welcome" => "Hello Bob!",
      },
    }

    output = shell_output("#{bin}/jsonnet #{testpath}/example.jsonnet")
    assert_equal expected_output, JSON.parse(output)
  end
end
