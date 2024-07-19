QT       += core gui


DEFINES += HLD_APP
EXE_APP_NAME = HldPluginMainWin
include(../HldProject.pri)


greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0
DEFINES += QT_DEPRECATED_WARNINGS

# 这里的添加是个固定模式，因为  HldPluginsmanager 这个库文件是必须的
INCLUDEPATH += $$PWD/../HldPluginObject/HldPluginsmanager
DEPENDPATH  += $$PWD/../HldPluginObject/HldPluginsmanager
win32:CONFIG(release, debug|release): LIBS += -L$$OUT_PWD/../HldPluginObject/HldPluginsmanager/release/ -lHldPluginsmanager
else:win32:CONFIG(debug, debug|release): LIBS += -L$$OUT_PWD/../HldPluginObject/HldPluginsmanager/debug/ -lHldPluginsmanagerD
unix:CONFIG(release, debug|release): LIBS += -L$$PWD/../../$${PLATFORM}/lib -lHldPluginsmanager
else:unix:CONFIG(debug, debug|release): LIBS += -L$$PWD/../../$${PLATFORM}/lib -lHldPluginsmanagerD


SOURCES += \
    main.cpp \
    widget.cpp

HEADERS += \
    interfaceplugin.h \
    monitor.h \
    widget.h

FORMS += \
    widget.ui

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
