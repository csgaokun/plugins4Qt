TEMPLATE = subdirs

SUBDIRS += Z-Package-Installer \
            HldPluginObject  \
            HldPluginMainWin


HldPluginMainWin.depends =  Z-Package-Installer HldPluginObject

CONFIG += ordered
