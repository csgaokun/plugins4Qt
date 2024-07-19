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
    product_name = projectinfo.product_name
    buildpath = projectinfo.build_path
    qtBinPath = projectinfo.qt_bin_path
    qtInstallPath = projectinfo.qt_install_path
    sourcePath = projectinfo.source_path
    platformname = projectinfo.platform_name
    versionNUM = projectinfo.version_NUM

    openglVersion = ""
    if len(qtInstallPath) == 0:
        print("The Qt of install path is NULL! please check it!")
        sys.exit()
    else:
        if qtInstallPath.find("opengles") != -1 or qtInstallPath.find("openglES") != -1:
            print("The Qt of version is opengl es!")
            openglVersion = "opengles"

    srcdist = os.path.join(buildpath,"package")

    versionGitHEADshort = subprocess.check_output(['git','rev-parse','--short','HEAD']).decode('ascii').strip();
    debPackageVersion = "{}.{}".format(versionNUM,versionGitHEADshort);

    print("The version of Git HEAD short is :" + versionGitHEADshort)
    print("The version number is " + versionNUM)
    print("The version of deb package is :" + debPackageVersion)

    print("Build path:" + buildpath)
    print("QtBinPath:" + qtBinPath)
    
    # target dir    
    packageDir = "package"    
    packageDEBIANDir = os.path.join(packageDir, "DEBIAN")
    packageAppDir = os.path.join(packageDir, "home","ins",product_name,"HLDBridge","HldDistributorService")
    packageAppSHpath = os.path.join(packageDir, "home","ins",product_name,"HLDBridge","APPSH")
    print("app package path is ->" + packageAppDir)

    # copy app file
    print("copy app file......")
    executeShell("rm  " + packageAppDir + "/*  -rf")
    executeShell("mkdir  " + packageAppDir + "  -p")
    executeShell("mkdir  " + packageAppSHpath + "  -p")

    Appcontent = ["lib","HldDistributorService","run_HldDistributorService.sh"]
    for contentfilesapp in Appcontent:
        executeShell("cp  " + contentfilesapp + " " + packageAppDir + "  -R")

#    copyFileByDir("Config", packageAppDir)
    print("app file copy finished!")


    #read script files and creat deb script
    srcDEBIANpath = os.path.join(packageDir,"DEBIAN")
    # versionNUM = "2.0.0" # ---> test
    DEBIANcontent = ["control", "preinst","postinst","prerm","postrm"]

    Architecture = readFile(os.path.join(srcDEBIANpath,"control")).replace("HLDPACKAGENAME", platformname)
    writeFile(os.path.join(packageDEBIANDir,"control"),Architecture)

    packagename = "hldDistributorService"
    if len(openglVersion) != 0:
        packagename = packagename + "-" + openglVersion;

    for contentfiles in DEBIANcontent:
        contentDEB = readFile(os.path.join(srcDEBIANpath,contentfiles)).replace("1.0.0", debPackageVersion)
        writeFile(os.path.join(packageDEBIANDir,contentfiles),contentDEB)
        contentDEB = readFile(os.path.join(srcDEBIANpath,contentfiles)).replace("hldDistributorService", packagename)
        writeFile(os.path.join(packageDEBIANDir,contentfiles),contentDEB)

    # make change the Qt install path for auto run srcript    
    autoscript = readFile(os.path.join("start_hlddistributorservice.sh")).replace("HLDQTENVPATH", qtInstallPath).replace("HLD_PRODUCT_NAME", product_name)
    writeFile(os.path.join("start_hlddistributorservice.sh"),autoscript)
    executeShell("cp   start_hlddistributorservice.sh " + packageAppSHpath + "  -R")

    executeShell("chmod 755 -R ./package/DEBIAN/*")

    print(sys.argv)
    packagePath = "./{}_{}_{}.deb".format(packagename,debPackageVersion,platformname);
    if(len(sys.argv) > 1):
        packagePath = sys.argv[1]
    executeShell("dpkg -b package " + packagePath)
    print("had compressed in path about " + packagePath)
    print("install script copy finished!")
    print("package-installer create successfully!")
    print("****************************************")


    print("**************************************** update config package is begin running ...... ")

    # target dir
    packageConfigDir = "packageConfig"
    packageConfigDEBIANDir = os.path.join(packageConfigDir, "DEBIAN")
    packageConfigAppDir = os.path.join(packageConfigDir, "home","ins",product_name,"HLDBridge","HldDistributorService")
    print("app packageConfig Update path is ->" + packageConfigAppDir)

    # copy app file
    print("copy app file......")
    executeShell("rm  " + packageConfigAppDir + "/*  -rf")
    executeShell("mkdir  " + packageConfigAppDir + "  -p")

    Appcontent = ["config"]
    for contentfilesapp in Appcontent:
        executeShell("cp  " + contentfilesapp + " " + packageConfigAppDir + "  -R")

#    copyFileByDir("Config", packageConfigAppDir)
    print("app file copy finished!")


    #read script files and creat deb script
    srcDEBIANpath = os.path.join(packageConfigDir,"DEBIAN")
    # versionNUM = "2.0.0" # ---> test
    DEBIANcontent = ["control", "preinst","postinst","prerm","postrm"]

    Architecture = readFile(os.path.join(srcDEBIANpath,"control")).replace("HLDPACKAGENAME", "all")
    writeFile(os.path.join(packageConfigDEBIANDir,"control"),Architecture)

    for contentfiles in DEBIANcontent:
        contentDEB = readFile(os.path.join(srcDEBIANpath,contentfiles)).replace("1.0.0", debPackageVersion)
        writeFile(os.path.join(packageConfigDEBIANDir,contentfiles),contentDEB)

    executeShell("chmod 755 -R ./packageConfig/DEBIAN/*")

    print(sys.argv)
    packageConfigPath = "./hldConfigDistributorService_{}.deb".format(debPackageVersion);
    if(len(sys.argv) > 1):
        packageConfigPath = sys.argv[1]
    executeShell("dpkg -b packageConfig " + packageConfigPath)
    print("had compressed in path about " + packageConfigPath)
    print("install script copy finished!")
    print("packageConfig-installer create successfully!")
    print("****************************************")

    product_name_qtVersion = product_name;
    if len(openglVersion) != 0:
        product_name_qtVersion = "{}_{}".format(product_name,openglVersion);

    executeShell("mkdir  ~/" + product_name_qtVersion + "/HLDBridge  -p")

    copyPackageDir = os.path.join(packageDir, "home","ins",product_name,"HLDBridge")

    executeShell("cp  " + copyPackageDir + "/*   ~/" + product_name_qtVersion + "/HLDBridge  -r")
    executeShell("cp  " + packageDir + "/*   ~/" + product_name_qtVersion + "/HLDBridge  -r")

    copyPackageConfigAppDir = os.path.join(packageConfigDir, "home","ins",product_name,"HLDBridge")
    executeShell("cp  " + copyPackageConfigAppDir + "/*   ~/" + product_name_qtVersion + "/HLDBridge -r")

    print("**************************************** end ****************************************")

    # exit
    sys.exit()
