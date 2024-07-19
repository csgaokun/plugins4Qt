DEFINES += HLD_PLUGIN
EXE_APP_NAME = pluginA
include(../HldPluginsProject.pri)


HEADERS += \
    plugina.h

SOURCES += \
    plugina.cpp

DISTFILES += \
    programmer.json \
    programmer.json             #插件描述文件

msvc {
    #QMAKE_CFLAGS += /utf-8
    QMAKE_CXXFLAGS += /utf-8
}
