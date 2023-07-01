# A minimum implementation of ECDSA-P256 signature verification with tinycrypt

This is an implementation of ECDSA signature verification with Curve
[P-256](https://nvlpubs.nist.gov/nistpubs/SpecialPublications/NIST.SP.800-186.pdf),
based on a minimum subset of source files from the [TinyCrypt cryptographic
library](https://github.com/intel/tinycrypt), with nearly no modification. It
signs a 256-bit hash digest of the payload message: a natural choice of the hash
algorithm is SHA-256, and we will assume it.

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
 * @param sha256 IN -- The SHA-256 digest of the message to verify. Must point to a 32-byte buffer.
 * @param sha256_len IN -- Size of SHA-256 digest buffer in bytes. Must be 32.
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

## Interoperate with OpenSSL

### Key generation and message signing with OpenSSL

- Generate key pair

  Generate private key `private.pem`

  ```bash
  openssl ecparam -name prime256v1 -genkey -noout -out private.pem
  ```

  Get public key `public.pem` from private key

  ```bash
  openssl ec -in private.pem -pubout -out public.pem
  ```

- Sign payload message, using SHA-256 as message digest

  Suppose the payload message to sign is `msg.bin`. Get ECDSA-P256-SHA256
  signature `msg.sig.bin`

  ```bash
  openssl dgst -sha256 -sign private.pem -out msg.sig.bin msg.bin
  ```

  Signature can be verified with OpenSSL using command

  ```bash
  # See "Verification OK" upon success, "Verification Failure" otherwise
  openssl dgst -verify public.pem -keyform PEM -sha256 \
    -signature msg.sig.bin -binary msg.bin
  ```

  Sample files `private.pem`, `public.pem`, `msg.bin` and `msg.sig.bin` can be
  found in [testdata/](./testdata/).

### Signature verification with tinyp256

Obtain C-styled bytes arrays pointed to by `pk`, `sha256` and `sig` as follows.
Feed `tinyp256_verify()` with them for signature verification.

- Public key (`pk`)

  ```bash
  openssl ec -pubin -in public.pem -outform DER  2>/dev/null | xxd -i -s 27
  ```

- SHA-256 hash digest (`sha256`) of message to verify

  ```bash
  openssl dgst -sha256 -binary msg.bin | xxd -i
  ```

- Signature (`sig`)

  ```bash
  openssl asn1parse -in msg.sig.bin -inform DER \
    | awk -F':' '{print $4}' \
    | awk 'NF > 0' \
    | xxd -r -p \
    | xxd -i
  ```

Sample byte arrays `pk`, `sha256` and `sig` can be found in
[test_tinyp256.c](./test_tinyp256.c). To test, in repository's directory root

```bash
make
./test_tinyp256
```
