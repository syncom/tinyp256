cmake_minimum_required(VERSION 3.1...3.29)

project(
  tinyp256
  VERSION 1.0
  LANGUAGES C)

add_library(tinyp256 tinyp256.c ecc.c ecc_dsa.c constants.h tinyp256.h)

## [main]

