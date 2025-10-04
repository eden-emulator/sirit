add_library(siritobj OBJECT
    ../include/sirit/sirit.h
    sirit.cpp
    stream.h
    common_types.h
    instructions/type.cpp
    instructions/constant.cpp
    instructions/function.cpp
    instructions/flow.cpp
    instructions/debug.cpp
    instructions/derivatives.cpp
    instructions/memory.cpp
    instructions/annotation.cpp
    instructions/misc.cpp
    instructions/logical.cpp
    instructions/conversion.cpp
    instructions/bit.cpp
    instructions/arithmetic.cpp
    instructions/extension.cpp
    instructions/image.cpp
    instructions/group.cpp
    instructions/barrier.cpp
    instructions/atomic.cpp
)

target_compile_options(siritobj PRIVATE ${SIRIT_CXX_FLAGS})

target_include_directories(siritobj
    PUBLIC
    $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
    $<INSTALL_INTERFACE:include>
    PRIVATE .)

target_link_libraries(siritobj PUBLIC
                      $<BUILD_INTERFACE:SPIRV-Headers::SPIRV-Headers>)

set_property(TARGET siritobj PROPERTY POSITION_INDEPENDENT_CODE 1)

macro(add_sirit_library name type)
    add_library(${name} ${type} $<TARGET_OBJECTS:siritobj>)
    add_library(sirit::${name} ALIAS ${name})
    target_link_libraries(${name} PUBLIC
                          $<BUILD_INTERFACE:SPIRV-Headers::SPIRV-Headers>)

    target_include_directories(${name} PUBLIC
        $<BUILD_INTERFACE:${PROJECT_SOURCE_DIR}/include>
        $<INSTALL_INTERFACE:include>
    )
endmacro()

if (SIRIT_BUILD_SHARED)
    add_sirit_library(sirit SHARED)
endif()

if (SIRIT_BUILD_STATIC)
    if (SIRIT_BUILD_SHARED)
        add_sirit_library(sirit-static STATIC)
        set_target_properties(sirit-static PROPERTIES
            OUTPUT_NAME "${SIRIT_STATIC_LIBNAME}"
        )
    else()
        add_sirit_library(sirit STATIC)
    endif()
endif()

set_property(TARGET sirit PROPERTY PUBLIC_HEADER ../include/sirit/sirit.h)

set(SIRIT_TARGETS sirit)

if (TARGET sirit::sirit-static)
    set(SIRIT_TARGETS ${SIRIT_TARGETS} sirit-static)
endif()

if (SIRIT_INSTALL)
    include(GNUInstallDirs)

    install(TARGETS ${SIRIT_TARGETS}
        EXPORT siritTargets
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/sirit
    )
endif()
