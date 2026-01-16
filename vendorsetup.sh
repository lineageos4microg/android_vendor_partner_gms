#!/bin/bash

# be strict on failures
set -e

echo "vendor/partner_gms/vendorsetup.sh called"

get_microg_files() {
    local name id src
    name="$1"
    id="$2"
    src=$(curl -sS https://api.github.com/repos/microg/GmsCore/releases/latest | grep -E "/$id-[0-9]+.apk\"" | cut -d"\"" -f4)
    curl --location "$src" --output "$name"/"$name".apk
}

get_fdroid_files() {
    src_name="$1"
    trg_name="$2"
    curl https://f-droid.org/"$src_name".apk --output "$trg_name"/"$trg_name".apk
}

cd vendor/partner_gms

get_microg_files GmsCore "com.google.android.gms"
get_microg_files FakeStore "com.android.vending"

get_fdroid_files F-Droid FDroid
get_fdroid_files repo/org.fdroid.fdroid.privileged_2130 FDroidPrivilegedExtension

cd ../..

set +e
