require "base64"
require "jwt"

ISSUER_ID = "76db13ba-00ef-4fa1-9a84-7de28e0cd342"
KEY_ID = "UPT425R2C6"

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
