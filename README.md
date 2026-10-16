# my-skills

Biblioteca central de skills para agentes de IA, inspirada na **estrutura** de https://github.com/akitaonrails/my-skills — sem copiar nenhuma skill.

## Princípios

- Um único repositório Git como fonte das suas skills.
- Estrutura plana: no futuro, uma pasta por skill diretamente na raiz, contendo `SKILL.md`.
- Compartilhamento por symlinks **individuais**; cada agente mantém sua pasta `skills/` real.
- Skills nativas, plugins e skills privadas ficam separados.
- Não armazenar segredos, tokens, credenciais, histórico, vault pessoal ou dados de clientes neste repositório público.
- Operação idempotente e não destrutiva: jamais sobrescrever entradas existentes nos agentes.

## Estrutura inicial (nenhuma skill)

```text
my-skills/
├── README.md
├── .gitignore
└── scripts/
    └── link-skills.sh
```

O Git não versiona pastas vazias; nenhuma pasta de skill é criada agora.

## Estrutura futura (somente quando você decidir criar skills)

```text
my-skills/
└── nome-da-skill/
    ├── SKILL.md
    ├── references/     # opcional
    ├── scripts/        # opcional
    └── assets/         # opcional
```

## Distribuição

A rotina `scripts/link-skills.sh` reconhece quatro destinos:

| Agente | Diretório |
| --- | --- |
| Codex | `~/.codex/skills` |
| Claude Code | `~/.claude/skills` |
| OpenCode | `~/.config/opencode/skills` |
| Compartilhado | `~/.agents/skills` |

Ela procura exclusivamente diretórios de primeiro nível com `SKILL.md`, ignorando `scripts/` e outras pastas de suporte. Não instala dependências e não altera o conteúdo das skills.

### Como usar

```sh
git clone https://github.com/vonderheidon/my-skills.git ~/Projects/my-skills
cd ~/Projects/my-skills
bash scripts/link-skills.sh          # prévia: somente mostra ações
bash scripts/link-skills.sh --apply  # aplica; não substitui existentes
```

Sem skills, ambos os comandos não alteram nada. Ao adicionar a primeira skill no futuro, rode `--apply` novamente e reinicie os agentes para detectá-la.

**Contêiner:** rode o script no sistema de arquivos onde cada agente executa. Se você montar o repositório no contêiner, os caminhos dos symlinks devem apontar para um caminho existente *dentro* dele. Evite substituir os diretórios dos agentes por um symlink único.

**Separação de responsabilidades:** `my-skills` contém procedimentos; o AI Memory guarda o histórico técnico dos agentes; o vault guarda conhecimento e tarefas; `AGENTS.md` define limites e regras contextuais.
