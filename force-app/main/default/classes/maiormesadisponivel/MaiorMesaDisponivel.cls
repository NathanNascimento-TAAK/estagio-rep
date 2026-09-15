public with sharing class MaiorMesaDisponivel implements PoliticaAlocacaoMesa {
    public MaiorMesaDisponivel() {

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
}