#!/usr/bin/env bash
# Gera ubmc-resourcepack.zip a partir dos arquivos-fonte deste repo (pack.mcmeta + assets/) e
# imprime o SHA1 - copie esse hash pro resource-pack-sha1 do server.properties do lobby.
set -euo pipefail
cd "$(dirname "$0")"

rm -f ubmc-resourcepack.zip
# Nem "zip" (ausente neste ambiente) nem o Compress-Archive do PowerShell servem aqui - o
# PowerShell grava separador \ nas entradas (confirmado testando), que o leitor de zip do Java
# (usado pelo cliente Minecraft) não reconhece como pasta - quebra silenciosamente o resource
# pack. O "jar" do JDK usa o mesmo java.util.zip que o próprio Minecraft, sempre grava com /.
JAR="/c/Program Files/Eclipse Adoptium/jdk-25.0.3.9-hotspot/bin/jar.exe"
"$JAR" cfM ubmc-resourcepack.zip pack.mcmeta assets

echo ""
echo "Gerado: ubmc-resourcepack.zip"
sha1sum ubmc-resourcepack.zip
