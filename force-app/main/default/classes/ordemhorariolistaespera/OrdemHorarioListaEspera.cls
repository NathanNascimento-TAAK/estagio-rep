public with sharing class OrdemHorarioListaEspera extends FifoListaEspera {
    public override Reserva selecionarReserva(List<Reserva> reservas, Mesa mesa, PeriodoReserva periodo, LocalMesa localizacao) {
        Reserva reservaPorHorario;
        for (Reserva reserva : reservas) {
            if (ehCompativel(reserva, mesa, periodo, localizacao) && (reservaPorHorario == null || prioridadePeriodo(reserva.periodo) < prioridadePeriodo(reservaPorHorario.periodo))) {
                reservaPorHorario = reserva;
            }
        }
        return reservaPorHorario;
    }

    private Integer prioridadePeriodo(PeriodoReserva periodo) {
        if (periodo == PeriodoReserva.MANHA) {
            return 1;
        }
        if (periodo == PeriodoReserva.TARDE) {
            return 2;
        }
        return 3;
    }
}