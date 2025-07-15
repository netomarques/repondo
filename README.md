# 🧺 Repondo

**Repondo** é um aplicativo Flutter para controle de despensa e lista de compras. Ele permite organizar os itens disponíveis, planejar compras futuras, registrar históricos de uso e acompanhar reposições de forma prática. Com suporte a múltiplos usuários, o app facilita o gerenciamento compartilhado da despensa e evita esquecimentos ou compras duplicadas.

---

### ⚙️ Funcionalidades

#### ✅ Implementadas

##### 🔐 Autenticação
- Login com e-mail e senha
- Cadastro de novo usuário
- Logout
- Autenticação persistente (usuário continua logado após reiniciar o app)

---

#### 🚧 Em desenvolvimento / planejadas

##### 🧺 Despensas
- Criar despensa com nome
- Gerar código de convite único
- Entrar em despensa via código
- Listar despensas do usuário
- Adicionar usuário como admin ao criar a despensa

##### 🧑‍🤝‍🧑 Membros
- Listar membros da despensa
- Mostrar quem adicionou determinado item
- Remover membro da despensa

##### 📦 Itens da despensa
- Adicionar item com nome, quantidade, unidade e categoria
- Editar e excluir itens
- Listar todos os itens da despensa

##### 🛒 Lista de compras
- Adicionar item da despensa à lista de compras
- Definir prioridade e quantidade (opcional)
- Listar itens da lista de compras
- Remover ou marcar item como comprado

##### 📜 Histórico
- Registrar ação ao adicionar item à despensa
- Registrar ações na lista de compras (adição, remoção, compra)
- Exibir histórico por item ou geral

##### 🎨 Apresentação (UI)
- Tela de login
- Tela de home com lista de despensas
- Tela da despensa com itens e botão para lista de compras
- Tela da lista de compras
- Layout simples, responsivo e funcional

---

### 🧱 Estrutura do Projeto

O Repondo segue uma arquitetura baseada em **Clean Architecture**, **MVVM** e princípios **SOLID**, com separação clara entre camadas e organização por funcionalidades (features). Isso facilita a escalabilidade, testabilidade e manutenibilidade do projeto.

---

#### 📁 Estrutura geral (`lib/`)

```
lib/
├── app.dart                    # Inicialização do app
├── main.dart                   # Entry point
├── config/                     # Configurações gerais e de navegação
│   ├── navigator/
│   └── router/
├── core/                       # Utilitários, serviços compartilhados e abstrações
│   ├── constants/              # Constantes globais
│   ├── exceptions/             # Exceções customizadas
│   ├── firebase/               # Utils de Firestore e Auth
│   ├── log/                    # AppLogger, Crashlytics, DebugLogger
│   ├── mappers/                # Conversores entre modelos e entidades
│   └── result/                 # Result<T>, helpers e extensões
└── features/                   # Funcionalidades separadas por módulo
```

---

#### 📦 Organização por Features

Cada feature segue o padrão de camadas:

```
features/
└── nome_da_feature/
    ├── domain/           # Entidades, contratos e regras de negócio puras
    ├── data/             # Repositórios concretos, mappers e chamadas externas
    ├── application/      # Usecases, facades e providers
    └── presentation/     # Notifiers, páginas, widgets e lógica de UI
```

---

#### 📌 Exemplo: estrutura da feature `auth`

```
features/auth/
├── domain/
│   ├── entities/
│   ├── repositories/
│   └── exceptions/
├── data/
│   ├── mappers/
│   └── repositories/
├── application/
│   ├── usecases/ (email_auth, google_auth)
│   ├── facades/
│   └── providers/
└── presentation/
    ├── notifiers/
    ├── pages/
    ├── router/
    ├── validators/
    └── widgets/
```

Outras funcionalidades do app (como `despensa`, `lista_compras`, `historico`, `notificacoes`) seguem a mesma estrutura.

---

### 🧪 Testes

Este projeto segue o princípio de **TDD (Test Driven Development)**, com testes automatizados implementados desde a camada de domínio.

#### 📁 Organização dos testes

Os testes são organizados respeitando a arquitetura em camadas:

```
test/
└── features/
    └── nome_da_feature/
        ├── domain/           # Testes de entidades e contratos
        ├── data/             # Testes de repositórios, models, mappers (com mocks)
        ├── application/      # Testes de usecases
        └── presentation/     # Testes de notifiers e UI
```

#### 🔧 Ferramentas utilizadas

- `flutter_test`: para execução dos testes unitários
- `mockito`: para criação de mocks e validação de chamadas
- `build_runner`: para gerar mocks automaticamente (via `@GenerateMocks`)
- `coverage`: para medir a cobertura de testes (opcional)

#### 🚀 Como rodar os testes

```bash
flutter test
```

> Dica: você pode adicionar `flutter pub run build_runner build` para regenerar os mocks sempre que necessário.
