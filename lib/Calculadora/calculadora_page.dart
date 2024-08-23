import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Calculadora extends StatefulWidget {
  const Calculadora({super.key});
  static const routeNameCalculadora = 'calculadora_page';
  @override
  State<Calculadora> createState() => _CalculadoraState();
}

class _CalculadoraState extends State<Calculadora> {
  final TextEditingController dineroController = TextEditingController();
  final TextEditingController porcentajeController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  double totalCuenta = 0;

  void _calculateTotal() {
    double dinero = double.tryParse(dineroController.text) ?? 0;
    double porcentaje = double.tryParse(porcentajeController.text) ?? 0;
    double tipAmount = dinero * (porcentaje / 100);
    setState(() {
      totalCuenta = dinero + tipAmount;
    });
  }

  @override
  void dispose() {
    dineroController.dispose();
    porcentajeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de Propinas'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                controller: dineroController,
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[|!"${}%&\\=?¿¡]')),
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d*\.?\d{0,2}$'),
                  ),
                ],
                decoration: const InputDecoration(
                  labelText: 'Total de la cuenta',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingrese el valor de la cuenta';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                inputFormatters: [
                  FilteringTextInputFormatter.deny(RegExp(r'[|!"${}%&\\=?¿¡]')),
                  FilteringTextInputFormatter.allow(
                    RegExp(r'^\d{0,5}$'),
                  )
                ],
                controller: porcentajeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Porcentaje de la propina',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el porcentaje';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formKey.currentState!.validate()) {
                    _calculateTotal();
                  }
                },
                child: const Text('Calcular'),
              ),
              const SizedBox(height: 20),
              Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                      text: TextSpan(children: <TextSpan>[
                    const TextSpan(
                      text: 'Cuenta: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '\$${dineroController.text}',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]))),
              Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                      text: TextSpan(children: <TextSpan>[
                    const TextSpan(
                      text: 'Propina: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '${porcentajeController.text}%',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]))),
              Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                      text: TextSpan(children: <TextSpan>[
                    const TextSpan(
                      text: 'Total: ',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: '\$$totalCuenta',
                      style: const TextStyle(
                        color: Colors.green,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]))),
            ],
          ),
        ),
      ),
    );
  }
}
