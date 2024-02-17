import 'dart:convert';
import 'dart:math';

import 'package:cryptography/cryptography.dart';
import 'package:shared_preferences/shared_preferences.dart';

//COMMENTS GENERATED WITH CO PILOT WOOOOOOOO

class EncryptedData {
  final List<int> bytes;

  /// A message authentication code.
  final List<int> mac;
  final List<int> nonce;

  EncryptedData({required this.bytes, required this.mac, required this.nonce});

  toJson() {
    return {'bytes': bytes, 'mac': mac, 'nonce': nonce};
  }

  factory EncryptedData.fromJson(Map json) {
    return EncryptedData(
        bytes: <int>[...json['bytes']],
        mac: <int>[...json['mac']],
        nonce: <int>[...json['nonce']]);
  }
}

/// Service for end-to-end encryption.
class E2EncryptionService {
  E2EncryptionService._();

  static final E2EncryptionService _instance = E2EncryptionService._();
  static E2EncryptionService get instance => _instance;

  final Random _random = Random();

  List<int> get _nonce => List.generate(12, (index) => _random.nextInt(200));

  final _exchangeAlgorithm = X25519();
  final _cypherAlgorithm = Chacha20.poly1305Aead();
  late SimpleKeyPair _sessionKey;

  final Map<SimplePublicKey, SecretKey> _cachedSecrets = {};

  List<int>? _publicKey;
  Future<List<int>> get getPublicKey async {
    return _publicKey ??= (await _sessionKey.extractPublicKey()).bytes;
  }

  /// Initializes the encryption service.
  ///
  /// [uid] - The user ID.
  initialize({String uid = 'default'}) async {
    // final algorithm = Sha1();
    // final hash = await algorithm.hash(_appEncryptionSecret.codeUnits);
    // _nonce = hash.bytes.take(12).toList();

    SharedPreferences pref = await SharedPreferences.getInstance();

    var savedKey = pref.getString(uid);
    if (savedKey != null && savedKey.isNotEmpty) {
      _sessionKey = keyPairFromJsonString(savedKey);
    } else {
      _sessionKey = await _exchangeAlgorithm.newKeyPair();
      pref.setString(uid, (await keyPairToJsonString(_sessionKey)));
    }
  }

  /// Retrieves or generates a shared secret key for encryption/decryption.
  ///
  /// [otherPublicKey] - The public key of the other party.
  Future<SecretKey> _getSharedSecret(SimplePublicKey otherPublicKey) async {
    if (_cachedSecrets[otherPublicKey] != null) {
      return _cachedSecrets[otherPublicKey]!;
    } else {
      final secret = await _exchangeAlgorithm.sharedSecretKey(
          keyPair: _sessionKey, remotePublicKey: otherPublicKey);
      _cachedSecrets[otherPublicKey] = secret;
      return secret;
    }
  }

  /// Encrypts a message using the provided public key.
  ///
  /// [otherPublicKey] - The public key of the recipient.
  /// [message] - The message to encrypt.
  Future<EncryptedData> encrypt(
      List<int> otherPublicKey, String message) async {
    SecretKey sharedSecret = await _getSharedSecret(SimplePublicKey(
      otherPublicKey,
      type: KeyPairType.x25519,
    ));

    final encodedMessage = utf8.encode(message);

    final secretBox = await _cypherAlgorithm.encrypt(encodedMessage,
        nonce: _nonce, secretKey: sharedSecret);

    return EncryptedData(
      bytes: secretBox.cipherText,
      nonce: _nonce,
      mac: secretBox.mac.bytes,
    );
  }

  /// Decrypts an encrypted message using the provided public key.
  ///
  /// [encryptedData] - The encrypted data to decrypt.
  /// [otherPublicKey] - The public key of the sender.
  Future<String> decrypt(
      EncryptedData encryptedData, List<int> otherPublicKey) async {
    SecretKey sharedSecret = await _getSharedSecret(SimplePublicKey(
      otherPublicKey,
      type: KeyPairType.x25519,
    ));

    final secretBox = SecretBox(encryptedData.bytes,
        nonce: encryptedData.nonce, mac: Mac(encryptedData.mac));

    var encodedMessage =
        await _cypherAlgorithm.decrypt(secretBox, secretKey: sharedSecret);
    return utf8.decode(encodedMessage);
  }

  Future<String> keyPairToJsonString(SimpleKeyPair keyPair) async {
    SimpleKeyPairData keyData = await keyPair.extract();

    Map data = {'private': keyData.bytes, 'public': keyData.publicKey.bytes};

    return json.encode(data);
  }

  SimpleKeyPair keyPairFromJsonString(String encodedJson) {
    Map data = json.decode(encodedJson);

    return SimpleKeyPairData(<int>[...data['private']],
        publicKey:
            SimplePublicKey(<int>[...data['public']], type: KeyPairType.x25519),
        type: KeyPairType.x25519);
  }
}
