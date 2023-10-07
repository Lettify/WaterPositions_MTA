![Imagem demonstração](https://i.imgur.com/Cvy6Stx.png)
# Como usar?
Logo abaixo está algumas dicas úteis de como usar este script. Aqui vai um pequeno sumário:
- [Permissões](https://github.com/Lettify/WaterPositions_MTA/blob/master/README.md#permiss%C3%B5es)
- [Comandos](https://github.com/Lettify/WaterPositions_MTA/blob/master/README.md#comandos)
- [Demonstração](https://github.com/Lettify/WaterPositions_MTA/blob/master/README.md#demonstra%C3%A7%C3%A3o)

## Permissões
- Para poder utilizar o comando `/watergen`, é necessário ter a permissão da ACL **command.watergen**.
- Este comando tem sub-comandos que também só conseguem ser usados se tiver a permissão ou a depender da situação.

### Como ter a permissão para executar o comando?
O passo a passo a seguir mostra como você pode ter ou dar a permissão `command.watergen`.
1. Abra o painel **admin**, na aba **Resources** clique em `Manage ACL`
![Manage ACL Click](https://i.imgur.com/P7HwY9P.png)
2. Na lista à esquerda, na seção **ACL** procure pela ACL que quer dar a permissão ou então crie uma. Então clique duas vezes na ACL que quer adicionar a permissão para expandir as permissões nela, no exemplo usei a ACL **Admin**.
![Admin ACL](https://i.imgur.com/ShGeUod.png)
3. Ao selecionar a ACL que vai dar a permissão, clique em `Add Right` à direita para poder adicionar a permissão nela.
![Add Right Click](https://i.imgur.com/ndM414e.png)
4. Quando clicar no botão do passo anterior, vai aparecer esta janela com um campo para você especificar a permissão que quer adicionar, então só digitar `command.watergen` e depois só clicar em `Ok`.
![Add permission](https://i.imgur.com/5HCSYdA.png)

## Comandos
- `/watergen` - O principal comando e o comando para iniciar o sistema. Ao executar, aparece em sua tela um indicador mostrando que o script está detectando seus comandos, então só seguir conforme a mensagem chega no seu chat.
- `/watergen cancelar` - Cancela todo o processo de geração das posições.
- `/watergen altura <valor>` - Modifica a altura da água quando ela estiver sido criada pela pré-visualização (que é quando você cria todos os marcadores). O valor de altura é relativo à altura atual (em tempo real) da água no momento da execução. Exemplo:
  - `/watergen altura -1` vai diminuir a altura em *1 unidade*;
  - `/watergen altura 0.2` vai aumentar a altura da água em *0.2 unidades*.
- `/watergen gerar` - É o comando final. Depois de ter feito todos os marcadores e visto a pré-visualização, ao executar este comando, será gerado um pequeno código usando a função [`createWater`](https://wiki.multitheftauto.com/wiki/CreateWater) já com os argumentos preenchidos com as posições obtidas pelos marcadores que você criou. Algo como:
```lua
createWater(204.14258, 1872.316, 16.540625, 223.95726, 1871.9797, 16.540625, 204.02234, 1904.702, 16.540625, 226.79608, 1904.1271, 16.548058)
```

## Demonstração
Veja o vídeo de demonstração do sistema: https://youtu.be/c8k6fU_IkjE
