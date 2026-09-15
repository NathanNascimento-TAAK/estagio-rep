public with sharing class Cliente extends EntidadeBase {
    public string nome { get; set; }
    public Documento cpf { get; set; }
    public Cliente() {
        
    }
    public Cliente(string nome, Documento cpf) {
        this.cpf = cpf;
        this.nome = nome;
    }
}