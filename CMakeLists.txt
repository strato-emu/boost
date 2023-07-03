# Copyright 2019, 2021 Peter Dimov
# Distributed under the Boost Software License, Version 1.0.
# See accompanying file LICENSE_1_0.txt or copy at http://www.boost.org/LICENSE_1_0.txt

cmake_minimum_required(VERSION 3.5...3.16)

# The default build type must be set before project()
if(CMAKE_SOURCE_DIR STREQUAL CMAKE_CURRENT_SOURCE_DIR AND NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Build type" FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

project(Boost VERSION 1.83.0 LANGUAGES CXX)

set(BOOST_SUPERPROJECT_VERSION ${PROJECT_VERSION})
set(BOOST_SUPERPROJECT_SOURCE_DIR ${PROJECT_SOURCE_DIR})

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/tools/cmake/include)

include(BoostRoot)

add_library(boost INTERFACE)
target_link_libraries(boost INTERFACE
    Boost::array
    Boost::assert
    Boost::bind
    Boost::concept_check
    Boost::config
    Boost::container
    Boost::container_hash
    Boost::conversion
    Boost::core
    Boost::date_time
    Boost::describe
    Boost::detail
    Boost::function
    Boost::function_types
    Boost::fusion
    Boost::icl
    Boost::integer
    Boost::intrusive
    Boost::io
    Boost::iterator
    Boost::move
    Boost::mp11
    Boost::mpl
    Boost::optional
    Boost::predef
    Boost::preprocessor
    Boost::range
    Boost::rational
    Boost::regex
    Boost::smart_ptr
    Boost::static_assert
    Boost::throw_exception
    Boost::tuple
    Boost::type_index
    Boost::type_traits
    Boost::typeof
    Boost::utility
    Boost::functional
    Boost::variant
    Boost::winapi
)
add_library(Boost::boost ALIAS boost)

