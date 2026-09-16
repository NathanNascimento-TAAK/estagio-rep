public virtual with sharing class FifoListaEspera implements PoliticaPromocaoListaEspera {
    public virtual Reserva selecionarReserva(List<Reserva> reservas, Mesa mesa, PeriodoReserva periodo, LocalMesa localizacao) {
        for (Reserva reserva : reservas) {
            if (ehCompativel(reserva, mesa, periodo, localizacao)) {
                return reserva;
            }
        }
        return null;
    }

    protected Boolean ehCompativel(Reserva reserva, Mesa mesa, PeriodoReserva periodo, LocalMesa localizacao) {
        return reserva.status instanceof EstadoPendente && reserva.periodo == periodo && reserva.localPreferencia == localizacao && reserva.quantidadePessoas <= mesa.getCapacidade().quantidadePessoas;
    }
}