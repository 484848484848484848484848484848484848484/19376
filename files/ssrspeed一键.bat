@echo off&
echo ##### �����ssrspeedĿ¼������ #####
echo.
:start
echo 1����ʼ����
echo 2����װpip
echo ��ѡ��1/2����
choice /c 12
if %errorlevel%==2 (goto :pip)
if %errorlevel%==1 (goto :test)

:pip
python -m pip install --upgrade pip
pip3 install -r requirements.txt
pip3 install pillow
pip3 install requests
pip3 install pysocks
pause
&& goto :start

:test
set /p a=���������Ķ�������:
if "%a%"=="" (
goto :test
) else (
python main.py -u "%a%"
)
pause