import 'dart:convert';
import 'package:crypto/crypto.dart'; // For MD5 hash
import 'package:encrypt/encrypt.dart'; // For AES encryption

class EncryptionHelper {
  // Define the encryption algorithm and key
  static final String encryptedStringPrefix = "bldyPrm";
  static final String sykeyString = "bldyKy"; // Your key string
  static final String sycodec = 'AES'; // Encryption algorithm (AES)

  // Method to generate hash (MD5) of the key
  static List<int> getMd5Hash(String input) {
    return md5.convert(utf8.encode(input)).bytes;
  }

  // Method to Hash the input URL and encrypt it with AES
  static String hashString(String url) {
    try {
      // Convert the key into MD5 hash
      getMd5Hash(sykeyString);

      // Create a 16-byte key (needed for AES)
      final encrypter = Encrypter(AES(Key.fromLength(16))); // AES encryption with 16-byte key
      final iv = IV.fromLength(16); // Initialization vector for AES encryption

      // Encrypt the URL with AES and convert it to hex
      final encrypted = encrypter.encrypt(url, iv: iv);

      // Return the encrypted string with prefix
      return encryptedStringPrefix + encrypted.base64;
    } catch (e) {
      throw Exception("Url or Text cannot be Encoded.");
    }
  }
}
