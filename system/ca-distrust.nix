{ ... }:
{
  # eMudhra intermediate CA key compromise (2026-10-17):
  # https://emudhra.we-have-a-problem.com/
  # Drop once nixpkgs cacert ships the distrust.
  security.pki.caCertificateBlacklist = [
    "Comodo AAA Services root"
    "emSign ECC Root CA - G3"
  ];
}
