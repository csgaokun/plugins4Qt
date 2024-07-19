DEFINES += HLD_PLUGIN
EXE_APP_NAME = GenericPlugin1
include(../HldPluginsProject.pri)

HEADERS += \
    genericplugin1.h

DISTFILES += \
    programmer.json             #插件描述文件

msvc {
    #QMAKE_CFLAGS += /utf-8
    QMAKE_CXXFLAGS += /utf-8
}
