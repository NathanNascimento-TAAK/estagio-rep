public with sharing class Documento {
    private final string documento { get; set; }
    public Documento(string documento) {
        if(validarDocumento(documento)) this.documento = documento;
        else System.debug('O documento informado é inválido!');
    }

    public Boolean validarDocumento(string documento) {
        if(!String.isBlank(documento) && documento.length() == 11) return true;
        else return false;
    }

    public String getDocumento() {
        return documento;
    }

}