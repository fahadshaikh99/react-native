# Copyright (c) Facebook, Inc. and its affiliates.
#
# This source code is licensed under the MIT license found in the
# LICENSE file in the root directory of this source tree.


##########################
### React Native Utils ###
##########################

LOCAL_PATH := $(call my-dir)

include $(CLEAR_VARS)

# Include . in the header search path for all source files in this module.
LOCAL_C_INCLUDES := $(LOCAL_PATH)

# Include ./../../ in the header search path for modules that depend on
# reactnativejni. This will allow external modules to require this module's
# headers using #include <react/jni/<header>.h>, assuming:
#   .     == jni
#   ./../ == react
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../..

LOCAL_CFLAGS += -fexceptions -frtti -Wno-unused-lambda-capture

LOCAL_LDLIBS += -landroid

# The dynamic libraries (.so files) that this module depends on.
LOCAL_SHARED_LIBRARIES := libfolly_json libfb libfbjni libglog_init libyoga

# The static libraries (.a files) that this module depends on.
LOCAL_STATIC_LIBRARIES := libreactnative libcallinvokerholder libruntimeexecutor

# Name of this module.
#
# Other modules can depend on this one by adding libreactnativejni to their
# LOCAL_SHARED_LIBRARIES variable.
LOCAL_MODULE := reactnativeutilsjni

# Compile all local c++ files.
LOCAL_SRC_FILES := $(wildcard Cxx*.cpp) $(wildcard J*.cpp) $(wildcard M*.cpp) $(wildcard N*.cpp) $(wildcard P*.cpp) $(wildcard R*.cpp) $(wildcard W*.cpp)

ifeq ($(APP_OPTIM),debug)
  # Keep symbols by overriding the strip command invoked by ndk-build.
  # Note that this will apply to all shared libraries,
  # i.e. shared libraries will NOT be stripped
  # even though we override it in this Android.mk
  cmd-strip :=
endif

# Build the files in this directory as a shared library
include $(BUILD_SHARED_LIBRARY)





######################
### reactnativejni ###
######################

include $(CLEAR_VARS)

# Include . in the header search path for all source files in this module.
LOCAL_C_INCLUDES := $(LOCAL_PATH)

# Include ./../../ in the header search path for modules that depend on
# reactnativejni. This will allow external modules to require this module's
# headers using #include <react/jni/<header>.h>, assuming:
#   .     == jni
#   ./../ == react
LOCAL_EXPORT_C_INCLUDES := $(LOCAL_PATH)/../..

LOCAL_CFLAGS += -fexceptions -frtti -Wno-unused-lambda-capture

LOCAL_LDLIBS += -landroid

# The dynamic libraries (.so files) that this module depends on.
LOCAL_SHARED_LIBRARIES := libreactnativeutilsjni libfolly_json libfb libfbjni libglog_init libyoga libreact_utils libreact_render_debug libreact_render_graphics libreact_render_core libreact_render_mapbuffer react_render_componentregistry libreact_render_components_view libreact_render_components_view libreact_render_components_unimplementedview libreact_render_components_root libreact_render_components_scrollview libbetter libreact_render_attributedstring libreact_render_uimanager libreact_render_templateprocessor libreact_render_scheduler libreact_render_animations libreact_render_imagemanager libreact_render_textlayoutmanager libfabricjni

# The static libraries (.a files) that this module depends on.
LOCAL_STATIC_LIBRARIES := libreactnative libcallinvokerholder libruntimeexecutor

# Name of this module.
#
# Other modules can depend on this one by adding libreactnativejni to their
# LOCAL_SHARED_LIBRARIES variable.
LOCAL_MODULE := reactnativejni

# Compile all local c++ files.
LOCAL_SRC_FILES := $(wildcard *.cpp)

ifeq ($(APP_OPTIM),debug)
  # Keep symbols by overriding the strip command invoked by ndk-build.
  # Note that this will apply to all shared libraries,
  # i.e. shared libraries will NOT be stripped
  # even though we override it in this Android.mk
  cmd-strip :=
endif

# Build the files in this directory as a shared library
include $(BUILD_SHARED_LIBRARY)

# Compile the c++ dependencies required for ReactAndroid
#
# How does the import-module function work?
#   For each $(call import-module,<module-dir>), you search the directories in
#   NDK_MODULE_PATH. (This variable is defined in Application.mk). If you find a
#   <module-dir>/Android.mk you in a directory <dir>, you run:
#   include <dir>/<module-dir>/Android.mk
#
# What does it mean to include an Android.mk file?
#   Whenever you encounter an include <dir>/<module-dir>/Android.mk, you
#   tell andorid-ndk to compile the module in <dir>/<module-dir> according
#   to the specification inside <dir>/<module-dir>/Android.mk.
$(call import-module,better)
$(call import-module,folly)
$(call import-module,fb)
$(call import-module,fbjni)
$(call import-module,jsc)
$(call import-module,fbgloginit)
$(call import-module,yogajni)
$(call import-module,cxxreact)
$(call import-module,jsi)
$(call import-module,jsiexecutor)
$(call import-module,callinvoker)
$(call import-module,reactperflogger)
$(call import-module,hermes)
$(call import-module,runtimeexecutor)

# Fabric dependencies:
$(call import-module,react/utils)
$(call import-module,react/renderer/animations)
$(call import-module,react/renderer/attributedstring)
$(call import-module,react/renderer/componentregistry)
$(call import-module,react/renderer/core)
$(call import-module,react/renderer/components/root)
$(call import-module,react/renderer/components/scrollview)
$(call import-module,react/renderer/components/unimplementedview)
$(call import-module,react/renderer/components/view)
$(call import-module,react/renderer/debug)
$(call import-module,react/renderer/graphics)
$(call import-module,react/renderer/imagemanager)
$(call import-module,react/renderer/mapbuffer)
$(call import-module,react/renderer/mounting)
$(call import-module,react/renderer/scheduler)
$(call import-module,react/renderer/templateprocessor)
$(call import-module,react/renderer/textlayoutmanager)
$(call import-module,react/renderer/uimanager)

include $(REACT_SRC_DIR)/reactperflogger/jni/Android.mk
include $(REACT_SRC_DIR)/turbomodule/core/jni/Android.mk
include $(REACT_SRC_DIR)/fabric/jni/Android.mk

# TODO(ramanpreet):
#   Why doesn't this import-module call generate a jscexecutor.so file?
# $(call import-module,jscexecutor)

include $(REACT_SRC_DIR)/jscexecutor/Android.mk
include $(REACT_SRC_DIR)/../hermes/reactexecutor/Android.mk
include $(REACT_SRC_DIR)/../hermes/instrumentation/Android.mk
include $(REACT_SRC_DIR)/modules/blob/jni/Android.mk
