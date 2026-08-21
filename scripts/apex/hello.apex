// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

//exercicio 13
System.debug('Exercicio 13');
String caractere = '413';
Integer numero = Integer.valueOf(caractere);
System.debug('Variavel convertida -> ' + numero);

//exercicio 14

//1.
System.debug('Exercicio 14');
List<Integer> fibonacci = new List<Integer>{0, 1};

for(Integer i = 2; i < 10; i++) {
    fibonacci.add(fibonacci[i - 1] + fibonacci[i - 2]);
}

System.debug('Sequência de Fibonacci de 10 termos: ' + fibonacci);

//2.
class Porta {
    string portaNome;

    string estado;

    public void abre() {
        this.estado = 'aberta';
    }

    public void fecha() {
        this.estado = 'fechada';
    }
}

class Casa {
    string cor;
    Integer totalPortas;
    List<Porta> portas = new List<Porta>();

    public void pinta(string novaCor) {
        this.cor = novaCor;
    }

    public Integer quantasPortasAbertas() {
        Integer count = 0;
        for(Porta porta : portas) {
            if(porta.estado == 'aberta') {
                count++;
            }
        }
        return count;
    }

    public void adicionarPorta(Porta porta) {
        portas.add(porta);
        totalPortas = portas.size();
    }

    public void totalDePortas() {
        System.debug('Total de portas na casa: ' + totalPortas);
    }       
}

Casa minhaCasa = new Casa();

minhaCasa.pinta('Azul');

Porta porta1 = new Porta();
porta1.portaNome = 'Entrada';
porta1.estado = 'fechada';

Porta porta2 = new Porta();
porta2.portaNome = 'Cozinha';
porta2.estado = 'aberta';

Porta porta3 = new Porta();
porta3.portaNome = 'Quarto';
porta3.estado = 'fechada';

minhaCasa.adicionarPorta(porta1);
minhaCasa.adicionarPorta(porta2);
minhaCasa.adicionarPorta(porta3);

minhaCasa.quantasPortasAbertas();
minhaCasa.totalDePortas();


//exercicio 15
System.debug('Exercicio 15');
List<Integer> numerosAsc = new List<Integer>();
for(Integer i = 1; i <= 1000; i++) {
    numerosAsc.add(i);
}
numerosAsc.sort();

List<Integer> numerosDesc = new List<Integer>(numerosAsc);

for(Integer i = 0; i < numerosDesc.size() / 2; i++) {
    numerosDesc[i] = numerosDesc[numerosDesc.size() - 1 - i];
}

System.debug('Números de 1 a 1000 em ordem decrescente: ' + numerosDesc);

System.debug('Hello World!');
System.debug('teste');