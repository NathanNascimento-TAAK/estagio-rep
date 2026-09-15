public with sharing class Documento {
    private final string documento { get; set; }
    public Documento(string documento) {
        if(validarDocumento(documento)) this.documento = documento;
        else System.debug('O documento informado é inválido!');
    }

    public Boolean validarDocumento(string documento) {
        if(documento.length() == 11 && !String.isBlank(documento)) return true;
        else return false;
    }

    public Integer getCpf() {
        return this.cpf();
    }

}