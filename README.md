# BootcampDAO 🗳️

Sistema de votação descentralizado (DAO) desenvolvido em Move para a blockchain Sui.

## 📋 Sobre o Projeto

Este contrato permite criar propostas e votar de forma descentralizada na blockchain Sui. Desenvolvido como projeto do bootcamp de Move.

### Funcionalidades

- ✅ Criar propostas com título e descrição
- ✅ Votar a favor ou contra
- ✅ Encerrar votação (apenas o criador)
- ✅ Eventos emitidos para todas as ações
- ✅ Proteção contra voto duplicado

---

## 🚀 Deploy

### Testnet
| Info | Valor |
|------|-------|
| **Package ID** | `0xbe2bebf0da9a3a16bb89307e300ff4b724e473efab4836be9948f6e81111e4dd` |
| **Rede** | Sui Testnet |
| **Explorer** | [Ver no SuiVision](https://testnet.suivision.xyz/package/0xbe2bebf0da9a3a16bb89307e300ff4b724e473efab4836be9948f6e81111e4dd) |

---

## 📦 Estrutura do Contrato

### Struct: Proposal
```move
public struct Proposal has key {
    id: UID,
    title: String,
    description: String,
    creator: address,
    votes_for: u64,
    votes_against: u64,
    voters: vector<address>,
    is_active: bool,
}
```

### Eventos
- `ProposalCreated` - Emitido quando uma proposta é criada
- `VoteCast` - Emitido quando alguém vota
- `ProposalClosed` - Emitido quando a votação é encerrada

---

## 🧪 Instruções de Teste

### Pré-requisitos
1. Ter a CLI do Sui instalada
2. Configurar a testnet:
```bash
sui client new-env --alias testnet --rpc https://fullnode.testnet.sui.io:443
sui client switch --env testnet
```
3. Pegar tokens de teste em: https://faucet.sui.io/

### 1. Criar uma Proposta
```bash
sui client call \
  --package 0xbe2bebf0da9a3a16bb89307e300ff4b724e473efab4836be9948f6e81111e4dd \
  --module bootcampdao \
  --function create_proposal \
  --args "Minha Proposta" "Descrição da proposta de teste" \
  --gas-budget 10000000
```

**Retorno esperado:** O evento `ProposalCreated` será emitido com o `proposal_id`.

### 2. Votar em uma Proposta
```bash
# Votar A FAVOR (true)
sui client call \
  --package 0xbe2bebf0da9a3a16bb89307e300ff4b724e473efab4836be9948f6e81111e4dd \
  --module bootcampdao \
  --function vote \
  --args <PROPOSAL_ID> true \
  --gas-budget 10000000

# Votar CONTRA (false)
sui client call \
  --package 0xbe2bebf0da9a3a16bb89307e300ff4b724e473efab4836be9948f6e81111e4dd \
  --module bootcampdao \
  --function vote \
  --args <PROPOSAL_ID> false \
  --gas-budget 10000000
```

**Retorno esperado:** O evento `VoteCast` será emitido.

### 3. Encerrar uma Proposta
> ⚠️ Apenas o criador da proposta pode encerrá-la.

```bash
sui client call \
  --package 0xbe2bebf0da9a3a16bb89307e300ff4b724e473efab4836be9948f6e81111e4dd \
  --module bootcampdao \
  --function close_proposal \
  --args <PROPOSAL_ID> \
  --gas-budget 10000000
```

**Retorno esperado:** O evento `ProposalClosed` será emitido com o resultado (`passed: true/false`).

---

## 🔍 Ler Dados do Objeto

### Ver detalhes de uma Proposta
```bash
sui client object <PROPOSAL_ID>
```

### Ver com formato JSON
```bash
sui client object <PROPOSAL_ID> --json
```

### Exemplo de saída:
```json
{
  "objectId": "0x...",
  "content": {
    "type": "0xbe2bebf0da9a3a16bb89307e300ff4b724e473efab4836be9948f6e81111e4dd::bootcampdao::Proposal",
    "fields": {
      "title": "Minha Proposta",
      "description": "Descrição da proposta",
      "creator": "0x93da...",
      "votes_for": 5,
      "votes_against": 2,
      "is_active": true
    }
  }
}
```

### Listar seus objetos
```bash
sui client objects
```

### Buscar propostas criadas (via eventos)
```bash
sui client events --query '{"MoveEventType": "0xbe2bebf0da9a3a16bb89307e300ff4b724e473efab4836be9948f6e81111e4dd::bootcampdao::ProposalCreated"}'
```

---

## 🛠️ Compilar e Deploy Local

### Compilar
```bash
cd bootcampdao
sui move build
```

### Testar (se houver testes)
```bash
sui move test
```

### Deploy
```bash
sui client publish --gas-budget 100000000
```

---

## 📚 Conceitos Move Utilizados

- **Shared Objects** - Propostas são compartilhadas para todos interagirem
- **Events** - Emissão de eventos para rastreamento off-chain
- **Vectors** - Armazenamento da lista de votantes
- **Entry Functions** - Funções chamáveis diretamente via transação
- **Assertions** - Validações com códigos de erro personalizados

---

## 🔗 Links Úteis

- [Sui Documentation](https://docs.sui.io/)
- [Move Language Book](https://move-language.github.io/move/)
- [Sui Explorer (Testnet)](https://testnet.suivision.xyz/)
- [Sui Faucet](https://faucet.sui.io/)

---

## 📄 Licença

MIT License
