{ lib, stdenv, fetchFromGitHub, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "systemc";
  version = "2.3.4";

  src = fetchFromGitHub {
    owner = "accellera-official";
    repo = pname;
    rev = version;
    sha256 = "0sj8wlkp68cjhmkd9c9lvm3lk3sckczpz7w9vby64inc1f9fnf0b";
  };

  enableParallelBuilding = true;
  nativeBuildInputs = [ autoreconfHook ];

  meta = with lib; {
    description = "The language for System-level design, modeling and verification";
    homepage    = "https://systemc.org/";
    license     = licenses.asl20;
    maintainers = with maintainers; [ victormignot amiloradovsky ];
  };
}
