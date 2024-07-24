DEFINES += HLD_PRODUCT_NAME
PRODUCT_NAME=IBSN0

DEFINES += __OUT_NAME__

contains(QMAKE_TARGET.arch, x86_64) {
    PLATFORM_BIN = bin
}
!contains(QMAKE_TARGET.arch, x86_64) {
    PLATFORM_BIN = bin
}
CONFIG(release, debug|release):PLATFORM = $${PLATFORM_BIN}_release
else:CONFIG(debug, debug|release):PLATFORM = $${PLATFORM_BIN}_debug


if(contains(DEFINES,HLD_APP)){
    CONFIG(debug, debug|release){
        DEFINES += _BUILD_TYPE_DEBUG_
        COMPILE_TARGET = Debug
        __OUT_NAME__ = $${EXE_APP_NAME}D
        \#Qt调试用
        DEFINES += QT_MESSAGELOGCONTEXT
    }else:CONFIG(release, debug|release){
        DEFINES += _BUILD_TYPE_RELEASE_
        COMPILE_TARGET = Release
        __OUT_NAME__ = $${EXE_APP_NAME}
    }
    TARGET = $${__OUT_NAME__}
}

if(contains(DEFINES,HLD_LIBS)){
    CONFIG(debug, debug|release){
        DEFINES += _BUILD_TYPE_DEBUG_
        COMPILE_TARGET = Debug
        __OUT_NAME__ = $${EXE_LIBS_NAME}D
        \#Qt调试用
        DEFINES += QT_MESSAGELOGCONTEXT
    }else:CONFIG(release, debug|release){
        DEFINES += _BUILD_TYPE_RELEASE_
        COMPILE_TARGET = Release
        __OUT_NAME__ = $${EXE_LIBS_NAME}
    }
    TARGET = $${__OUT_NAME__}
}

message(this out name is : $${__OUT_NAME__})

unix {
    \#定义编译目标平台     \# OS specific definitions
    DEFINES += TARGET_UNIX

    \#定义编译目标平台
    contains(QMAKE_HOST.arch, x86_64){
        DEFINES += UNIX_x86_64
        LIBPATH_NAME_PLATFORM = unix_x86_64
        PACKAGE_NAME_PLATFORM = amd64
    }else:contains(QMAKE_HOST.arch, aarch64){
        DEFINES += UNIX_arm_64
        LIBPATH_NAME_PLATFORM = unix_arm64
        PACKAGE_NAME_PLATFORM = arm64

        \#Arm 平台中的基础变量char会默认为 0~255，加入编译标志后和台式机保持一致
        QMAKE_CXXFLAGS += -fsigned-char
    }else:contains(QMAKE_HOST.arch, mips64){
        DEFINES += UNIX_mips_64
        LIBPATH_NAME_PLATFORM = unix_mips64
        PACKAGE_NAME_PLATFORM = mips64
    }

    if(contains(DEFINES,HLD_APP)){
        EXE_APP=$${__OUT_NAME__}
        \# 编译输出的基础目录
        STATIC_OUTPUT_BASE = $$PWD/../$${PLATFORM}
        copy_projectinfo_in.input = $$PWD/Z-Package-Installer/run.sh.in
        copy_projectinfo_in.output = $$STATIC_OUTPUT_BASE/run_$${__OUT_NAME__}.sh
        QMAKE_SUBSTITUTES += copy_projectinfo_in
    }

    if(contains(DEFINES,HLD_LIBS)){
        \# 这种方式只生成一种so文件
        TEMPLATE = lib
        CONFIG += plugin
        DESTDIR = $$PWD/../$${PLATFORM}/lib
        \# 做对应的拷贝，因为只生成一种so，所以扩展名为so
\#        QMAKE_POST_LINK += \\
\#            $$QMAKE_MKDIR $$replace($$list($$PWD/../$${PLATFORM}/lib), /, $$QMAKE_DIR_SEP) & \\
\#            $$QMAKE_COPY $$replace($$list($$quote($$OUT_PWD/lib$${__OUT_NAME__}.so) $$PWD/../$${PLATFORM}/lib), /, $$QMAKE_DIR_SEP)
    }

    if(contains(DEFINES,HLD_APP)){
        \# 这种方式只生成执行程序
        TEMPLATE = app
        DESTDIR = $$PWD/../$${PLATFORM}

        \# 做对应的拷贝，对执行进程进行拷贝
\#        QMAKE_POST_LINK += \\
\#            $$QMAKE_MKDIR $$replace($$list($$PWD/../$${PLATFORM}), /, $$QMAKE_DIR_SEP) & \\
\#            $$QMAKE_COPY $$replace($$list($$quote($$OUT_PWD/$${__OUT_NAME__}) $$PWD/../$${PLATFORM}), /, $$QMAKE_DIR_SEP)
    }
}


win32 {
    \# OS specific definitions
    DEFINES += TARGET_WINDOWS

    \#\#include <winsock2.h>和\#include<windows.h> 编译顺序的问题
    DEFINES += WIN32_LEAN_AND_MEAN

    contains(QMAKE_HOST.arch, x86_64){
        DEFINES += WIN32_x86_64
        LIBPATH_NAME_PLATFORM = win32_x86_64
    }else:contains(QMAKE_HOST.arch, aarch64){
        DEFINES += WIN32_arm_64
        LIBPATH_NAME_PLATFORM = win32_arm64

        \#Arm 平台中的基础变量char会默认为 0~255，加入编译标志后和台式机保持一致
        QMAKE_CXXFLAGS += -fsigned-char
    }else:contains(QMAKE_HOST.arch, mips64){
        DEFINES += WIN32_mips_64
        LIBPATH_NAME_PLATFORM = win32_mips64
    }

    if(contains(DEFINES,HLD_LIBS)){
        \# 这种方式只生成一种dll文件
        TEMPLATE = lib
\#        CONFIG += plugin

        \# 做对应的拷贝，因为调试的不同生成不同的dll
        win32:CONFIG(debug, debug|release): QMAKE_POST_LINK += \\
            $$QMAKE_MKDIR $$replace($$list($$PWD/../$$PLATFORM), /, $$QMAKE_DIR_SEP) & \\
            $$QMAKE_COPY $$replace($$list($$quote($$OUT_PWD/debug/$${__OUT_NAME__}.dll) $$PWD/../$$PLATFORM), /, $$QMAKE_DIR_SEP)
        else:win32:CONFIG(release, debug|release): QMAKE_POST_LINK += \\
            $$QMAKE_MKDIR $$replace($$list($$PWD/../$$PLATFORM), /, $$QMAKE_DIR_SEP) & \\
            $$QMAKE_COPY $$replace($$list($$quote($$OUT_PWD/release/$${__OUT_NAME__}.dll) $$PWD/../$$PLATFORM), /, $$QMAKE_DIR_SEP)
    }

    if(contains(DEFINES,HLD_APP)){
        \# 这种方式只生成执行程序
        TEMPLATE = app
        DESTDIR = $$PWD/../$${PLATFORM}

        \# 做对应的拷贝，对执行进程进行拷贝
\#        win32:CONFIG(debug, debug|release): QMAKE_POST_LINK += \\
\#            $$QMAKE_MKDIR $$replace($$list($$PWD/../../$$PLATFORM), /, $$QMAKE_DIR_SEP) & \\
\#            $$QMAKE_COPY $$replace($$list($$quote($$OUT_PWD/debug/$${__OUT_NAME__}.exe) $$PWD/../$$PLATFORM), /, $$QMAKE_DIR_SEP)
\#        else:win32:CONFIG(release, debug|release): QMAKE_POST_LINK += \\
\#            $$QMAKE_MKDIR $$replace($$list($$PWD/../../$$PLATFORM), /, $$QMAKE_DIR_SEP) & \\
\#            $$QMAKE_COPY $$replace($$list($$quote($$OUT_PWD/release/$${__OUT_NAME__}.exe) $$PWD/../$$PLATFORM), /, $$QMAKE_DIR_SEP)
    }

}

\#win32-g++: QMAKE_CXXFLAGS += -std=c++11
\#unix: QMAKE_CXXFLAGS += -std=c++11
