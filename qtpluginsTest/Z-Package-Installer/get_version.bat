@echo off
setlocal

rem 获取当前 git 哈希值
rem  for /f "delims=" %%G in ('git rev-parse HEAD 2^>nul') do set "git_hash=%%G"
for /f "delims=" %%G in ('git rev-parse --short HEAD 2^>nul') do set "git_hash=%%G"

rem 如果获取失败，使用默认哈希值
if "%git_hash%" == "" set "git_hash=default"

rem 拼接版本号字符串
set "version_string=#define CLIENT_VERSION  "%1.%git_hash%""

rem 写入文件
echo %version_string% > file_ver.h

echo 文件 file_ver.h 创建成功，内容为：%version_string%
rem  pause
