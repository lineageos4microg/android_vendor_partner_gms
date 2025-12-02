#!/bin/bash

# be strict on failures
set -e

echo "vendor/partner_gms/vendorsetup.sh called"

get_files() {
    local name="$1"
    local id="$2"
    local versionCode=$(cat "$name"/.version_code)
    local release=$(cat ".microg_release")
    local source_apk_name="$id-$versionCode.apk"
    local src="https://github.com/microg/GmsCore/releases/download/$release/$source_apk_name"
    local destination_apk="$name/$name.apk"

    if [ -f "$destination_apk" ]; then
        echo "$destination_apk exists: not downloading"
    else
        echo "downloading $destination_apk to $destination_apk"
        curl -LO "$src"
        mv "$source_apk_name"  "$destination_apk"
    fi
}

cd vendor/partner_gms

get_files GmsCore "com.google.android.gms"

get_files FakeStore "com.android.vending"

cd ../..

set +e
