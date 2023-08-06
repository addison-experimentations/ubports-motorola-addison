# Ubuntu Touch device tree for the Moto Z Play (addison)

This is based on Halium 9.0, and uses the mechanism described in [this
page](https://github.com/ubports/porting-notes/wiki/GitLab-CI-builds-for-devices-based-on-halium_arm64-(Halium-9)).



## How to build

To manually build this project, follow these steps:

```bash
export HOSTCC=gcc-9  # the build breaks with gcc-11
./build.sh -b bd  # bd is the name of the build directory
./build/prepare-fake-ota.sh out/device_addison.tar.xz ota
./build/system-image-from-ota.sh ota/ubuntu_command out
```


## Install

After the build process has successfully completed, run

```bash
fastboot flash boot out/boot.img
fastboot flash system out/system.img
```

## Splash screen

If you'd like to change the splash screen, run

```
./splash/generate.sh out
fastboot flash splash out/splash.img
```

## Building the vendor image

If you'd like to build it yourself, the steps are quite similar to those needed
to build the system image with Halium:

1. Initialize the repo: `repo init -u https://github.com/Halium/android -b halium-9.0 --depth=1`
2. `repo sync`
3. Until [this PR](https://github.com/Halium/halium-devices/pull/325) is not
   merged, you'll have to download the
   [`fm-bridge`](https://gitlab.com/ubuntu-touch-xiaomi-violet/fm-bridge)
   repository yourself:
```
    mkdir -p vendor/ubports/fm-bridge
    git clone https://gitlab.com/ubuntu-touch-xiaomi-violet/fm-bridge.git vendor/ubports/fm-bridge
```
4. Apply hybris patches: `hybris-patches/apply-patches.sh --mb`
5. `source build/envsetup.sh && breakfast addison`
6. `mka vendorimage`

This will generate a file `our/target/product/addison/vendor.img` that can be
flashed with `fastboot flash vendor vendor.img`.
