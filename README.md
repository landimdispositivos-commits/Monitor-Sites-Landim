# Monitor de sites (Landim)

Verifica a cada 5 minutos, **de fora da VPS** (GitHub Actions), se os sites respondem:

- Wallet Dash — https://walletdash.landim.net.br
- LPZ Training — https://lpztraining.landim.net.br
- n8n — https://n8n.landim.net.br

## Como avisa

- Site fora do ar (3 tentativas seguidas sem resposta): abre uma **issue** com a etiqueta `fora-do-ar`, e o GitHub envia **e-mail**.
- Quando volta: comenta o horário e o tempo fora, fecha a issue e o GitHub envia outro e-mail.
- O histórico de quedas fica nas issues fechadas (útil para chamados na hospedagem).

## Manutenção

- **Incluir/remover site:** edite `sites.txt` (uma linha `nome|endereço`).
- **Testar o alerta:** Actions → Monitor de sites → Run workflow → marque "Simular um site fora do ar". A próxima execução normal fecha o alerta.
- **Pausar:** Actions → Monitor de sites → ⋯ → Disable workflow.
- O repositório é público para o GitHub Actions ser gratuito com essa frequência; contém só endereços públicos, sem senhas.
- O GitHub desativa agendamentos após 60 dias sem commits; o próprio monitor faz um commit de renovação a cada 45 dias.
