#!/bin/bash

# be strict on failures
set -e

echo "vendor/partner_gms/vendorsetup.sh called"

# F-Droid's APK signing certificate fingerprint, published at
#   https://f-droid.org/docs/Release_Channels_and_Signing_Keys/
# (owner: CN=Ciaran Gultnieks). Reproducible as the SHA-256 of the DER
# certificate in the 'pubkey' attribute of https://f-droid.org/repo/index.xml
FDROID_SIGNER=43238d512c1e5eb2d6569f4a3afbf5523418b82e0a3ed1552770abb9a9c9ccab

# microG's APK signing certificate fingerprint. Reproducible as the SHA-256 of
# the DER certificate in the 'pubkey' attribute of
#   https://microg.org/fdroid/repo/index.xml
# which is the same repo this project pre-seeds via additional_repos.xml.
MICROG_SIGNER=9bd06727e62796c0130eb6dab39b73157451582cbd138e86c468acc395d14165

# The tree ships apksigner, but the wrapper at
# prebuilts/sdk/tools/linux/bin/apksigner looks for its jar in $progdir,
# $progdir/lib and ../framework, while the jar is at
# prebuilts/sdk/tools/linux/lib/apksigner.jar, so it exits 1 with
# "can't find apksigner.jar". Invoke the jar directly instead.
# Resolve to an absolute path now, because this script later does
# 'cd vendor/partner_gms' before any download happens. envsetup.sh sources
# this file without cd-ing to the tree root, so prefer gettop over pwd.
APKSIGNER_TOP=$(gettop 2>/dev/null || pwd)
APKSIGNER_JAR=$APKSIGNER_TOP/prebuilts/sdk/tools/linux/lib/apksigner.jar

verify_apk_signer() {
    local apk=$1 expected=$2 name=$3 digest

    if [ ! -r "$APKSIGNER_JAR" ]; then
        echo "ERROR: $APKSIGNER_JAR not found; cannot verify $name" >&2
        return 1
    fi

    digest=$(java -jar "$APKSIGNER_JAR" verify --print-certs "$apk" 2>/dev/null \
             | sed -n 's/^Signer #1 certificate SHA-256 digest: //p')

    if [ "$digest" != "$expected" ]; then
        echo "ERROR: signature mismatch for $name" >&2
        echo "  expected: $expected" >&2
        echo "  got:      ${digest:-<none, unsigned or tampered>}" >&2
        return 1
    fi

    echo "verified signature for $name"
}

download_apk() {
    local source_apk=$1
    local component_name=$2
    local signer=$3
    local destination_apk

    destination_apk="$component_name"/"$component_name".apk
    if [ -f "$destination_apk" ]; then
        echo "$destination_apk exists: not downloading"
        ## To Do
        # Deal with the situation where we have an OLDER version hanging around
        # may have to be handled in the Docker image
    else
        # echo "downloading $source_apk to $destination_apk"
        curl -L --output "$destination_apk" "$source_apk"
    fi
    verify_apk_signer "$destination_apk" "$signer" "$component_name"
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
    download_apk "$apk_to_download" "$name" "$FDROID_SIGNER"

    # FDroid Privileged Extension
    name="FDroidPrivilegedExtension"
    versioncode=$(cat "$name"/.version_code)
    id="org.fdroid.fdroid.privileged"
    apk_to_download="$fdroid_repo"/"$id"_"$versioncode".apk

    # echo "$name apk_to_download: $apk_to_download"
    download_apk "$apk_to_download" "$name" "$FDROID_SIGNER"
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
    download_apk "$apk_to_download" "$name" "$MICROG_SIGNER"

    # FakeStore
    name="FakeStore"
    versioncode=$(cat "$name"/.version_code)
    id="com.android.vending"
    apk_to_download="$microg_repo_base"/GMSCore/releases/download/"$microg_release"/"$id"-"$versioncode".apk
    # echo "$name apk_to_download: $apk_to_download"
    download_apk "$apk_to_download" "$name" "$MICROG_SIGNER"

    # GsfProxy the file we want is
    #`https://github.com/microg/android_packages_apps_GsfProxy/releases/download/v0.1.0/GsfProxy.apk`
    name="GsfProxy"
    versioncode=$(cat "$name"/.version_code)
    apk_to_download="$microg_repo_base"/android_packages_apps_GsfProxy/releases/download/"$versioncode"/"$name".apk
    # echo "$name apk_to_download: $apk_to_download"
    download_apk "$apk_to_download" "$name" "$MICROG_SIGNER"
}

# This script is called from the root dierctory, so we need to cd
cd vendor/partner_gms
get-fdroid-components
get-microg-components
# and back to the root directory
cd ../..

set +e
