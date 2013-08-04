## Specify phone tech before including full_phone
$(call inherit-product, vendor/cm/config/gsm.mk)

# Release name
PRODUCT_RELEASE_NAME := u86

# Inherit some common CM stuff.
$(call inherit-product, vendor/cm/config/common_full_phone.mk)

# Inherit device configuration
$(call inherit-product, device/k-touch/u86/full_u86.mk)

# Correct boot animation size for the screen.
TARGET_BOOTANIMATION_NAME := vertical-540x960
TARGET_SCREEN_HEIGHT := 960
TARGET_SCREEN_WIDTH := 540

## Device identifier. This must come after all inclusions
PRODUCT_DEVICE := u86
PRODUCT_NAME := cm_u86
PRODUCT_BRAND := K-Touch
PRODUCT_MODEL := u86
PRODUCT_MANUFACTURER := K-Touch

# Set build fingerprint / ID / Product Name ect.
PRODUCT_BUILD_PROP_OVERRIDES += \
	PRODUCT_NAME=u86 \
	BUILD_FINGERPRINT=qcom/msm8625/msm8625:4.1.2/JZO54K/TBW593126_8663_V006026:user/test-keys \
	PRIVATE_BUILD_DESC="msm8625-user 4.1.2 JZO54K TBW593126_8663_V006026 test-keys"

