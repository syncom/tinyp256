#!/usr/bin/env bash
#
# Test openssl-generated test vector with tinyp256
#
set -euxo pipefail

SCRIPT_DIR="$(cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
readonly SCRIPT_DIR

PRIKEY_FILE="$(mktemp)"
readonly PRIKEY_FILE

PUBKEY_FILE="$(mktemp)"
readonly PUBKEY_FILE

PAYLOAD_FILE="$(mktemp)"
readonly PAYLOAD_FILE

SIGNATURE_FILE="$(mktemp)"
readonly SIGNATURE_FILE

TEST_APP_FILE="$SCRIPT_DIR/../__tmp_test.c"
readonly TEST_APP_FILE

########################################
# Generate a test vector using openssl
#
# Keygen
openssl ecparam -name prime256v1 -genkey -noout -out "$PRIKEY_FILE"
openssl ec -in "$PRIKEY_FILE" -pubout -out "$PUBKEY_FILE"
# Create random payload and sign it
head -c 4096 /dev/urandom > "$PAYLOAD_FILE"
openssl dgst -sha256 -sign "$PRIKEY_FILE" -out "$SIGNATURE_FILE" "$PAYLOAD_FILE"

PUBKEY="$(openssl ec -pubin -in "$PUBKEY_FILE" -outform DER  2>/dev/null \
  | xxd -i -s 27)"
DIGEST="$(openssl dgst -sha256 -binary "$PAYLOAD_FILE" | xxd -i)"
SIGNATURE="$(openssl asn1parse -in "$SIGNATURE_FILE" -inform DER \
  | awk -F':' '{print $4}' \
  | awk 'NF > 0' \
  | xxd -r -p \
  | xxd -i)"


################################################
# Create test application containing test vector
#
cat <<EOF >"$TEST_APP_FILE"
#include <stdint.h>
#include <stdio.h>
#include "tinyp256.h"

uint8_t pubkey[64] = {
$PUBKEY
};

uint8_t digest[32] = {
$DIGEST
};

uint8_t signature[64] = {
$SIGNATURE
};

int main(void) {
    if (tinyp256_verify(pubkey, sizeof(pubkey), digest, sizeof(digest), signature, sizeof(signature)) == TINYP256_OK) {
        printf("Signature is good\n");
        return 0;
    } else {
        printf("Signature is bad\n");
        return 1;
    }
}
EOF

############################################
# Build test app and test
#
make clean
make APP_SRC="$TEST_APP_FILE"
res="$("$SCRIPT_DIR"/../test_tinyp256)"
[[ "$res" == "Signature is good" ]] || exit 1