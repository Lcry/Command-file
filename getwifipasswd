#windows下查看已经连接的wifi信息
#win+R运行命令行输入以下命令即可
for /f "skip=9 tokens=1,2 delims=:" %i in ('netsh wlan show profiles') do  @echo %j | findstr -i -v echo | netsh wlan show profiles %j key=clear
