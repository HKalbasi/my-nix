{ rustPlatform
, fetchFromGitHub
, xorg
, libxkbcommon
, ...
}:

rustPlatform.buildRustPackage rec {
  pname = "shmenu";
  name = pname;

  src = fetchFromGitHub {
    owner = "HKalbasi";
    repo = pname;
    rev = "82765cc571e5ed5c3841c479b2578dfb92c39ecd";
    hash = "sha256-R4S/kf5zVgtPtF7wn2EGDgIdFza6jQr8TagMt2i4iGQ=";
  };

  buildInputs = [
    xorg.libxcb
    libxkbcommon
  ];

  cargoHash = "sha256-bqc8Bva8vdDWxRBqDtSbmqeph1cRBdjls/iJO4mDI+c=";
}
