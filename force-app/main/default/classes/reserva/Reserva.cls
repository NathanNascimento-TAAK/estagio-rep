public with sharing class Reserva {
    public Cliente cliente { get; set; }
    public Restaurante restaurante { get; set; }
    public Mesa mesa { get; set; }
    public Integer quantidadePessoas { get; set; }
    public LocalMesa localPreferencia{ get; set; }
    public PeriodoReserva periodo { get; set; }
    public StatusReserva status { get; set; }
    public Reserva() {
        this.mesa = null;
        this.status = null;
    }
    public Reserva(Cliente cliente, Restaurante restaurante, Integer quantidadePessoas, LocalMesa localPreferencia, PeriodoReserva periodo) {
        this.cliente = cliente;
        this.restaurante = restaurante;
        this.quantidadePessoas = quantidadePessoas;
        this.localPreferencia = localPreferencia;
        this.periodo = periodo;
        this.mesa = null;
        this.status = null;
    }
}