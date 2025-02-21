# microG Mobile Services

This is a collection of FOSS APKs, coupled with the respective Makefiles for an
easy integration in the Android build system.

To include them in your build, add a repo manifest file to include this repository as `vendor/partner_gms` and set
`WITH_GMS` to `true` when building.

Example manifest:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<manifest>
    <project path="vendor/partner_gms" name="lineageos4microg/android_vendor_partner_gms" remote="github" revision="master" />
</manifest>
```

Note 1. You do not need to set `CUSTOM_PACKAGES` for the packages to be included when building with [our Docker engine](https://github.com/lineageos4microg/docker-lineage-cicd). LineageOS did not make those changes in the 17.1 branch, so to make a 17.1 build, you will need to apply the changes to `AndroidManifest.xml` and `strings.xml` from [the Android Q LOS 17.1 branch-specific patch](https://github.com/lineageos4microg/docker-lineage-cicd/blob/35b7190bda4f2988845f09e028d266a23fd8b559/src/signature_spoofing_patches/android_frameworks_base-Q.patch). You do not need to apply the other changes in that patch. (See [this issue, and all it's comments](https://github.com/lineageos4microg/android_vendor_partner_gms/issues/42#issuecomment-2674105896) for more information about this)

Note 2. LineageOS now support ***restricted*** signature spoofing, in 18.1 and later branches, so it is no longer neccessary to patch their sources, unless you want ***unrestricted*** signature spoofing
~~For the microG packages to work, signature spoofing must be enabled, by patching the LineageOS sources before building.~~
- ~~If you are building with [our Docker engine](https://github.com/lineageos4microg/docker-lineage-cicd), this is done automatically according to the values of the `SIGNATURE_SPOOFING` variable - see [here](https://github.com/lineageos4microg/docker-lineage-cicd#signature-spoofing). By default, this variable is set to `restricted`, allowing only system apps (those built-in to the ROM) to 'spoof' the signature of another app.~~
- ~~If you are building manually, you can download and include the patches from [here](https://github.com/lineageos4microg/docker-lineage-cicd/tree/master/src/signature_spoofing_patches). If you follow the [microG patching instructions](https://github.com/microg/GmsCore/wiki/Signature-Spoofing), you ROM will allow _**any**_ app, not only system apps, to spoof app signatures. To apply only 'restricted' signature spoofing, you should do something similar to what the  Docker engine `build.sh` does in [this code](https://github.com/lineageos4microg/docker-lineage-cicd/blob/c77eabe036a1620499a8c087b732e039e0734656/src/build.sh#L229C1-L231C1).~~

Note 3. If you encounter problems related to APK / app signing when using these components you may need to add the following line in the Android.mk for the component in question:
```
LOCAL_REPLACE_PREBUILT_APK_INSTALLED := $(LOCAL_PATH)/$(LOCAL_MODULE).apk
```
Such problems can occur when

    the app / APK is resigned with your keys; (this should not happen if the line LOCAL_CERTIFICATE := PRESIGNED is included in the app makefile)
    app / APK signatures are 'stripped` during the during the deodexing phase of the build. For some apps the deodexed app ends up unsigned, and so will not run.

The symptoms of the problem as some apps from this repo (e.g. FakeStore and GmsCore) missing completely from your launcher and acting like they're not installed.

(Some background to this issue can be found [here](https://github.com/lineageos4microg/android_vendor_partner_gms/issues/30) and [here](https://gitlab.com/iode/os/public/lineage/vendor_extra/-/issues/4))

---------------

The included APKs are:
 * FDroid packages (binaries sourced from [here](https://f-droid.org/packages/org.fdroid.fdroid/) and [here](https://f-droid.org/packages/org.fdroid.fdroid.privileged/))
   * FDroid: a catalogue of FOSS (Free and Open Source Software) applications for the Android platform
   * FDroid Privileged Extension: a FDroid extension to ease the installation/removal of apps
   * additional_repos.xml: a simple package to include the [microG FDroid repository](https://microg.org/fdroid.html) in the ROM (requires FDroid >= 1.5)
 * microG packages (binaries sourced from [here](https://microg.org/download.html))
   * GmsCore: the main component of microG, a FOSS reimplementation of the Google Play Services (requires GsfProxy and FakeStore for full functionality)
   * GsfProxy: a GmsCore proxy for legacy GCM compatibility
   * FakeStore: an empty package that mocks the existence of the Google Play Store

These are official unmodified prebuilt binaries, signed by the
corresponding developers.
