#!/bin/bash

# be strict on failures
set -e

echo "vendor/partner_gms/vendorsetup.sh called"

# get_files() {
#     local name="$1"
#     local id="$2"
#     local versionCode=$(cat "$name"/.version_code)
#     local release=$(cat ".microg_release")
#     local source_apk_name="$id-$versionCode.apk"
#     local src="https://github.com/microg/GmsCore/releases/download/$release/$source_apk_name"
#     local destination_apk="$name/$name.apk"

#     if [ -f "$destination_apk" ]; then
#         echo "$destination_apk exists: not downloading"
#     ## To Do
#     # Deal with the situation where we have an OLDER version hanging around
#     # may have to be handled in the Docker image
#     else
#         echo "downloading $destination_apk to $destination_apk"
#         curl -LO "$src"
#         mv "$source_apk_name"  "$destination_apk"
#     fi
# }

get-fdroid-components() {
    local fdroid_repo="https://mirror.cyberbits.eu/fdroid/repo"
    local name apk_to_download versioncode id

    # F-Droid client app
    name="FDroid"
    versioncode=$(cat "$name"/.version_code)
    id="org.fdroid.fdroid"
    apk_to_download="$fdroid_repo"/"$id"_"$versioncode".apk

    echo "$name apk_to_download: $apk_to_download"

    # FDroid Privileged Extension
    name="FDroidPrivilegedExtension"
    versioncode=$(cat "$name"/.version_code)
    id="org.fdroid.fdroid.privileged"
    apk_to_download="$fdroid_repo"/"$id"_"$versioncode".apk

    echo "$name apk_to_download: $apk_to_download"
}

# get-microg-components() {
#     local microg_repo_base="https://github.com/microg"
#     local name apk_to_download versioncode

#     # GmsCore
#     name="GmsCore"
#     apk_to_download="$microg_repo_base/GMSCore/org.fdroid.fdroid.privileged_$versioncode.apk"
#     #
#     # FakeStore
#     # GsfProxy


# }

# cd vendor/partner_gms
get-fdroid-components

# get_files GmsCore "com.google.android.gms"

# get_files FakeStore "com.android.vending"

cd ../..

set +e
