class GoJsonnet < Formula
  desc "Go implemention of configuration language for defining JSON data"
  homepage "https://jsonnet.org/"
  url "https://github.com/google/go-jsonnet/archive/v0.16.0.tar.gz"
  sha256 "8ca930c892d34a119c1970431d159000321fe323734f06a1253bd78fc3625b84"
  license "Apache-2.0"
  head "https://github.com/google/go-jsonnet.git"

  bottle do
    root_url "https://github.com/darthferretus/homebrew-bizone/releases/download/go-jsonnet-0.16.0"
    cellar :any_skip_relocation
    sha256 "1d146473d420a900f38111deaa35215d311758a4e3a1dba7ccf19ce851064a51" => :catalina
    sha256 "63a475dd647f617404a8c72fa6de904aa3efd37ab991936e33f7463063b62492" => :x86_64_linux
  end

  depends_on "go" => :build

  conflicts_with "jsonnet", because: "both install binaries with the same name"

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
