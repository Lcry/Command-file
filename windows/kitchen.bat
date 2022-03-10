#列出资源库目录：
.\Kitchen.bat /rep 资源库名 /user 资源库用户 /pass 资源库密码 /listdir

#列出某个目录下的所有作业（方便访问资源库的时候调用作业）
.\Kitchen.bat /rep 资源库名 /user 资源库用户 /pass 资源库密码 /dir 资源库某个目录名 /listjobs

#不使用资源库bat:作业1.bat
C:
cd C:\data-integration
set sec=%TIME:~3,2%%TIME:~6,2%
Set h=%TIME:~0,2%
If %h% leq 9 (Set h=0%h:~1,1%) else (Set h=%h%)
Kitchen.bat /file:C:\Users\Administrator\Desktop\测试作业.kjb /level:Basic>>C:\Users\Administrator\Desktop\测试作业日志_%date:~0,4%%date:~5,2%%date:~8,2%_%h%%sec%.log

#使用资源库bat：作业2.bat
C:
cd C:\data-integration
set sec=%TIME:~3,2%%TIME:~6,2%
Set h=%TIME:~0,2%
If %h% leq 9 (Set h=0%h:~1,1%) else (Set h=%h%)
Kitchen.bat /rep ziyuanku /user admin /pass admin /job 测试作业 /dir 测试1 /level:Basic>>C:\Users\Administrator\Desktop\测试作业日志_%date:~0,4%%date:~5,2%%date:~8,2%_%h%%sec%.log

#如果需要一次调度多个作业需要编写list.bat：
@ echo off
call C:\Users\Administrator\Desktop\BAT\作业1.bat
call C:\Users\Administrator\Desktop\BAT\作业2.bat
call C:\Users\Administrator\Desktop\BAT\作业3.bat
