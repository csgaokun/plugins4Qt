QT       += core gui

DEFINES += HLD_APP
EXE_APP_NAME = %{ProjectName}
include(HldProject.pri)

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

CONFIG += c++11

# You can make your code fail to compile if it uses deprecated APIs.
# In order to do so, uncomment the following line.
#DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000    # disables all the APIs deprecated before Qt 6.0.0

SOURCES += \\
    %{MainFileName} \\
    %{SrcFileName}

HEADERS += \\
    %{HdrFileName}
@if %{GenerateForm}

FORMS += \\
    %{FormFileName}
@endif
@if %{HasTranslation}

TRANSLATIONS += \\
    %{TsFileName}
CONFIG += lrelease
CONFIG += embed_translations
@endif

# Default rules for deployment.
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target
