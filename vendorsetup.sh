#!/bin/bash

# be strict on failures
set -e

echo "vendor/partner_gms/vendorsetup.sh called"

get_files() {
    local name id versionCode release source_apk_name src destination_apk
    name="$1"
    id="$2"
    versionCode=$(cat "$name"/.version_code)
    release=$(cat ".microg_release")
    source_apk_name="$id-$versionCode.apk"
    src="https://github.com/microg/GmsCore/releases/download/$release/$source_apk_name"
    destination_apk="$name/$name.apk"

    if [ -f "$destination_apk" ]; then
        echo "$destination_apk exists: not downloading"
    else
        echo "downloading $destination_apk to $destination_apk"
        curl -L "$src" --output "$(dirname "${BASH_SOURCE[0]}")"/"$destination_apk".apk
    fi
}

get_files GmsCore "com.google.android.gms"

get_files FakeStore "com.android.vending"

set +e
