var cry = require('crypto');

var IV_LEN = 16;
var SALT_LEN = 16;
var KEY_LEN = 32;

var CIPHER_ALGO = 'aes-256-cbc';
var HMAC_DIGEST = 'sha256';
var ITERATIONS = 65000;

var UTF8 = 'utf8';
var HEX = 'hex';

var generateBytes = function(byteLenth) {
    return cry.randomBytes(byteLenth);
};

var getHex = function(buf) {
    return buf.toString(HEX);
};

var getBuf = function(hex) {
    return Buffer.from(hex, HEX);
};

var generateSalt = function() {
    return generateBytes(SALT_LEN);
};

var generateIv = function() {
    return generateBytes(IV_LEN);
};

var generateKey = function(master, salt) {
    return cry.pbkdf2Sync(master, salt, ITERATIONS, KEY_LEN, HMAC_DIGEST);
};

var generateCipher = function(key, iv) {
    return cry.createCipheriv(CIPHER_ALGO, key, iv);
};

var generateDecipher = function(key, iv) {
    return cry.createDecipheriv(CIPHER_ALGO, key, iv);
};

var encrypt = function(master, input) {
    var salt = generateSalt();
    var iv = generateIv();
    var key = generateKey(master, salt);
    var cipher = generateCipher(key, iv);
    var text = cipher.update(input, UTF8, HEX);
    text += cipher.final(HEX);
    return { text: text, salt: getHex(salt), iv: getHex(iv) };
};

var decrypt = function(master, obj) {
    var salt = getBuf(obj.salt);
    var iv = getBuf(obj.iv);
    var key = generateKey(master, salt);
    var decipher = generateDecipher(key, iv);
    var text = decipher.update(obj.text, HEX, UTF8);
    text += decipher.final(UTF8);
    return text;
};

if (typeof window !== 'undefined') {
    X = {
        encrypt: encrypt,
        decrypt: decrypt
    };
    window.X = X;
}
