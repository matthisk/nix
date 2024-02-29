{ lib, fetchFromGitHub, jdk17, makeWrapper, maven }:

maven.buildMavenPackage rec {
  pname = "eclipse.jdt.ls";
  version = "1.33.0";

  src = fetchFromGitHub {
    owner = "eclipse-jdtls";
    repo = pname;
    rev = "v${version}";
    sha256 = "028jqyfj5wpw2ar13lcqpqa5km3rdkvrjn36gb9zlqzdkmap4a60";
  };

  mvnHash = "sha256-/a++Tuu6cm17ex+KrRXcEGzuNYixR1xAU9o9vR6BR4E=";

  JAVA_HOME="${jdk17}/zulu-17.jdk/Contents/Home/";

  installPhase = ''
    mv eclipse.jdt.ls/org.eclipse.jdt.ls.product/target/repository/* $out/
  '';

  meta = with lib; {
    description = "Eclipse language server for Java";
    homepage = "https://github.com/eclipse-jdtls/eclipse.jdt.ls";
  };
}
