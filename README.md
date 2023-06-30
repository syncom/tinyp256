# A minimum implementation of ECDSA-P256 signature verification with tinycrypt

This is an implementation of ECDSA signature verification with Curve
[P-256](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-186.pdf),
based on a minimum subset of source files from the [TinyCrypt cryptographic
library](https://github.com/intel/tinycrypt), with nearly no modification.

The API contains only one function

```c
/**
 * @brief Verify an ECDSA-P256 signature on a SHA-256 digest
 * @return returns TINYP256_OK if the signature is valid
 *         returns TINYP256_FAIL if an error occurred or the signature is
 *         invalid
 *
 * @param pk IN -- ECDSA-P256 public key. Must point to a 64-byte buffer
 * containing an uncompressed point in affine coordinates (Qx, Qy)
 * @param pk_len IN -- Size of public key buffer in bytes. Must be 64.
 * @param sha256 IN -- The SHA-256 signed hash. Must point to a 32-byte buffer.
 * @param sha256_len IN -- Size of hash buffer in bytes. Must be 32.
 * @param sig IN -- ECDSA-P256 signature value. Must point to a 64-byte buffer
 * containing the raw (r, s) value
 * @param sig_len IN -- Size of sig buffer in bytes. Must be 64.
 *
 */
tinyp256_t tinyp256_verify(
    const uint8_t *pk, uint16_t pk_len,
    uint8_t *sha256, uint16_t sha256_len,
    uint8_t *sig, uint16_t sig_len);
```

## Interoprating with OpenSSL

TODO