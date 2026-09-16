public with sharing class MaiorGrupoListaEspera extends FifoListaEspera {
    public override Reserva selecionarReserva(List<Reserva> reservas, Mesa mesa, PeriodoReserva periodo, LocalMesa localizacao) {
        Reserva maiorGrupo;
        for (Reserva reserva : reservas) {
            if (ehCompativel(reserva, mesa, periodo, localizacao) && (maiorGrupo == null || reserva.quantidadePessoas > maiorGrupo.quantidadePessoas)) {
                maiorGrupo = reserva;
            }
        }
        return maiorGrupo;
    }
}