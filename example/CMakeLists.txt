# -----------------------------------------------------------------------------
#
# Copyright (C) The BioDynaMo Project.
# All Rights Reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
#
# See the LICENSE file distributed with this work for details.
# See the NOTICE file distributed with this work for additional information
# regarding copyright ownership.
#
# -----------------------------------------------------------------------------
cmake_minimum_required(VERSION 3.2.0)

project(libroadrunner-example)
set(target libroadrunner-example)

set(CMAKE_CXX_STANDARD 14)

include_directories("src")

# find llvm-6
find_package(LLVM 6 REQUIRED CONFIG)

include_directories(${LLVM_INCLUDE_DIRS})
add_definitions(${LLVM_DEFINITIONS})

# Find the libraries that correspond to the LLVM components
# that we wish to use
llvm_map_components_to_libnames(llvm_libs mcjit native)

# libroadrunner
set(LIBRR_INSTALL_DIR "/tmp/build/roadrunner/install/roadrunner")
link_directories(${LIBRR_INSTALL_DIR}/lib)
include_directories(${LIBRR_INSTALL_DIR}/include)
include_directories(${LIBRR_INSTALL_DIR}/include/rr)
include_directories(${LIBRR_INSTALL_DIR}/include/sbml)
include_directories(${LIBRR_INSTALL_DIR}/include/cvode)


file(GLOB_RECURSE HEADERS src/*.h)
file(GLOB_RECURSE SOURCES src/*.cc)

add_executable(${target} src/main.cc)

# Link against LLVM libraries
target_link_libraries (${target}
roadrunner-static
nleq1-static.a
nleq2-static.a
rr-libstruct-static
lapack
blas
f2c
libsbml-static.a
xml2
sundials_nvecserial.a
sundials_cvode.a
pthread
dl
z
PocoUtil PocoNet PocoXML PocoFoundation
bz2
tinfo
)

# Link agains LLVM libraries
target_link_libraries(${target} ${llvm_libs})
