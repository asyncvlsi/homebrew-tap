class ActLang < Formula
  desc "ACT hardware description language for asynchronous logic"
  homepage "https://avlsi.csl.yale.edu/act/doku.php"
  license "GPL-2.0-or-later"
  head "https://github.com/asyncvlsi/act.git", branch: "master"

  depends_on "llvm" => :build
  depends_on "libedit"

  uses_from_macos "m4" => :build
  uses_from_macos "zlib"

  conflicts_with "asyncvlsi/tap/actflow", because: "both install act"

  resource "stdlib" do
    url "https://github.com/asyncvlsi/stdlib.git", branch: "main"
  end

  def install
    ENV.deparallelize

    ENV["ACT_HOME"] = prefix
    ENV["VLSI_TOOLS_SRC"] = buildpath
    ENV["CXX"] = Formula["llvm"].opt_bin/"clang++"

    system "./configure", prefix
    system "./build"
    system "make", "install"

    resource("stdlib").stage do
      system "make", "install"
    end
  end

  def caveats
    <<~EOS
      Add the following to your shell profile e.g. ~/.profile or ~/.zshrc:
        export ACT_HOME=#{opt_prefix}
    EOS
  end

  test do
    ENV["ACT_HOME"] = opt_prefix

    (testpath/"test.act").write <<~ACT
      import std;
      import globals;
      open std::channel;

      defproc inv(bool? in; bool! out; e1of2? L) {
        bool l;
        e1of2 R;
        prs {
          Reset -> out+
          Reset -> l-
          in => out-
          ~l & ~in -> R.e-
          L.t & l -> R.t+
        }
      }
    ACT

    (testpath/"test.cc").write <<~CPP
      #include <act/act.h>
      #include <act/passes.h>

      int main (int argc, char **argv) {
        Act::Init (&argc, &argv);

        Act *a = new Act(argv[1]);
        a->Expand();

        Process *p = a->findProcess(argv[2]);
        if (!p) {
          fatal_error("Could not find process: %s", argv[2]);
        }
        if (!p->isExpanded()) {
          p = p->Expand(ActNamespace::Global(), p->CurScope(), 0, NULL);
        }

        ActStatePass *ap = new ActStatePass (a);
        ap->run(p);
        ap->Print(stdout, p);

        delete ap;
        delete a;
        return 0;
      }
    CPP

    expected_output = <<~EOS
      --- Process: inv<> ---
         loc-nbools = 3, loc-nvars = 1
         port-nbools = 3, port-chpvars = 1
        ismulti: 0
        all booleans (incl. inst): 3
        all chpvars (incl. inst): 1
      --- End Process: inv<> ---
      Globals: 1 bools
    EOS

    system ENV.cxx, "-std=c++11", "-I#{include}", "-L#{lib}", "-o", "test", "test.cc", "-lact", "-lactpass", "-lvlsilib", "-ldl"
    assert_equal expected_output, shell_output("./test test.act inv")
  end
end
