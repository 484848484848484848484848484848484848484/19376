@echo off&
echo.
echo ##### 请放在SSRSpeed目录下运行 #####
echo.
if exist "%~dp0\main.py" (python main.py --version>ver.txt && for /f "delims=" %%i in (ver.txt) do ( set ver=%%i ) && echo 已在SSRSpeed目录下，欢迎使用 && echo 当前版本%%i && del ver.txt) else (echo 请放在SSRSpeed目录下运行！ )
if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0
bcdedit >nul
if '%errorlevel%' NEQ '0' (echo 当前无管理员权限) else (echo 当前已获取管理员权限)
if exist "%~dp0\clients\v2ray-core\v2ray.exe" ( set v1=1 ) else ( set v1=0 )
if exist "%~dp0\clients\v2ray-core\v2ctl.exe" ( set v2=1 ) else ( set v2=0 )
set /a v3=v1+v2
if %v3%==2 (echo 已安装V2ray-core ) else (echo 未安装V2ray-core )
:start
echo ====================================
echo 1：开始测速（默认设置）
echo 2：开始测速（自定义设置）
echo 3：使用Web UI
echo 4：首次运行前安装pip和相关支持（需要管理员权限）
echo 5：通过JSON结果导出图像结果
echo 6：参数查阅
echo 7：当前SSRSpeed版本
echo 8：你很厉害，想全部自己输入
echo 9：为本次运行获取管理员权限
echo ====================================
echo 请选择（1~9）：
choice /c 123456789
if %errorlevel%==9 (goto :uac)
if %errorlevel%==8 (goto :write)
if %errorlevel%==7 (goto :ver)
if %errorlevel%==6 (goto :help)
if %errorlevel%==5 (goto :json)
if %errorlevel%==4 (goto :pip)
if %errorlevel%==3 (goto :web)
if %errorlevel%==2 (goto :test2)
if %errorlevel%==1 (goto :test1)

:pip
if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0
bcdedit >nul
if '%errorlevel%' NEQ '0' (echo #当前无管理员权限，无法安装。 && echo. && echo #您可以通过命令9获取权限，或右键以管理员权限启动。 && pause && goto :start) else (goto :pip2)
:pip2
python -m pip install --upgrade pip
pip3 install -r %~dp0%\requirements.txt
::pip3 install requests
::pip3 install pyyaml
::pip3 install Pillow
::pip3 install pysocks
::pip3 install aiohttp
::pip3 install aiohttp_socks
::pip3 install requests[socks]
::pip3 install flask
::pip3 install flask-cors
pause
goto :start

:write
set /p a=开头内容“python main.py ”已给出，剩下的参数自己写:
python main.py %a%
pause
EXIT

:test1
set /p a=请输入您的订阅链接:
if "%a%"=="" (
goto :test1
) else (
python main.py -u "%a%"
)
pause
set a=
EXIT

:web
start python web.py
ping -n 5 127.0.0.1>nul && start http://127.0.0.1:10870/
pause
goto :start

:json
if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0
bcdedit >nul
if '%errorlevel%' NEQ '0' (goto :json2) else (echo #注意：当前已获取管理员权限，无法通过拖拽JSON文件获取路径 && goto :json2)
:json2
set /p j=请把JSON文件拖到本窗口或输入JSON文件路径，并回车:
python main.py -i "%j%"
pause
goto :start

:ver
python main.py --version
pause
goto :start

:help
echo.
echo 1：原文（en）
echo 2：翻译（zh）
choice /c 12
if %errorlevel%==2 (goto :fy)
if %errorlevel%==1 (goto :yw)

:yw

echo.
echo Usage: main.py [options] arg1 arg2...
echo.
echo Options:
echo.
echo  --version                              show program's version number and exit
echo  -h, --help                             show this help message and exit
echo  -c GUICONFIG, --config=GUICONFIG       Load config generated by shadowsocksr-csharp.
echo  -u URL, --url=URL                      Load ssr config from subscription url.
echo  -m TEST_METHOD, --method=TEST_METHOD   Select test method in Select test method in [speedtestnet, fast, socket, stasync].
echo  -M TEST_MODE, --mode=TEST_MODE         Select test mode in [all,pingonly,wps].
echo  --include                              Filter nodes by group and remarks using keyword.
echo  --include-remark                       Filter nodes by remarks using keyword.
echo  --include-group                        Filter nodes by group name using keyword.
echo  --exclude                              Exclude nodes by group and remarks using keyword.
echo  --exclude-group                        Exclude nodes by group using keyword.
echo  --exclude-remark                       Exclude nodes by remarks using keyword.
echo  --use-ssr-cs                           Replace the ShadowsocksR-libev with the ShadowsocksR-C# (Only Windows)
echo  -g GROUP                               Manually set group.
echo  -y, --yes                              Skip node list confirmation before test.
echo  -C RESULT_COLOR, --color=RESULT_COLOR  Set the colors when exporting images..
echo  -S SORT_METHOD, --sort=SORT_METHOD     Select sort method in [speed,rspeed,ping,rping],default not sorted.
echo  -i IMPORT_FILE, --import=IMPORT_FILE   Import test result from json file and export it.
echo  --skip-requirements-check              Skip requirements check.
echo  --debug                                Run program in debug mode.
echo.
echo  Test Modes
echo  Mode                 Remark
echo  TCP_PING             Only tcp ping, no speed test
echo  WEB_PAGE_SIMULATION  Web page simulation test
echo  ALL                  Full speed test (exclude web page simulation)
echo.
echo  Test Methods
echo  Methods              Remark
echo  ST_ASYNC             Asynchronous download with single thread
echo  SOCKET               Raw socket with multithreading
echo  SPEED_TEST_NET       Speed Test Net speed test
echo  FAST                 Fast.com speed test
echo.
pause
goto :start

:fy

echo.
echo 用法：main.py [options] arg1 arg2...
echo.
echo 选项：
echo.
echo  --version                               显示程序的版本号并退出
echo  -h，--help                              显示此帮助消息并退出
echo  -c GUICONFIG，--config = GUICONFIG      加载由shadowsocksr-csharp生成的配置。
echo  -u URL，--url = URL                     从订阅URL加载ssr配置。
echo  -m TEST_METHOD，--method = TEST_METHOD  在[speedtestnet,fast,socket,stasync]中选择测试方法。
echo  -M TEST_MODE，--mode = TEST_MODE        在[all,pingonly,wps]中选择测试模式。
echo  --include                               按组过滤节点，并使用关键字注释。
echo  --include-remark                        使用关键字通过注释过滤节点。
echo  --include-group                         使用关键字按组名过滤节点。
echo  --exclude                               按组排除节点，并使用关键字进行注释。
echo  --exclude-group                         使用关键字按组排除节点。
echo  --exclude-remark                        通过使用关键字的注释排除节点。
echo  --use-ssr-cs                            用ShadowsocksR-C＃替换ShadowsocksR-libev（仅Windows）
echo  -g GROUP                                手动设置组。
echo  -y，--yes                               测试前跳过节点列表确认。
echo  -C RESULT_COLOR，--color = RESULT_COLOR 导出图像时设置颜色。
echo  -S SORT_METHOD，--sort = SORT_METHOD    在[speed,rspeed,ping,rping]中选择排序方法，默认不排序。
echo  -i IMPORT_FILE，--import = IMPORT_FILE  从json文件导入测试结果并导出。
echo  -skip-requirements-check                跳过要求检查。
echo  --debug                                 在调试模式下运行程序。
echo.
echo  测试模式
echo  模式                 备注
echo  TCP_PING             仅tcp ping，无速度测试
echo  WEB_PAGE_SIMULATION  网页模拟测试
echo  ALL                  全速测试（不包括网页模拟）
echo.
echo  测试方法
echo  方法                 备注
echo  ST_ASYNC             单线程异步下载
echo  SOCKET               具有多线程的原始套接字
echo  SPEED_TEST_NET       SpeedTest.Net速度测试
echo  FAST                 Fast.com速度测试
echo.
pause
goto :start

:test2
echo.
echo      以下选项较多(15个)，如有不懂或需要跳过，直接留空回车即可
echo.
:test3
set /p a=请输入您的订阅链接(不可留空):
if "%a%"=="" (
goto :test3
) else (
goto :jx1
)
:jx1
set /p b=1.在[speedtestnet,fast,socket,stasync]中选择输入测试方法:
set /p c=2.在[all,pingonly,wps]中选择输入测试模式:
echo      以下[3-8]项可以通过空格分隔关键词
ping -n 2 127.0.0.1>nul && set /p d=3.按组过滤节点，并使用关键字注释:
set /p e=4.使用关键字通过注释过滤节点:
set /p f=5.使用关键字按组名过滤节点:
set /p g=6.按组排除节点，并使用关键字进行注释:
set /p h=7.使用关键字按组排除节点:
set /p i=8.通过使用关键字的注释排除节点:
set /p j=9.用ShadowsocksR-C＃替换ShadowsocksR-libev(任意输入确定):
set /p k=10.手动设置组:
set /p l=11.测试前跳过节点列表确认(任意输入确定):
set /p m=12.导出图像时设置颜色[origin,chunxiaoyi]:
set /p n=13.在[speed,rspeed,ping,rping]中选择输入排序方法，默认不排序，如默认请跳过:
set /p o=14.跳过要求检查(任意输入确定):
set /p p=15.在调试模式下运行程序(任意输入确定):
echo.
if "%b%"=="" (
set b= && goto :jx2
) else (
set b=-m %b% && goto :jx2
)
:jx2
if "%c%"=="" (
set c= && goto :jx3
) else (
set c=-M %c% && goto :jx3
)
:jx3
if "%d%"=="" (
set d= && goto :jx4
) else (
set d=--include %d% && goto :jx4
)
:jx4
if "%e%"=="" (
set e= && goto :jx5
) else (
set e=--include-remark %e% && goto :jx5
)
:jx5
if "%f%"=="" (
set f= && goto :jx6
) else (
set f=--include-group %f% && goto :jx6
)
:jx6
if "%g%"=="" (
set g= && goto :jx7
) else (
set g=--exclude %g% && goto :jx7
)
:jx7
if "%h%"=="" (
set h= && goto :jx8
) else (
set h=--exclude-group %h% && goto :jx8
)
:jx8
if "%i%"=="" (
set i= && goto :jx9
) else (
set i=--exclude-remark %i% && goto :jx9
)
:jx9
if "%j%"=="" (
set j= && goto :jx10
) else (
set j=--use-ssr-cs && goto :jx10
)
:jx10
if "%k%"=="" (
set k= && goto :jx11
) else (
set k=-g %k% && goto :jx11
)
:jx11
if "%l%"=="" (
set l= && goto :jx12
) else (
set l=-y && goto :jx12
)
:jx12
if "%m%"=="" (
set m= && goto :jx13
) else (
set m=-C %m% && goto :jx13
)
:jx13
if "%n%"=="" (
set n= && goto :jx14
) else (
set n=-S %n% && goto :jx14
)
:jx14
if "%o%"=="" (
set o= && goto :jx15
) else (
set o=-skip-requirements-check && goto :jx15
)
:jx15
if "%p%"=="" (
set p= && goto :jx16
) else (
set p=--debug && goto :jx16
)
:jx16
echo python main.py -u "%a%" %b% %c% %d% %e% %f% %g% %h% %i% %j% %k% %l% %m% %n% %o% %p%
echo.
python main.py -u "%a%" %b% %c% %d% %e% %f% %g% %h% %i% %j% %k% %l% %m% %n% %o% %p%
pause
set a=
set b=
set c=
set d=
set e=
set f=
set g=
set h=
set i=
set j=
set k=
set l=
set m=
set n=
set o=
set p=
goto :start

:uac
echo.
if exist "%SystemRoot%\SysWOW64" path %path%;%windir%\SysNative;%SystemRoot%\SysWOW64;%~dp0
bcdedit >nul
if '%errorlevel%' NEQ '0' (goto UACPrompt) else (goto UACAdmin)
:UACPrompt
echo 提示：通用依赖安装需要管理员权限（命令4）
echo.
echo      尝试获取管理员权限，程序将重启
ping -n 3 127.0.0.1>nul && %1 start "" mshta vbscript:createobject("shell.application").shellexecute("""%~0""","::",,"runas",1)(window.close)&exit
exit /B
:UACAdmin
cd /d "%~dp0"
echo.
echo 已获取管理员权限
echo.
pause
goto :start