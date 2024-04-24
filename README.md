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

Note 1. You do not need to set `CUSTOM_PACKAGES` for the packages to be included when building with [our Docker engine](https://github.com/lineageos4microg/docker-lineage-cicd).

Note 2. For the microG packages to work, signature spoofing must be enabled, by patching the LineageOS sources before building. 
- If you are building with [our Docker engine](https://github.com/lineageos4microg/docker-lineage-cicd), this is done automatically according to the values of the `SIGNATURE_SPOOFING` variable - see [here](https://github.com/lineageos4microg/docker-lineage-cicd#signature-spoofing). By default, this variable is set to `restricted`, allowing only system apps (those built-in to the ROM) to 'spoof' the signature of another app. 
- If you are building manually, you can download and include the patches from [here](https://github.com/lineageos4microg/docker-lineage-cicd/tree/master/src/signature_spoofing_patches). If you follow the [microG patching instructions](https://github.com/microg/GmsCore/wiki/Signature-Spoofing), you ROM will allow _**any**_ app, not only system apps, to spoof app signatures. To apply only 'restricted' signature spoofing, you should do something similar to what the  Docker engine `build.sh` does in [this code](https://github.com/lineageos4microg/docker-lineage-cicd/blob/c77eabe036a1620499a8c087b732e039e0734656/src/build.sh#L229C1-L231C1).


The included APKs are:
 * FDroid packages (binaries sourced from [here](https://f-droid.org/packages/org.fdroid.fdroid/) and [here](https://f-droid.org/packages/org.fdroid.fdroid.privileged/))
   * FDroid: a catalogue of FOSS (Free and Open Source Software) applications for the Android platform
   * FDroid Privileged Extension: a FDroid extension to ease the installation/removal of apps
   * additional_repos.xml: a simple package to include the [microG FDroid repository](https://microg.org/fdroid.html) in the ROM (requires FDroid >= 1.5)
 * microG packages (binaries sourced from [here](https://microg.org/download.html))
   * GmsCore: the main component of microG, a FOSS reimplementation of the Google Play Services (requires GsfProxy and FakeStore for full functionality)
   * GsfProxy: a GmsCore proxy for legacy GCM compatibility
   * FakeStore: an empty package that mocks the existence of the Google Play Store
   * IchnaeaNlpBackend: Network location provider using Mozilla Location Service
   * NominatimGeocoderBackend: Geocoder backend that uses OSM Nominatim service.

These are official unmodified prebuilt binaries, signed by the
corresponding developers.
