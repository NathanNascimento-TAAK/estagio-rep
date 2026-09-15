public with sharing class QuantidadePessoas {
    public Integer quantidadePessoas { get; set; }
    public QuantidadePessoas(Integer quantidadePessoas) {
        if(quantidadePessoas > 0) {
            this.quantidadePessoas = quantidadePessoas;
        }
    }
}