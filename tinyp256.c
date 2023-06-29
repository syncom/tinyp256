#include <stdint.h>
#include "ecc.h"
#include "ecc_dsa.h"
#include "tinyp256.h"

tinyp256_t tinyp256_verify(
    const uint8_t *pk, uint16_t pk_len,
    uint8_t *sha256, uint16_t sha256_len,
    uint8_t *sig, uint16_t sig_len)
{
    const struct uECC_Curve_t * curve = uECC_secp256r1();
    if (pk_len != 64) {
        return TINYP256_FAIL;
    }

    if (sha256_len != 32) {
        return TINYP256_FAIL;
    }

    if (sig_len != 64) {
        return TINYP256_FAIL;
    }
    if (uECC_valid_public_key(pk, curve) != 0) {
        return TINYP256_FAIL;
    }

    return ( uECC_verify(pk, sha256, sha256_len, sig, curve) == 1 ?
        TINYP256_OK : TINYP256_FAIL );
}
