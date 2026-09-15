public with sharing class RelatorioReservasService {
    public RelatorioReservasService() {

    }
    public Map<Documento, List<Reserva>> gerarRelatorioReservasPorCpf(List<Documento> cpfs, List<Restaurante> restaurantes) {
        Map<Documento, List<Reserva>> relatorio = new Map<Documento, List<Reserva>>();
        for(Documento cpf : cpfs) {
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
}