class Jsonnet < Formula
  desc "Domain specific configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/jsonnet/archive/v0.16.0.tar.gz"
  sha256 "fa1a4047942797b7c4ed39718a20d63d1b98725fb5cf563efbc1ecca3375426f"
  license "Apache-2.0"
  head "https://github.com/google/jsonnet.git"

  livecheck do
    url "https://github.com/google/jsonnet/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    root_url "https://github.com/darthferretus/homebrew-bizone/releases/download/jsonnet-0.16.0"
    cellar :any_skip_relocation
    sha256 "6a5d19933091eb3d531fb719a02f4cd1ea70ede12cdde25a7ac2dcad6a7f593a" => :catalina
    sha256 "b4a0fcbc577777ccdeec10c2e736975b1ef81a83b199ab9e6f756832fd9316cf" => :x86_64_linux
  end

  # test

  def install
    ENV.cxx11
    system "make"
    bin.install "jsonnet"
    bin.install "jsonnetfmt"
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
