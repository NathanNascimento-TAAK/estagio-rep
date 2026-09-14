public with sharing class Restaurante {
    public string nome { get; set; }
    public string endereco { get; set; }
    List<Mesa> mesas = new List<Mesa>();
    List<Reserva> reservas = new List<Reserva>();
    List<Reserva> reservasPendentes = new List<Reserva>();

    public Restaurante() {

    }

    public Restaurante(string nome, string endereco) {
        this.nome = nome;
        this.endereco = endereco;
    }

    public void adicionarMesa(Mesa mesa) {
        if(mesa.capacidade > 0 && !mesas.contains(mesa)) {
            mesas.add(mesa);
            System.debug('Mesa adicionada com sucesso!');
        }
        else {
            System.debug('A mesa desejada já existe ou não há capacidade.');
        }
    }

    public List<Mesa> buscarDisponibilidade(Integer qtdPessoas, LocalMesa local) {
        List<Mesa> mesasDisponiveis = new List<Mesa>();
        for(Mesa mesa : mesas) {
            if(mesa.capacidade >= qtdPessoas && mesa.local == local) {
                mesasDisponiveis.add(mesa);
            }
        }
        return mesasDisponiveis;
    }

    public void criarReserva(Cliente cliente, Restaurante restaurante, Integer quantidadePessoas, LocalMesa localPreferencia, PeriodoReserva periodo, Boolean aceitaListEspera) {
        List<Mesa> mesasEncontradas = buscarDisponibilidade(quantidadePessoas, localPreferencia);
        for(Mesa mesa : mesasEncontradas) {
            for(Reserva reserva : reservas) {
                if(reserva.mesa == mesa && reserva.localPreferencia == localPreferencia && reserva.status == StatusReserva.CONFIRMADA) {
                    mesasEncontradas.remove(mesa);
                }
            }
        }
        if(mesasEncontradas.size() > 0) {
            Reserva reserva = new Reserva(cliente, restaurante, quantidadePessoas, localPreferencia, periodo);
            reserva.status = StatusReserva.CONFIRMADA;
            reserva.mesa = mesasEncontradas[0];
            reservas.add(reserva);
            System.debug('Reserva confirmada!');
        }
        else if(aceitaListEspera){
            Reserva reserva = new Reserva(cliente, restaurante, quantidadePessoas, localPreferencia, periodo);
            reserva.status = StatusReserva.PENDENTE;
            reservasPendentes.add(reserva);
            System.debug('Você está na lista de espera!');
        }
        else {
            System.debug('Não foi possivel encontrar uma mesa com essas especificações.');
        }
    }

    public void cancelarReserva(Reserva reserva) {
        Mesa mesaDisponivel = reserva.mesa;
        reservas.remove(reserva);
        for(Reserva rsvPendente : reservasPendentes) {
            if(rsvPendente.quantidadePessoas <= mesaDisponivel.capacidade && rsvPendente.periodo == reserva.periodo && rsvPendente.localPreferencia == reserva.localPreferencia) {
                rsvPendente.mesa = mesaDisponivel;
                rsvPendente.status = StatusReserva.CONFIRMADA;
                reservasPendentes.remove(rsvPendente);
                reservas.add(rsvPendente);
                break;
            }
        }
    }

    public Map<String, List<Reserva>> gerarRelatorioReservasPorCpf(List<String> cpfs, List<Restaurante> restaurantes) {
        Map<String, List<Reserva>> relatorio = new Map<String, List<Reserva>>();
        for(String cpf : cpfs) {
            List<Reserva> reservasCpf = new List<Reserva>();
            for(Restaurante restaurante : restaurantes) {
                for(Reserva reserva : restaurante.reservas) {
                    if(reserva.cliente.cpf == cpf) {
                        reservasCpf.add(reserva);
                    }
                }
            }
            relatorio.put(cpf, reservasCpf);
        }
        return relatorio;
    }

    public void adicionarMesas(List<Mesa> mesas) {
        for(Mesa mesa : mesas) {
            if(mesa.capacidade > 0 && !mesas.contains(mesa)) {
                mesas.add(mesa);
                System.debug('Mesa adicionada com sucesso!');
            }
            else {
                System.debug('A mesa desejada já existe ou não há capacidade.');
            }
        }
    }
}