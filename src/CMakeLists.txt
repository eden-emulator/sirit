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

target_link_libraries(siritobj PUBLIC SPIRV-Headers::SPIRV-Headers)

set_property(TARGET siritobj PROPERTY POSITION_INDEPENDENT_CODE 1)

if (SIRIT_BUILD_SHARED)
    add_library(sirit SHARED $<TARGET_OBJECTS:siritobj>)
endif()

if (SIRIT_BUILD_STATIC)
    if (SIRIT_BUILD_SHARED)
        add_library(sirit-static STATIC $<TARGET_OBJECTS:siritobj>)
        set_target_properties(sirit-static PROPERTIES
            OUTPUT_NAME "${SIRIT_STATIC_LIBNAME}"
        )
        add_library(sirit::sirit-static ALIAS sirit-static)
    else()
        add_library(sirit STATIC $<TARGET_OBJECTS:siritobj>)
    endif()
endif()

set_property(TARGET sirit PROPERTY PUBLIC_HEADER ../include/sirit/sirit.h)

add_library(sirit::sirit ALIAS sirit)

set(SIRIT_TARGETS sirit)

if (TARGET sirit::sirit-static)
    set(SIRIT_TARGETS ${SIRIT_TARGETS} sirit-static)
endif()

include(GNUInstallDirs)

install(TARGETS ${SIRIT_TARGETS}
    EXPORT siritTargets
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
    PUBLIC_HEADER DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/sirit
)