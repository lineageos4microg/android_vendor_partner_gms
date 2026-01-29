#!/bin/bash

# be strict on failures
set -e

echo "vendor/partner_gms/vendorsetup.sh called"

download_apk() {
    local source_apk=$1
    local component_name=$2
    local destination_apk

    destination_apk="$component_name"/"$component_name".apk
    if [ -f "$destination_apk" ]; then
        echo "$destination_apk exists: not downloading"
        ## To Do
        # Deal with the situation where we have an OLDER version hanging around
        # may have to be handled in the Docker image
    else
        echo "downloading $source_apk to $destination_apk"
        curl -L --output "$destination_apk" "$source_apk"
    fi
}

get-fdroid-components() {
    local fdroid_repo="https://f-droid.org/repo/"
    local name apk_to_download versioncode id

    # F-Droid client app
    name="FDroid"
    versioncode=$(cat "$name"/.version_code)
    id="org.fdroid.fdroid"
    apk_to_download="$fdroid_repo"/"$id"_"$versioncode".apk

    echo "$name apk_to_download: $apk_to_download"
    download_apk "$apk_to_download" "$name"

    # FDroid Privileged Extension
    name="FDroidPrivilegedExtension"
    versioncode=$(cat "$name"/.version_code)
    id="org.fdroid.fdroid.privileged"
    apk_to_download="$fdroid_repo"/"$id"_"$versioncode".apk

    echo "$name apk_to_download: $apk_to_download"
    download_apk "$apk_to_download" "$name"
}

get-microg-components() {
    local microg_repo_base="https://github.com/microg"
    local name apk_to_download versioncode id
    microg_release=$(cat ".microg_release")

    # GmsCore
    name="GmsCore"
    versioncode=$(cat "$name"/.version_code)
    id="com.google.android.gms"
    apk_to_download="$microg_repo_base"/GMSCore/releases/download/"$microg_release"/"$id"-"$versioncode".apk
    echo "$name apk_to_download: $apk_to_download"
    download_apk "$apk_to_download" "$name"

    # FakeStore
    name="FakeStore"
    versioncode=$(cat "$name"/.version_code)
    id="com.android.vending"
    apk_to_download="$microg_repo_base"/GMSCore/releases/download/"$microg_release"/"$id"-"$versioncode".apk
    echo "$name apk_to_download: $apk_to_download"
    download_apk "$apk_to_download" "$name"

    # GsfProxy the file we want is
    #`https://github.com/microg/android_packages_apps_GsfProxy/releases/download/v0.1.0/GsfProxy.apk`
    name="GsfProxy"
    versioncode=$(cat "$name"/.version_code)
    apk_to_download="$microg_repo_base"/android_packages_apps_GsfProxy/releases/download/"$versioncode"/"$name".apk
    echo "$name apk_to_download: $apk_to_download"
    download_apk "$apk_to_download" "$name"
}

# cd vendor/partner_gms
get-fdroid-components
get-microg-components
cd ../..

set +e
