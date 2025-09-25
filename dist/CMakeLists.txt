# This is a little wrapper that allows usage of prebuilt
# Sirit through CPM or FetchContent

set(SIRIT_LIB_DIR ${CMAKE_CURRENT_LIST_DIR}/lib)
set(SIRIT_INCLUDE_DIR ${CMAKE_CURRENT_LIST_DIR}/include)

if (UNIX)
    if (APPLE)
        set(SHARED_SUFFIX dylib)
    else()
        set(SHARED_SUFFIX so)
    endif()

    if (BUILD_SHARED_LIBS)
        set(LIB_TYPE SHARED)
        set(LIB_SUFFIX ${SHARED_SUFFIX})
    else()
        set(LIB_TYPE STATIC)
        set(LIB_SUFFIX a)
    endif()

    add_library(sirit ${LIB_TYPE} IMPORTED GLOBAL)
    set_target_properties(sirit PROPERTIES
        IMPORTED_LOCATION ${SIRIT_LIB_DIR}/libsirit.${LIB_SUFFIX}
    )
else() # Windows
    if (BUILD_SHARED_LIBS)
        add_library(sirit SHARED IMPORTED GLOBAL)
        set_target_properties(sirit PROPERTIES
            IMPORTED_LOCATION ${SIRIT_LIB_DIR}/sirit.dll
            IMPORTED_IMPLIB ${SIRIT_LIB_DIR}/sirit.lib
        )
    else()
        add_library(sirit STATIC IMPORTED GLOBAL)
        set_target_properties(sirit PROPERTIES
            IMPORTED_LOCATION ${SIRIT_LIB_DIR}/sirit-static.lib
        )
    endif()
endif()

set_target_properties(sirit PROPERTIES
    INTERFACE_INCLUDE_DIRECTORIES ${SIRIT_INCLUDE_DIR}
)

add_library(sirit::sirit ALIAS sirit)