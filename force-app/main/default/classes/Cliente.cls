public with sharing class Cliente {
    public string nome { get; set; }
    public string cpf { get; set; }
    public Cliente() {
        
    }
    public Cliente(string nome, string cpf) {
        this.cpf = cpf;
        this.nome = nome;
    }
}