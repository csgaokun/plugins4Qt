include(../HldProject.pri)

# 创建一个不生成任何内容的Makefile。 如果不需要调用任何编译器来创建目标，请使用此选项；
TEMPLATE = aux

HLD_LIBPATH_NAME_PLATFORM = $${PACKAGE_NAME_PLATFORM}
HLD_IMAGED_SOURCE_TREE = $$PWD/../
HLD_IMAGED_BUILD_TREE = $$PWD/../../$${PLATFORM}

# STATIC_FILES中列出的文件的基础目录
STATIC_BASE = $$PWD
# 编译输出的基础目录
STATIC_OUTPUT_BASE = $$PWD/../../$${PLATFORM}
# 安装输出的基础目录
STATIC_INSTALL_BASE = $$PWD/../../$${PLATFORM}


CLIENT_VERSION=0.0.001

version.target = file_ver.h
unix:version.commands = "cd $$PWD; echo \\$$LITERAL_HASH\define CLIENT_VERSION \\\"$${CLIENT_VERSION}\\\" > file_ver.h"
win32:version.commands = $$system($$PWD/get_version.bat $${CLIENT_VERSION})
version.depends = FORCE

QMAKE_EXTRA_TARGETS += version

message(hld app build verion is $${CLIENT_VERSION})
HLD_APP_BUILD_VERSION=$${CLIENT_VERSION}
HLD_LIBPATH_NAME_PLATFORM=$${PACKAGE_NAME_PLATFORM}


# unix:CONFIG(release, debug|release){
#     #要部署的文件列表
#     STATIC_FILES += \
#                 $$PWD/dist-packagehelper-ubuntu.py     \
#                 $$PWD/package/DEBIAN/control    \
#                 $$PWD/package/DEBIAN/preinst    \
#                 $$PWD/package/DEBIAN/postinst   \
#                 $$PWD/package/DEBIAN/prerm      \
#                 $$PWD/package/DEBIAN/postrm     \
#                 $$PWD/package/etc/xdg/autostart/QRDecode_hlddistributorservice.desktop  \
#                 $$PWD/package/usr/share/applications/hlddistributorservice.desktop   \
#                 $$PWD/package/usr/share/pixmaps/hlddistributorservice.png

#     # 更新包的文件列表，主要是用来更新配置文件的更改的
#     STATIC_FILES += \
#             $$PWD/packageConfig/DEBIAN/control    \
#             $$PWD/packageConfig/DEBIAN/preinst    \
#             $$PWD/packageConfig/DEBIAN/postinst   \
#             $$PWD/packageConfig/DEBIAN/prerm      \
#             $$PWD/packageConfig/DEBIAN/postrm


#     #    自动化脚本文件
#     STATIC_FILES += $$PWD/start_hlddistributorservice.sh

#     copy_projectinfo_in.input = projectinfo.py.in
#     copy_projectinfo_in.output = $$STATIC_OUTPUT_BASE/projectinfo.py
#     #解析后生成对应文件，不能加入这一行；
#     #copy_projectinfo_in.CONFIG = verbatim
#     QMAKE_SUBSTITUTES += copy_projectinfo_in

#     OTHER_FILES += projectinfo.py.in

# }

STATIC_FILES +=

win32 {
    COPY_DEST = $$replace(PWD,/,\\)
    # system("xcopy /s /e /q /y $$COPY_DEST\\config\\*   $$COPY_DEST\\..\\..\\$$PLATFORM")
}

unix {
    system("mkdir -p $$PWD/../../$$PLATFORM/lib/")
    ## 拷贝运行脚本
    system("chmod 755 $$PWD/../../$$PLATFORM/* -R")
}
include(qtcreatordata.pri)

