/* tinyp256.h: A minimum implementation of ECDSA P255 signature verification
* using tinycrypt
*/

#ifndef __TINYP256__
#define __TINYP256__

#ifdef __cplusplus
extern "C" {
#endif

typedef enum {
    TINYP256_OK = 0,
    TINYP256_FAIL = 1
} tinyp256_t;

/**
 * @brief Verify an ECDSA-P256 signature on a SHA-256 digest
 * @return returns TINYP256_OK if the signature is valid
 *         returns TINYP256_FAIL if an error occurred or the signature is
 *         invalid
 *
 * @param pubkey IN -- ECDSA-P256 public key. Must point to a 64-byte buffer
 * containing an uncompressed point in affine coordinates (Qx, Qy)
 * @param pubkey_len IN -- Size of public key buffer in bytes. Must be 64.
 * @param digest IN -- The SHA-256 digest of the message to verify. Must point to a 32-byte buffer.
 * @param digest_len IN -- Size of SHA-256 digest buffer in bytes. Must be 32.
 * @param signature IN -- ECDSA-P256 signature value. Must point to a 64-byte buffer
 * containing the raw (r, s) value
 * @param signature_len IN -- Size of sig buffer in bytes. Must be 64.
 *
 */
tinyp256_t tinyp256_verify(
    const uint8_t *pubkey, uint16_t pubkey_len,
    uint8_t *digest, uint16_t digest_len,
    uint8_t *signature, uint16_t signature_len);

#ifdef __cplusplus
}
#endif

#endif // -_TINYP256__