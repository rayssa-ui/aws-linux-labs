# Comandos tee, sort, cut e sed 🛠️

## Descrição
Manipulação de texto e arquivos com comandos Linux avançados.

## Comando tee
```bash
hostname | tee file1.txt               # exibe e salva ao mesmo tempo
```

## Comando sort
```bash
sort test.csv                          # ordena arquivo alfabeticamente
```

## Comando cut
```bash
cut -d ',' -f 1 cities.csv            # extrai primeiro campo separado por vírgula
```

## Comando sed
```bash
sed -i 's/,/./' cities.csv            # substitui primeira vírgula por ponto
sed -i 's/,/./' test.csv              # substitui primeira vírgula por ponto
```

## Pipe (|)
```bash
find | grep Paris test.csv             # busca "Paris" no arquivo
sudo ps -aux | grep -v root            # filtra processos sem root
```

## Exemplos práticos
```bash
cat > test.csv                         # cria arquivo e digita conteúdo
CTRL+D                                 # salva e sai do cat
cat test.csv                           # exibe conteúdo do arquivo
```
