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
    rev = "c0d857512b233f3d14b0a353d7a420a287f949d5";
    hash = "sha256-zKv/UNpMZIiUcxDrTrqfWUD+VeLEzKmce6KD+ITaGIA=";
  };

  buildInputs = [
    xorg.libxcb
    libxkbcommon
  ];

  cargoHash = "sha256-bqc8Bva8vdDWxRBqDtSbmqeph1cRBdjls/iJO4mDI+c=";
}
