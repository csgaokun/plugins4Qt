#!/usr/bin/python3
'''
This script use to create HLD-imaged install package
'''

import os
import os.path
import subprocess
import sys
import shutil

def writeFile(fileName,content):
    f = open(fileName, 'w')
    f.write(content)
    f.close()

def readFile(fileName):
    f = open(fileName, 'r')
    content = f.read()
    f.close()
    return content

def fileThrough(dir, topDown=True):
    fileList = []
    for root, dirs, files in os.walk(dir, topDown):
        for name in files:
            fileList.append(os.path.join(root, name))
    return fileList

def copyFileByDir(sourceDir, distDir):
    fileList = []
    fileList = fileThrough(sourceDir)
    for file in fileList:
        shutil.copy2(file, distDir)

def executeShell(shellContent, cwd=None):
    handle = subprocess.Popen(shellContent, stdout=subprocess.PIPE,shell=True, cwd=cwd)
    returnCode = handle.communicate()
    return returnCode

if __name__ == '__main__':

    import projectinfo
    buildpath = projectinfo.build_path
    qtBinPath = projectinfo.qt_bin_path
    sourcePath = projectinfo.source_path
    versionNUM = "1.0.0"
    srcdist = os.path.join(sourcePath,"dist")

    print("The version number is " + versionNUM)
    print("Build path:" + buildpath)
    print("QtBinPath:" + qtBinPath)
    
    # target dir
    libcopyDirpathList = [];
    packageDir = "package-installer"
    libcopyDirpathList.append(packageDir)
    packageDEBIANDir = os.path.join(packageDir, "DEBIAN")     
    libcopyDirpathList.append(packageDEBIANDir)
    packageOptSysDir = os.path.join(packageDir, "opt")
    libcopyDirpathList.append(packageOptSysDir)
    serviceSysd =  os.path.join(packageDir, "etc", "systemd", "system")
    libcopyDirpathList.append(serviceSysd)

    packageAppDir = os.path.join(packageOptSysDir, "HLD-imaged")
    libcopyDirpathList.append(packageAppDir)
    packageBinDir = os.path.join(packageAppDir, "bin")
    libcopyDirpathList.append(packageBinDir)
    packageLibDir = os.path.join(packageAppDir, "lib")
    libcopyDirpathList.append(packageLibDir)
    packagePlugins = os.path.join(packageAppDir, "plugins")
    libcopyDirpathList.append(packagePlugins)

    packageEtcSysdDir = os.path.join(packageAppDir, "etc", "systemd", "system")
    libcopyDirpathList.append(packageEtcSysdDir)

    # lib compare
    stringTupe = executeShell("ldd ../bin/HLD-imaged")
    string = stringTupe[0].decode()
    libpathList = string.split("\n\t")
    pathList = []
    for lib in libpathList:
        firstList = lib.split("(")
        lastList = firstList[0].split("=>")
        if len(lastList)==2:
            pathList.append(lastList[1])

    # neccerary lib
    libList= ["Qt","fbt"]

    # filter lib path
    libcopypathList = [];
    for path in pathList:
        for cinstr in libList:
            if cinstr in path:
                libcopypathList.append(path)

    # build dir
    buildBinDir = "../bin"
    buildLibDir = "../lib"
    buildPlugins = "../plugins"


    # create package folders
    for dirpath in libcopyDirpathList:
        if not os.path.exists(dirpath):
            os.makedirs(dirpath)

    # copy necessary plugins
    pluginPaths = ["imageformats", "platforms"]
    for path in pluginPaths:
        print("Ready to copy necessary plugins:" + path)
        targetDir = os.path.abspath(os.path.join(packagePlugins, path))
        print("Target dir:" + targetDir)
        if not os.path.exists(targetDir):
            os.makedirs(targetDir)
        copyFileByDir(os.path.join(qtBinPath, "../plugins", path), targetDir)

    # copy app file
    print("copy app file......")
    copyFileByDir(buildBinDir, packageBinDir)
    copyFileByDir(buildLibDir, packageLibDir)
    for path in libcopypathList:
        executeShell("cp "+ path +" "+packageLibDir)
    copyFileByDir(buildPlugins, packagePlugins)
    serviceName = "HLD-imaged.service"
    shutil.copyfile(serviceName, os.path.join(packageEtcSysdDir,serviceName))
    shutil.copyfile(serviceName, os.path.join(serviceSysd, serviceName))

    print("app file copy finished!")

    #read script files and creat deb script
    srcDEBIANpath = os.path.join(srcdist,"DEBIAN")
    # versionNUM = "2.0.0" # ---> test
    DEBIANcontent = ["control", "preinst","postinst","prerm","postrm"]
    for contentfiles in DEBIANcontent:
        contentDEB = readFile(os.path.join(srcDEBIANpath,contentfiles)).replace("1.0.0", versionNUM)
        writeFile(os.path.join(packageDEBIANDir,contentfiles),contentDEB)


    executeShell("chmod 755 -R ./package-installer/DEBIAN/*")
    
    print(sys.argv)
    packagePath = "./HLD-imaged-{}.deb".format(version)
    if(len(sys.argv) > 1):
        packagePath = sys.argv[1]
    executeShell("sudo dpkg -b package-installer " + packagePath)
    print("had compressed in path about " + packagePath)
    print("install script copy finished!")
    print("package-installer create successfully!")
    print("****************************************")
    
    # exit
    sys.exit()
