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