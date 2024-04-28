require "base64"
require "jwt"

ISSUER_ID = "b57adbf8-49b8-445a-8929-3958379ff509"
KEY_ID = "L2HCMP3RY2"

private_key = OpenSSL::PKey.read(File.read(ARGV[0]))
token = JWT.encode(
  {
    iss: ISSUER_ID,
    exp: Time.now.to_i + 20 * 60,
    aud: "appstoreconnect-v1",
  },
  private_key,
  "ES256",
  header_fields = {
    alg: "ES256",
    kid: KEY_ID,
    typ: "JWT"
  }
)
puts token
