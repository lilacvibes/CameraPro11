ARCHS = arm64 arm64e
TARGET = iphone:clang:13.3:13.0
INSTALL_TARGET_PROCESSES = Camera

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = CameraPro11

CameraPro11_FILES = Tweak.xm
CameraPro11_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
