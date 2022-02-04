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

Note: You do not need to set `CUSTOM_PACKAGES` for the packages to be included when building with [lineageos4microg/docker-lineage-cicd](https://github.com/lineageos4microg/docker-lineage-cicd).

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
