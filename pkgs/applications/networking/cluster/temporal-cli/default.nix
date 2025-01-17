{ lib, fetchFromGitHub, buildGoModule, testers, temporal-cli }:

buildGoModule rec {
  pname = "temporal-cli";
  version = "1.17.0";

  src = fetchFromGitHub {
    owner = "temporalio";
    repo = "tctl";
    rev = "v${version}";
    sha256 = "sha256-XEN4Ntt7yHng1+3E5SlxthEWPXJ+kSx9L1GbW9bV03Y=";
  };

  vendorSha256 = "sha256-9bgovXVj+qddfDSI4DTaNYH4H8Uc4DZqeVYG5TWXTNw=";

  ldflags = [ "-s" "-w" ];

  preCheck = ''
    export HOME=$(mktemp -d)
  '';

  passthru.tests.version = testers.testVersion {
    package = temporal-cli;
    # the app writes a default config file at startup
    command = "HOME=$(mktemp -d) ${meta.mainProgram} --version";
  };

  meta = with lib; {
    description = "Temporal CLI";
    homepage = "https://temporal.io";
    license = licenses.mit;
    maintainers = with maintainers; [ aaronjheng ];
    mainProgram = "tctl";
  };
}
