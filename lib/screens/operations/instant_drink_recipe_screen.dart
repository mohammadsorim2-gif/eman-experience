import 'package:flutter/material.dart';

class InstantDrinkRecipeScreen extends StatefulWidget {
  const InstantDrinkRecipeScreen({required this.languageCode, super.key});

  final String languageCode;

  @override
  State<InstantDrinkRecipeScreen> createState() => _InstantDrinkRecipeScreenState();
}

class _InstantDrinkRecipeScreenState extends State<InstantDrinkRecipeScreen> {
  final _recipes = <_Recipe>[
    const _Recipe('Orange 30 g', 'Orange', 30, 1000, 740, 82, true),
    const _Recipe('Mango 30 g', 'Mango', 30, 1000, 735, 85, true),
    const _Recipe('Strawberry 30 g', 'Strawberry', 30, 1000, 748, 80, false),
  ];

  String _tx(String ar, String tr, String en) =>
      switch (widget.languageCode) {'ar' => ar, 'tr' => tr, _ => en};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_tx('إدارة الوصفات', 'Reçete yönetimi', 'Recipe management')),
      ),
      body: ListView.separated(
        padding: const EdgeInsets.all(24),
        itemCount: _recipes.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final recipe = _recipes[index];
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Row(
                children: [
                  CircleAvatar(
                    child: Text(recipe.flavor.characters.first),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(recipe.name, style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 6),
                        Text('${_tx('وزن الظرف', 'Saşe ağırlığı', 'Sachet weight')}: ${recipe.sachetGrams} g'),
                        Text('${_tx('حجم الدفعة', 'Parti büyüklüğü', 'Batch size')}: ${recipe.batchKg} kg'),
                        Text('${_tx('سكر', 'Şeker', 'Sugar')}: ${recipe.sugarKg} kg · ${_tx('حمض الليمون', 'Sitrik asit', 'Citric acid')}: ${recipe.citricKg} kg'),
                      ],
                    ),
                  ),
                  Switch(
                    value: recipe.active,
                    onChanged: (value) => setState(() => _recipes[index] = recipe.copyWith(active: value)),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => setState(() => _recipes.add(const _Recipe('New recipe', 'New', 30, 1000, 740, 82, false))),
        icon: const Icon(Icons.add_rounded),
        label: Text(_tx('وصفة جديدة', 'Yeni reçete', 'New recipe')),
      ),
    );
  }
}

class _Recipe {
  const _Recipe(this.name, this.flavor, this.sachetGrams, this.batchKg, this.sugarKg, this.citricKg, this.active);
  final String name;
  final String flavor;
  final int sachetGrams;
  final int batchKg;
  final int sugarKg;
  final int citricKg;
  final bool active;

  _Recipe copyWith({bool? active}) => _Recipe(name, flavor, sachetGrams, batchKg, sugarKg, citricKg, active ?? this.active);
}
