ifeq ($(ROOTLESS),1)
THEOS_PACKAGE_SCHEME=rootless
else ifeq ($(ROOTHIDE),1)
THEOS_PACKAGE_SCHEME=roothide
endif

DEBUG=0
FINALPACKAGE=1
ARCHS = arm64
PACKAGE_VERSION = 1.0.0
TARGET := iphone:clang:16.5:13.0

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = YouLitePlus
$(TWEAK_NAME)_FRAMEWORKS = UIKit Foundation SystemConfiguration Security
$(TWEAK_NAME)_CFLAGS = -fobjc-arc -DTWEAK_VERSION=$(PACKAGE_VERSION)
# Keep the minimal build surface. YTNativeShare brings an obsolete protobuf
# tree that is not needed for the requested YouLite+ feature set.
$(TWEAK_NAME)_FILES = YTLite.x Settings.x Sideloading.x Utils/*.m

include $(THEOS_MAKE_PATH)/tweak.mk
