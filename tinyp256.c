#include <stdint.h>
#include "ecc.h"
#include "ecc_dsa.h"
#include "tinyp256.h"

tinyp256_t tinyp256_verify(
    const uint8_t *pubkey, uint16_t pubkey_len,
    uint8_t *digest, uint16_t digest_len,
    uint8_t *signature, uint16_t signature_len)
{
    const struct uECC_Curve_t * curve = uECC_secp256r1();
    if (pubkey_len != 64) {
        return TINYP256_FAIL;
    }

    if (digest_len != 32) {
        return TINYP256_FAIL;
    }

    if (signature_len != 64) {
        return TINYP256_FAIL;
    }
    if (uECC_valid_public_key(pubkey, curve) != 0) {
        return TINYP256_FAIL;
    }

    return ( uECC_verify(pubkey, digest, digest_len, signature, curve) == 1 ?
        TINYP256_OK : TINYP256_FAIL );
}
