LAMP - Linux - Apache - MySQL - PHP
=======================================

Versões utilizadas
----------------------

- PHP 7.4
- MySQL 8.0

Como montar o ambiente
----------------------

- Clonar o repositório para o ambiente local
- Acessar o repositório

```bash
cd docker-lamp
```

- Definir que o Git ignore a alteração das permissões dos arquivos

```bash
git config core.fileMode false
```

- Montar o container Docker

```bash
docker-compose up -d
```
