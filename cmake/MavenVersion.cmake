# #%L
# OME C++ libraries (cmake build infrastructure)
# %%
# Copyright © 2017 Open Microscopy Environment:
#   - Massachusetts Institute of Technology
#   - National Institutes of Health
#   - University of Dundee
#   - Board of Regents of the University of Wisconsin-Madison
#   - Glencoe Software, Inc.
# %%
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice,
#    this list of conditions and the following disclaimer.
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDERS OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.
#
# The views and conclusions contained in the software and documentation are
# those of the authors and should not be interpreted as representing official
# policies, either expressed or implied, of any organization.
# #L%

# Extract the maven project name and version information from a POM
# pom the POM file to read
# artefact the variable in which to store the project name
# version the variable in which to store the project version
# snapshot the variable in which to store if this version is a
#          snapshot (Boolean)
function(maven_version pom artefact version snapshot)
  set(artefact_regex ".*<artifactId>(.*)</artifactId>.*")
  set(version_regex ".*<version>([0-9]+\.[0-9]+\.[0-9]+)(-SNAPSHOT)?</version>.*")

  file(STRINGS "${pom}" pomdata ENCODING "UTF-8"
    REGEX "<artifactId>|<version>")

  foreach(line IN LISTS pomdata)
    if(NOT ${artefact} AND NOT artefact_match)
      string(REGEX MATCH "${artefact_regex}" artefact_match "${line}")
      if(artefact_match)
        set(${artefact} "${CMAKE_MATCH_1}" PARENT_SCOPE)
      endif()
    endif()
    if(NOT ${version} AND NOT version_match)
      string(REGEX MATCH "${version_regex}" version_match "${line}")
      if(version_match)
        set(${version} "${CMAKE_MATCH_1}" PARENT_SCOPE)
        if(CMAKE_MATCH_2 STREQUAL "-SNAPSHOT")
          set(${snapshot} TRUE PARENT_SCOPE)
        else()
          set(${snapshot} FALSE PARENT_SCOPE)
        endif()
      endif()
    endif()
    if(artefact_match AND version_match)
      break()
    endif()
  endforeach()
endfunction()
