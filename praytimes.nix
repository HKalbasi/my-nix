{ rustPlatform
, fetchFromGitHub
, ...
}:

rustPlatform.buildRustPackage rec {
  pname = "PrayTimesRust";
  name = pname;

  src = fetchFromGitHub {
    owner = "BaseMax";
    repo = pname;
    rev = "1fc8e65679736b422b614f3470b0a97f6df5053a";
    hash = "sha256-mi3RS+7cv5mTLxMkJtOFd6OtVAxFLt1LkhsKgTYlLmM=";
  };

  cargoHash = "sha256-cazYRXnCxPWwPjqm8h2GZg+uGBJU1R5M3MyeyvowIeg=";
}
