#!/bin/sh

set -xe

for GRP in spi i2c gpio; do
	addgroup --system $GRP
done
