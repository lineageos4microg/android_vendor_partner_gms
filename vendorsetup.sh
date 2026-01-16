#!/bin/bash

# be strict on failures
set -e

echo "vendor/partner_gms/vendorsetup.sh called"

get_files() {
    local name="$1"
    local id="$2"
    local src=$(curl -sS https://api.github.com/repos/microg/GmsCore/releases/latest | grep -E "/$id-[0-9]+.apk\"" | cut -d"\"" -f4)
    local destination_apk="$name/$name.apk"

    if [ -f "$destination_apk" ]; then
        echo "$destination_apk exists: not downloading"
    else
        echo "downloading $destination_apk to $destination_apk"
        curl -LO "$src"
        mv "$id"*  "$destination_apk"
    fi
}

cd vendor/partner_gms

get_files GmsCore "com.google.android.gms"

get_files FakeStore "com.android.vending"

cd ../..

set +e
