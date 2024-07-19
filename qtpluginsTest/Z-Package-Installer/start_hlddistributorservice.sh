#!/bin/bash
QT_INSTALL_PATH=HLDQTENVPATH
QTLIB=$QT_INSTALL_PATH/lib/
export LD_LIBRARY_PATH=$QTLIB:$LD_LIBRARY_PATH
#export XDG_RUNTIME_DIR=/tmp/xdg-runtime-$USER
#mkdir -m 0700 ${XDG_RUNTIME_DIR} -p

#export QT_QPA_PLATFORM=xcb
export QT_QPA_EGLFS_HIDECURSOR=0
export QML2_IMPORT_PATH=$QT_INSTALL_PATH/qml
export QT_QPA_PLATFORM_PLUGIN_PATH=$QT_INSTALL_PATH/plugins
unset QT_QPA_EGLFS_INTEGRATION
unset QT_QPA_GENERIC_PLUGINS

HldDistributorService=/home/ins/HLD_PRODUCT_NAME/HLDBridge/HldDistributorService/
export LD_LIBRARY_PATH=${HldDistributorService}/lib:$LD_LIBRARY_PATH
pnginysh=`ps -ef | grep "start_hlddistributorservice.sh" | grep -v "grep" | wc -l`
if [ $pnginysh -ne 2 ]; then
	echo $pnginysh
        echo "start_hlddistributorservice.sh is start"
	exit 0
fi
	echo $pnginysh
        echo "start start_hlddistributorservice.sh"
sleep 3
LOG_FILE="autostart_hlddistributorservice"
curtime=$(date "+%Y-%m-%d %H:%M:%S")
while true
do
        pnginy=`ps -ef | grep "HldDistributorService" | grep -v "grep" | wc -l`
	if [ $pnginy -eq 0 ]; then
                echo "$curtime HldDistributorService is Not Run,Starting....">/dev/null 2>&1
                cd    ${HldDistributorService}
                sudo ./run_HldDistributorService.sh
	else 
                echo "$curtime HldDistributorService is Started">/dev/null 2>&1
	fi
	sleep 1
done
exit 0
