import 'package:flutter/material.dart';

class City {
  City({
    required this.name,
    required this.imageUrl,
    this.isFavorite = false,
  });

  final String name;
  final String imageUrl;
  bool isFavorite;
}

class CityExplorerPage extends StatefulWidget {
  const CityExplorerPage({super.key});

  @override
  State<CityExplorerPage> createState() => _CityExplorerPageState();
}

class _CityExplorerPageState extends State<CityExplorerPage> {
  final List<City> _cities = [
    City(
      name: 'Rome',
      imageUrl: 'assets/rome.png',
    ),
    City(
      name: 'Milan',
      imageUrl: 'assets/milan.png',
    ),
    City(
      name: 'Naples',
      imageUrl: 'assets/naples.png',
    ),
  ];

  void _toggleFavorite(int index) {
    setState(() {
      _cities[index].isFavorite = !_cities[index].isFavorite;
    });
  }

  void _showDiscoverSnackBar(String cityName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Scopri attività a $cityName'),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              'assets/city_header.png',
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Esplora nuove città',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 8),
        Text(
          'Scegli una città e scopri attrazioni, esperienze e attività locali.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildCityCard(City city, int index) {
    final ColorScheme colors = Theme.of(context).colorScheme;
    final Color favoriteColor = city.isFavorite ? Colors.red : Colors.grey;
    final IconData favoriteIcon =
        city.isFavorite ? Icons.favorite : Icons.favorite_border;

    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                city.imageUrl,
                width: 110,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    city.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      IconButton(
                        onPressed: () => _toggleFavorite(index),
                        icon: Icon(favoriteIcon, color: favoriteColor),
                        tooltip: city.isFavorite
                            ? 'Rimuovi dai preferiti'
                            : 'Aggiungi ai preferiti',
                      ),
                      const SizedBox(width: 4),
                      ElevatedButton(
                        onPressed: () => _showDiscoverSnackBar(city.name),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                        ),
                        child: const Text('Scopri'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('City Explorer'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildHeader(),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              itemCount: _cities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                return _buildCityCard(_cities[index], index);
              },
            ),
          ),
        ],
      ),
    );
  }
}
