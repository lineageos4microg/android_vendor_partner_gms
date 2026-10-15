#!/bin/bash

echo "vendor/partner_gms/vendorsetup.sh called"

download_apk() {
    local source_apk=$1
    local component_name=$2
    local checksum_file
    local destination_apk
    local skip=0

    destination_apk="$component_name"/"$component_name".apk
    checksum_file="$component_name"/.sha256sum

    if [ -f "$destination_apk" ]; then
        echo "$destination_apk exists: verifying checksum"
	if sha256sum --check "$checksum_file"; then
            skip=1
	else
	    echo "$destination_apk: invalid signature, retrying download"
	fi
    fi

    if [ "$skip" = 0 ]; then
        # echo "downloading $source_apk to $destination_apk"
        curl -L --output "$destination_apk" "$source_apk" || exit 1
        echo "$destination_apk downloaded: verifying checksum"
	sha256sum --check "$checksum_file" || exit 1
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

    # echo "$name apk_to_download: $apk_to_download"
    download_apk "$apk_to_download" "$name"

    # FDroid Privileged Extension
    name="FDroidPrivilegedExtension"
    versioncode=$(cat "$name"/.version_code)
    id="org.fdroid.fdroid.privileged"
    apk_to_download="$fdroid_repo"/"$id"_"$versioncode".apk

    # echo "$name apk_to_download: $apk_to_download"
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
    # echo "$name apk_to_download: $apk_to_download"
    download_apk "$apk_to_download" "$name"

    # FakeStore
    name="FakeStore"
    versioncode=$(cat "$name"/.version_code)
    id="com.android.vending"
    apk_to_download="$microg_repo_base"/GMSCore/releases/download/"$microg_release"/"$id"-"$versioncode".apk
    # echo "$name apk_to_download: $apk_to_download"
    download_apk "$apk_to_download" "$name"

    # GsfProxy the file we want is
    #`https://github.com/microg/android_packages_apps_GsfProxy/releases/download/v0.1.0/GsfProxy.apk`
    name="GsfProxy"
    versioncode=$(cat "$name"/.version_code)
    apk_to_download="$microg_repo_base"/android_packages_apps_GsfProxy/releases/download/"$versioncode"/"$name".apk
    # echo "$name apk_to_download: $apk_to_download"
    download_apk "$apk_to_download" "$name"
}

# This script is called from the root dierctory, so we need to cd
callingdir="$(pwd)"
cd vendor/partner_gms || exit 1
get-fdroid-components
get-microg-components
# and back to the root directory
cd "$callingdir"
