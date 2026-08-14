# ubmc-resourcepack

Resource pack da rede UBMC — hoje só as tags de rank (imagem customizada ao lado do prefixo do
LuckPerms), pensado pra crescer com mais coisa cosmética no futuro sem precisar reestruturar nada.

Os arquivos-fonte de verdade (editáveis) ficam versionados aqui no repo, não só um zip pronto — assim
dá pra ver o histórico de mudança, revisar diff de uma tag nova, e voltar atrás se algo quebrar.

## Como o servidor usa isso

O servidor (`server.properties` do lobby) aponta pra um **link direto de um asset de release** deste
repo (não pro repo em si) + o hash SHA1 desse arquivo exato. O Minecraft baixa esse zip sozinho no
login do jogador, sem instalação manual. Toda vez que o conteúdo muda, precisa gerar uma release nova
(não dá pra sobrescrever o arquivo de uma release já publicada - o hash mudaria e o link ficaria
inválido).

## Estrutura

```
assets/minecraft/font/default.json        -- mapeia cada textura pra um caractere Unicode de uso privado
assets/minecraft/textures/font/tags/*.png -- as texturas em si (uma por tag/rank)
pack.mcmeta                               -- metadado padrão de resource pack do Minecraft
build.sh                                  -- gera o ubmc-resourcepack.zip a partir destes arquivos
```

## Mapeamento atual (tag → textura → caractere)

| Rank/tag | Arquivo | Caractere (uso privado) |
|---|---|---|
| owner | `tags/owner.png` | `U+E201` |
| admin | `tags/admin.png` | `U+E202` |
| manager | `tags/manager.png` | `U+E203` |
| mod | `tags/mod.png` | `U+E204` |
| builder | `tags/builder.png` | `U+E205` |
| vip | `tags/vip.png` | `U+E206` |
| youtuber | `tags/youtuber.png` | `U+E207` |
| member | `tags/member.png` | `U+E208` |

A faixa `U+E000`–`U+F8FF` é a "Área de Uso Privado" do Unicode - reservada justamente pra isso, nunca
vai colidir com nenhum caractere real do jogo. Continue a partir de `U+E209` pra uma tag nova.

O caractere em si fica embutido literalmente no prefixo do LuckPerms (`/lp group <grupo> meta
setprefix ...`), colado junto com o texto/cor normal do prefixo - ele é invisível em qualquer editor
de texto comum, mas está lá.

## Como adicionar uma tag nova

1. Exporte a imagem nova (mesmo tamanho/proporção das existentes - hoje `ascent: 7, height: 9`) e
   salve em `assets/minecraft/textures/font/tags/<nome>.png`.
2. Adicione uma entrada em `assets/minecraft/font/default.json`, seguindo o padrão das outras, com o
   **próximo** caractere livre da tabela acima (ex: `U+E209` se a última usada foi `E208`).
3. Rode `./build.sh` - gera `ubmc-resourcepack.zip` e mostra o SHA1 dele.
4. Publique uma release nova: `gh release create vX.Y.Z ubmc-resourcepack.zip --title "..." --notes
   "..."` (versão sempre nova, nunca reaproveitar uma já publicada).
5. Atualize `resource-pack` (URL do novo asset) e `resource-pack-sha1` (hash novo) no
   `server.properties` do lobby, e o comando `/lp group <grupo> meta setprefix` com o caractere novo
   embutido no texto certo.
6. Reinicie o servidor do lobby pra ele oferecer o pack novo aos jogadores.

## Versão atual

`v1.0.0` - as 8 tags de rank originais (owner/admin/manager/mod/builder/vip/youtuber/member), extraídas
de imagens feitas em nogard.dev.
