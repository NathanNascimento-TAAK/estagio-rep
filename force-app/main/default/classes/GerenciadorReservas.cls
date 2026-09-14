public with sharing class GerenciadorReservas {
    public GerenciadorReservas() {

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
}