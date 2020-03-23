import os
from tests.package.test_python import TestPythonPackageBase


class TestGst1Python(TestPythonPackageBase):
    __test__ = True
    config = TestPythonPackageBase.config + \
        """
        BR2_TOOLCHAIN_EXTERNAL=y
        BR2_TARGET_ROOTFS_CPIO=y
        BR2_cortex_a9=y
        BR2_ARM_ENABLE_VFP=y
        BR2_ARM_EABIHF=y
        BR2_TOOLCHAIN_EXTERNAL_LINARO_ARM=y
        BR2_PACKAGE_GOBJECT_INTROSPECTION=y
        BR2_PACKAGE_GSTREAMER1=y
        BR2_PACKAGE_GST1_PYTHON=y
        BR2_PACKAGE_PYTHON3=y
        BR2_PACKAGE_PYTHON_GOBJECT=y
        """

    def login(self):
        cpio_file = os.path.join(self.builddir, "images", "rootfs.cpio")
        self.emulator.boot(arch="armv7",
                           kernel="builtin",
                           options=["-initrd", cpio_file])
        self.emulator.login()
    sample_scripts = ["tests/package/sample_gst1_python.py"]

