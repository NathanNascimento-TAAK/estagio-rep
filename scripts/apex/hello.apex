// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

System.debug('=== DOMINIO BASICO ===');

Documento documentoValido = new Documento('99999999999');
System.assertEquals('99999999999', documentoValido.getDocumento());
System.assertEquals(true, documentoValido.validarDocumento('99999999999'));
System.assertEquals(false, documentoValido.validarDocumento('123'));

QuantidadePessoas quantidadeValida = new QuantidadePessoas(5);
System.assertEquals(5, quantidadeValida.quantidadePessoas);
QuantidadePessoas quantidadeInvalida = new QuantidadePessoas(0);
System.assertEquals(null, quantidadeInvalida.quantidadePessoas);

Cliente clienteBasico = new Cliente(documentoValido, 'Cliente Basico');
System.assertEquals('Cliente Basico', clienteBasico.getNome());
System.assertEquals(documentoValido, clienteBasico.getDocumento());
System.debug('Documento, QuantidadePessoas e Cliente: OK');

System.debug('=== ETAPA 3: STRATEGY DE ALOCACAO ===');

List<Mesa> mesas = new List<Mesa>{
	new Mesa(new IndentificadorMesa(1), new QuantidadePessoas(2), LocalMesa.SALAO),
	new Mesa(new IndentificadorMesa(2), new QuantidadePessoas(4), LocalMesa.SALAO),
	new Mesa(new IndentificadorMesa(3), new QuantidadePessoas(6), LocalMesa.JARDIM)
};
QuantidadePessoas grupoDeTres = new QuantidadePessoas(3);

Mesa menor = new MenorMesaViavel().selecionarMesa(
	mesas,
	grupoDeTres,
	LocalMesa.SALAO,
	PeriodoReserva.NOITE
);
System.assertEquals(4, menor.getCapacidade().quantidadePessoas);
System.debug('MenorMesaViavel: OK');

Mesa maior = new MaiorMesaDisponivel().selecionarMesa(
	mesas,
	grupoDeTres,
	LocalMesa.SALAO,
	PeriodoReserva.NOITE
);
System.assertEquals(4, maior.getCapacidade().quantidadePessoas);
System.debug('MaiorMesaDisponivel: OK');

Mesa prioridadeSalao = new PoliticaPrioridadeSalao().selecionarMesa(
	mesas,
	new QuantidadePessoas(2),
	LocalMesa.JARDIM,
	PeriodoReserva.NOITE
);
System.assertEquals(LocalMesa.SALAO, prioridadeSalao.getLocalizacao());
System.debug('PoliticaPrioridadeSalao: OK');

System.debug('=== ETAPA 5: STATE DA RESERVA ===');

Reserva reservaEstado = new Reserva();
System.assert(reservaEstado.status instanceof EstadoPendente);
reservaEstado.confirmar();
System.assert(reservaEstado.status instanceof EstadoConfirmado);
reservaEstado.confirmar();
System.assert(reservaEstado.status instanceof EstadoConfirmado);
reservaEstado.cancelar();
System.assert(reservaEstado.status instanceof EstadoCancelado);
reservaEstado.promover();
System.assert(reservaEstado.status instanceof EstadoCancelado);
System.debug('Transicoes de EstadoReserva: OK');

System.debug('=== ETAPA 6: PROMOCAO AUTOMATICA ===');

Restaurante restaurante = new Restaurante('Restaurante de Teste');
Mesa mesaUnica = new Mesa(
	new IndentificadorMesa(10),
	new QuantidadePessoas(4),
	LocalMesa.SALAO
);
restaurante.adicionarMesa(mesaUnica);

Cliente clienteConfirmado = new Cliente(
	new Documento('11111111111'),
	'Cliente Confirmado'
);
Cliente clientePendente = new Cliente(
	new Documento('22222222222'),
	'Cliente Pendente'
);
GerenciadorReservas gerenciador = new GerenciadorReservas(
	new MenorMesaViavel(),
	new FifoListaEspera()
);

gerenciador.criarReserva(
	clienteConfirmado,
	restaurante,
	4,
	LocalMesa.SALAO,
	PeriodoReserva.NOITE,
	false
);
gerenciador.criarReserva(
	clientePendente,
	restaurante,
	2,
	LocalMesa.SALAO,
	PeriodoReserva.NOITE,
	true
);

List<Reserva> reservasAntesDoCancelamento = restaurante.getReservas();
System.assertEquals(2, reservasAntesDoCancelamento.size());
System.assert(reservasAntesDoCancelamento[0].status instanceof EstadoConfirmado);
System.assert(reservasAntesDoCancelamento[1].status instanceof EstadoPendente);

gerenciador.cancelarReserva(reservasAntesDoCancelamento[0]);

List<Reserva> reservasDepoisDoCancelamento = restaurante.getReservas();
System.assert(reservasDepoisDoCancelamento[0].status instanceof EstadoCancelado);
System.assert(reservasDepoisDoCancelamento[1].status instanceof EstadoConfirmado);
System.assertEquals(mesaUnica, reservasDepoisDoCancelamento[1].mesa);
System.debug('Promocao automatica FIFO: OK');

System.debug('=== RESTAURANTE E RELATORIO ===');

System.assertEquals('Restaurante de Teste', restaurante.getNome());
System.assertEquals(1, restaurante.getMesas().size());

Restaurante restauranteComLote = new Restaurante('Restaurante com Lote');
restauranteComLote.adicionarMesas(new List<Mesa>{
	new Mesa(
		new IndentificadorMesa(30),
		new QuantidadePessoas(2),
		LocalMesa.JARDIM
	),
	new Mesa(
		new IndentificadorMesa(31),
		new QuantidadePessoas(8),
		LocalMesa.SALAO
	)
});
System.assertEquals(2, restauranteComLote.getMesas().size());
System.debug('Adicao de varias mesas: OK');

try {
	restaurante.adicionarMesa(mesaUnica);
	System.assert(false, 'Deveria rejeitar mesa duplicada.');
} catch (RestauranteException erro) {
	System.debug('Duplicidade de mesa: OK');
}

RelatorioReservasService relatorioService = new RelatorioReservasService();
Map<Documento, List<Reserva>> relatorio = relatorioService.gerarRelatorioReservasPorCpf(
	new List<Documento>{
		clienteConfirmado.getDocumento(),
		clientePendente.getDocumento()
	},
	new List<Restaurante>{restaurante}
);
System.assertEquals(1, relatorio.get(clienteConfirmado.getDocumento()).size());
System.assertEquals(1, relatorio.get(clientePendente.getDocumento()).size());
System.debug('Cadastro do restaurante e RelatorioReservasService: OK');

System.debug('=== POLITICAS DE LISTA DE ESPERA ===');

Mesa mesaParaPoliticas = new Mesa(
	new IndentificadorMesa(20),
	new QuantidadePessoas(5),
	LocalMesa.SALAO
);
Reserva grupoMenor = new Reserva(
	clienteConfirmado,
	restaurante,
	2,
	LocalMesa.SALAO,
	PeriodoReserva.TARDE
);
Reserva grupoMaior = new Reserva(
	clientePendente,
	restaurante,
	5,
	LocalMesa.SALAO,
	PeriodoReserva.TARDE
);
List<Reserva> fila = new List<Reserva>{grupoMenor, grupoMaior};

System.assertEquals(
	grupoMenor,
	new FifoListaEspera().selecionarReserva(
		fila,
		mesaParaPoliticas,
		PeriodoReserva.TARDE,
		LocalMesa.SALAO
	)
);
System.assertEquals(
	grupoMaior,
	new MaiorGrupoListaEspera().selecionarReserva(
		fila,
		mesaParaPoliticas,
		PeriodoReserva.TARDE,
		LocalMesa.SALAO
	)
);
System.assertEquals(
	grupoMenor,
	new OrdemHorarioListaEspera().selecionarReserva(
		fila,
		mesaParaPoliticas,
		PeriodoReserva.TARDE,
		LocalMesa.SALAO
	)
);
System.debug('FIFO, MaiorGrupo e OrdemHorario: OK');

System.debug('=== TESTE COMPLETO DO APP CONCLUIDO ===');