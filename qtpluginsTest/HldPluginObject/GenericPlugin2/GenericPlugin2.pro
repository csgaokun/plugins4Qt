DEFINES += HLD_PLUGIN
EXE_APP_NAME = GenericPlugin2
include(../HldPluginsProject.pri)

HEADERS += \
    genericplugin2.h


DISTFILES += \
    programmer.json             #插件描述文件

msvc {
    #QMAKE_CFLAGS += /utf-8
    QMAKE_CXXFLAGS += /utf-8
}
