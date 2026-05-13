import 'package:flutter/material.dart';

class ImcPageWidget extends StatefulWidget {
  const ImcPageWidget({super.key});

  @override
  State<ImcPageWidget> createState() => _ImcPageWidgetState();
}

class _ImcPageWidgetState extends State<ImcPageWidget> {
  final TextEditingController _pesoController = TextEditingController();
  final TextEditingController _alturaController = TextEditingController();

  void _calcularImc() {
    // Tenta converter o texto para double. Se falhar ou estiver vazio, recebe -1.
    // O replaceAll(',', '.') garante que funcione mesmo se o usuário digitar vírgula.
    double peso = double.tryParse(_pesoController.text.replaceAll(',', '.')) ?? -1;
    double altura = double.tryParse(_alturaController.text.replaceAll(',', '.')) ?? -1;

    // 1. Uso de SnackBar para exibir mensagens de alerta (Erros)
    if (peso <= 0 || altura <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Erro: Preencha o peso e a altura com valores numéricos válidos!',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 3),
          behavior: SnackBarBehavior.floating, // Deixa o SnackBar "flutuando" na tela
        ),
      );
      return; // Interrompe a função aqui, não faz o cálculo
    }

    // Se o usuário digitar 175 em vez de 1.75, converte para metros
    if (altura > 3.0) {
      altura = altura / 100;
    }

    double imc = peso / (altura * altura);
    String classificacao = _obterClassificacao(imc);

    // 2. Uso do AlertDialog para exibir o resultado do cálculo
    showDialog(
      context: context,
      barrierDismissible: false, // Obriga o usuário a clicar no botão para fechar
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Resultado do IMC', textAlign: TextAlign.center),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                imc.toStringAsFixed(2),
                style: const TextStyle(
                  fontSize: 45,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurpleAccent,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                classificacao,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o alerta
              },
              child: const Text('FECHAR', style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  // Lógica de classificação detalhada baseada no IMC
  String _obterClassificacao(double imc) {
    if (imc < 16) return 'Magreza grave';
    if (imc < 17) return 'Magreza moderada';
    if (imc < 18.5) return 'Magreza leve';
    if (imc < 25) return 'Saudável';
    if (imc < 30) return 'Sobrepeso';
    if (imc < 35) return 'Obesidade Grau I';
    if (imc < 40) return 'Obesidade Grau II (severa)';
    return 'Obesidade Grau III (mórbida)';
  }

  // Função para limpar os campos
  void _limpar() {
    _pesoController.clear();
    _alturaController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(Icons.monitor_weight, size: 80, color: Colors.deepPurpleAccent),
            const SizedBox(height: 20),
            
            // Campo de Peso
            TextField(
              controller: _pesoController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Peso (kg)',
                hintText: 'Ex: 75.5',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.scale),
              ),
            ),
            const SizedBox(height: 16),
            
            // Campo de Altura
            TextField(
              controller: _alturaController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(
                labelText: 'Altura (m ou cm)',
                hintText: 'Ex: 1.75 ou 175',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: const Icon(Icons.height),
              ),
            ),
            const SizedBox(height: 24),
            
            // 3. Botões "Calcular IMC" e "Limpar" lado a lado
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _limpar,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      side: const BorderSide(color: Colors.deepPurpleAccent, width: 2),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Limpar', style: TextStyle(fontSize: 16, color: Colors.deepPurpleAccent)),
                  ),
                ),
                const SizedBox(width: 16), // Espaço entre os botões
                Expanded(
                  flex: 2, // Faz o botão calcular ficar mais largo que o limpar
                  child: ElevatedButton(
                    onPressed: _calcularImc,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      backgroundColor: Colors.deepPurpleAccent,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Calcular IMC', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 30),
            
            // 4. Tabela detalhada de classificações
            const Text(
              'Tabela de Classificação',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: const [
                    _TabelaRow(imc: '< 16', classificacao: 'Magreza grave'),
                    Divider(),
                    _TabelaRow(imc: '16 a 16.9', classificacao: 'Magreza moderada'),
                    Divider(),
                    _TabelaRow(imc: '17 a 18.4', classificacao: 'Magreza leve'),
                    Divider(),
                    _TabelaRow(imc: '18.5 a 24.9', classificacao: 'Saudável', isBold: true, color: Colors.green),
                    Divider(),
                    _TabelaRow(imc: '25 a 29.9', classificacao: 'Sobrepeso'),
                    Divider(),
                    _TabelaRow(imc: '30 a 34.9', classificacao: 'Obesidade Grau I', color: Colors.orange),
                    Divider(),
                    _TabelaRow(imc: '35 a 39.9', classificacao: 'Obesidade Grau II (severa)', color: Colors.deepOrange),
                    Divider(),
                    _TabelaRow(imc: '>= 40', classificacao: 'Obesidade Grau III (mórbida)', color: Colors.red),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Pequeno Widget auxiliar para montar as linhas da tabela de forma mais limpa
class _TabelaRow extends StatelessWidget {
  final String imc;
  final String classificacao;
  final bool isBold;
  final Color? color;

  const _TabelaRow({
    required this.imc,
    required this.classificacao,
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(imc, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(
            classificacao,
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
              color: color ?? Colors.black87,
            ),
          ),
        ],
      ),
    );
  }
}