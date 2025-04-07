# 🚦 8051TrafficLight

Este projeto implementa um semáforo controlado por um microcontrolador 8051, utilizando a IDE mcu8051. O sistema simula um semáforo 🚥 com funcionalidades de ciclo normal, modo de emergência 🚨 e contagem de veículos 🚗, além de exibir o tempo restante no semáforo em displays de 7 segmentos.

## 📂 Estrutura do Repositório

O repositório está organizado da seguinte maneira:

    /virtual_hw
    ├── 7-seg_ones.vhc
    ├── 7-seg_tens.vhc
    ├── led_panel.vhc
    └── simple_keypad.vhc
    8051TrafficLight.mcu8051ide
    8051TrafficLight.asm
    Problema I.pdf

- **/virtual_hw**: Diretório que contém os arquivos de hardware virtual utilizados no projeto.
  - **7-seg_ones.vhc**: Arquivo correspondente ao display de 7 segmentos que exibe as unidades do tempo.
  - **7-seg_tens.vhc**: Arquivo correspondente ao display de 7 segmentos que exibe as dezenas do tempo.
  - **led_panel.vhc**: Arquivo que simula o painel de LED, indicando o estado atual do semáforo (verde 🟢, amarelo 🟡 ou vermelho 🔴).
  - **simple_keypad.vhc**: Arquivo que simula o teclado utilizado para os botões de emergência 🚨 e contagem de veículos 🚗.

- **8051TrafficLight.mcu8051ide**: Arquivo de projeto que deve ser aberto na **IDE mcu8051** para carregar e executar o projeto.
- **8051TrafficLight.asm**: Código fonte escrito em Assembly que implementa a lógica do semáforo, incluindo o controle de interrupções e a simulação do semáforo com displays de 7 segmentos.

Esses arquivos podem ser carregados diretamente na **IDE mcu8051**, onde o projeto foi desenvolvido, para simular o funcionamento completo do semáforo.

## 🛠️ Requisitos

- **Dependência**: mcu8051 IDE versão 1.4.9
- **Linguagem**: Assembly para microcontrolador 8051
- **Características do 8051**:
  - **Memória ROM**: 4 KB
  - **Memória RAM**: 128 bytes
  - **Tamanho da palavra**: 8 bits
  - **Pinos de I/O**: 32 pinos de entrada/saída (divididos em 4 portas de 8 bits)
  - **Timer**: 2 timers de 16 bits
  - **Interrupções**: 5 fontes de interrupção, incluindo interrupções externas


https://github.com/user-attachments/assets/ad0875f8-cec0-443c-afd4-109d0fdc19bd


## ⚙️ Funcionalidades

### 🚦 Ciclo Normal do Semáforo

- O semáforo funciona em loop com os seguintes tempos:
  - **LED Verde 🟢**: 10 segundos
  - **LED Amarelo 🟡**: 3 segundos
  - **LED Vermelho 🔴**: 7 segundos

### 🔢 Display de 7 Segmentos

- O tempo restante de cada cor do semáforo é exibido nos displays de 7 segmentos, tanto para as unidades quanto para as dezenas, utilizando os timers do 8051 para contagem.

### 🚨 Modo Emergência (Botão)

- Se o botão de emergência for pressionado, o sinal vermelho 🔴 dura **15 segundos** antes de retomar o ciclo normal. A detecção é feita por uma interrupção externa configurada para o botão.

### 🚗 Contagem de Veículos (Botão)

- Ao pressionar o botão de contagem de veículos, a quantidade de veículos passando pelo semáforo é incrementada, desde que o semáforo não esteja vermelho 🔴.
- Se mais de **5 veículos** passarem durante o semáforo verde 🟢, o tempo do LED verde será **aumentado para 15 segundos**.
- A detecção dessa contagem também é feita através de uma interrupção externa.

### ⚠️ Prioridade das Interrupções

- A lógica de interrupções segue a seguinte prioridade:
  1. **Interrupção Externa**: Modo de Emergência 🚨
  2. **Interrupção Externa**: Contagem de Veículos 🚗
  3. **Timer**: Contagem do tempo do semáforo ⏲️

## 🏃‍♂️ Como Rodar o Projeto

1. Abra a **mcu8051 IDE**.
2. Carregue o arquivo de projeto **8051TrafficLight.mcu8051ide** na IDE.
3. Carregue os arquivos de hardware virtual:
   - **7-seg_ones.vhc**
   - **7-seg_tens.vhc**
   - **led_panel.vhc**
   - **simple_keypad.vhc**
4. Carregue o código fonte **8051TrafficLight.asm** no ambiente de desenvolvimento.
5. Execute a simulação e observe o funcionamento do semáforo, dos displays e dos botões.
