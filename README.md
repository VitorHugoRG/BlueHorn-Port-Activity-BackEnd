# ⚙️ BlueHorn - Backend

Backend da aplicação BlueHorn, desenvolvido em C# com ASP.NET Core.

## 🚀 Tecnologias
- ASP.NET Core
- Entity Framework
- PostgreSQL

## 📦 Como rodar localmente

1. Clone o repositório

```bash
git clone https://github.com/VitorHugoRG/BlueHorn-Port-Activity-Back.git
cd BlueHorn-Port-Activity-Back
```

Configure o arquivo .env com as variáveis abaixo:

```bash
DB_HOST=localhost
DB_PORT=5432
DB_USER=postgres
DB_PASS=postgres
DB_NAME=bluehorn
```

Instale as dependências e rode o projeto:

```bash
dotnet restore
dotnet run
```

 Importe o banco de dados:

```bash
psql -U postgres -d bluehorn -f ./database/schema.sql
```
