{ lib
, buildGoModule
, fetchFromGitHub
}:

buildGoModule rec {
  pname = "hyperledger-fabric";
  version = "2.4.6";

  src = fetchFromGitHub {
    owner = "hyperledger";
    repo = "fabric";
    rev = "v${version}";
    sha256 = "sha256-Q0qrDPih3M4YCzjhLFBy51qVvoICwwn1LJf63rYiUUg=";
  };

  vendorSha256 = null;

  postPatch = ''
    # Broken
    rm cmd/peer/main_test.go
  '';

  subPackages = [
    "cmd/configtxgen"
    "cmd/configtxlator"
    "cmd/cryptogen"
    "cmd/discover"
    "cmd/ledgerutil"
    "cmd/orderer"
    "cmd/osnadmin"
    "cmd/peer"
  ];

  ldflags = [
    "-s"
    "-w"
    "-X github.com/hyperledger/fabric/common/metadata.Version=${version}"
    "-X github.com/hyperledger/fabric/common/metadata.CommitSha=${src.rev}"
  ];

  meta = with lib; {
    description = "High-performance, secure, permissioned blockchain network";
    longDescription = ''
      Hyperledger Fabric is an enterprise-grade permissioned distributed ledger
      framework for developing solutions and applications. Its modular and
      versatile design satisfies a broad range of industry use cases. It offers
      a unique approach to consensus that enables performance at scale while
      preserving privacy.
    '';
    homepage = "https://wiki.hyperledger.org/display/fabric";
    license = licenses.asl20;
    maintainers = with maintainers; [ marsam ];
  };
}
