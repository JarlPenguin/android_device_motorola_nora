#!/bin/bash
#
# Copyright (C) 2016 The CyanogenMod Project
# Copyright (C) 2017-2020 The LineageOS Project
#
# SPDX-License-Identifier: Apache-2.0
#

# If we're being sourced by the common script that we called,
# stop right here. No need to go down the rabbit hole.
if [ "${BASH_SOURCE[0]}" != "${0}" ]; then
    return
fi

set -e

export BOARD_COMMON=msm8937-common
export DEVICE=montana
export VENDOR=motorola

"./../../${VENDOR}/${BOARD_COMMON}/extract-files.sh" "$@"

DEVICE_BLOB_ROOT="../../../vendor/${VENDOR}/${DEVICE}/proprietary"

sed -i 's|/firmware/image|/vendor/f/image|' "${DEVICE_BLOB_ROOT}/vendor/bin/hw/android.hardware.biometrics.fingerprint@2.1-fpcservice"
patchelf --set-soname camera.msm8937.so "${DEVICE_BLOB_ROOT}/vendor/lib/hw/camera.msm8937.so"
patchelf --remove-needed android.hidl.base@1.0.so "${DEVICE_BLOB_ROOT}/vendor/lib/com.fingerprints.extension@1.0_vendor.so"
patchelf --set-soname libactuator_dw9767_truly.so "${DEVICE_BLOB_ROOT}/vendor/lib/libactuator_dw9767_truly.so"
sed -i "s/ro.product.manufacturer/ro.product.nopefacturer/" "${DEVICE_BLOB_ROOT}/vendor/lib/libmmcamera2_pproc_modules.so"
sed -i 's|msm8953_mot_deen_camera.xml|msm8937_mot_camera_conf.xml|g' "${DEVICE_BLOB_ROOT}/vendor/lib/libmmcamera2_sensor_modules.so"
sed -i "s/libgui/libwui/" "${DEVICE_BLOB_ROOT}/vendor/lib/libmmcamera_ppeiscore.so"
patchelf --add-needed libppeiscore_shim.so "${DEVICE_BLOB_ROOT}/vendor/lib/libmmcamera_ppeiscore.so"
sed -i "s/system input/system uhid input/" "${DEVICE_BLOB_ROOT}/vendor/etc/init/android.hardware.biometrics.fingerprint@2.1-fpcservice.rc"
sed -i "s/class late_start/class hal/" "${DEVICE_BLOB_ROOT}/vendor/etc/init/android.hardware.biometrics.fingerprint@2.1-fpcservice.rc"
