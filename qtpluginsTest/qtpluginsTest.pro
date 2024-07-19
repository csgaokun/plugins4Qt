TEMPLATE = subdirs

SUBDIRS += Z-Package-Installer \
                PluginApp

PluginApp.depends =  Z-Package-Installer

CONFIG += ordered
