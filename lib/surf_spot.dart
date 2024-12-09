import 'package:syncfusion_flutter_maps/maps.dart';

final List<MapLatLng> markerPositions = [
  MapLatLng(-21.1706, 55.2882), // La Réunion
  MapLatLng(43.4806, -1.5568), // Biarritz
  MapLatLng(39.6029, -9.0684), // Nazaré Portugal
  MapLatLng(15.8704, -97.0773), // Puerto Escondido Mexique
  MapLatLng(-8.8314, 115.0870), // Uluwatu Bali
  MapLatLng(-28.0003, 153.4309), // Gold Coast Australie
  MapLatLng(16.863611, -99.882500), // Acapulco Mexique
  MapLatLng(13.2113, -59.5260), // Bathsheba Barbade
  MapLatLng(20.7, -155.9972), // Oahu, Hawaï
  MapLatLng(36.9741, -122.0308), // Santa Cruz, Californie
  MapLatLng(43.69, -1.37), // Hossegor, France
  MapLatLng(38.9627, -9.4156), // Ericeira, Portugal
  MapLatLng(-17.6486, -149.4295), // Tahiti
  MapLatLng(50.078, -5.6946), // Sennen Cove, Angleterre
  MapLatLng(40.7925, 8.1617), // Capo Mannu, Italie
  MapLatLng(54.4778, -8.2809), // Bundoran, Irlande
  MapLatLng(43.408, -2.6985), // Mundaka, Espagne
  MapLatLng(47.283329, -2.48333), // Batz-sur-mer, France
  MapLatLng(51.6728, -4.7045), // Tenby, Pays de Galles
  MapLatLng(11.4729718, -86.1278), // Popoyo, Nicaragua
  MapLatLng(-33.9531, 115.0761), // Margaret River, Australie
  MapLatLng(-23.4536, -45.0694), // Ubatuba, Brésil
  MapLatLng(-17.9372, 122.2149), // Cable Beach, Australie
  MapLatLng(-20.6893, 164.9440), // Hienghène, Nouvelle-Calédonie
  MapLatLng(18.4265, -64.6184), // Tortola, Îles Vierges
  MapLatLng(10.2292, -85.8387), // Playa Avellanas, Costa Rica
  MapLatLng(13.337, 144.76), // Talofofo Bay, Guam
  MapLatLng(36.7996, -121.8947), // Monterey Bay, Californie
  MapLatLng(-38.5043, 145.1893), // Phillip Island, Australie
  MapLatLng(-34.0978, 18.4326), // Muizenberg, Afrique du Sud
  MapLatLng(30.544722, -9.709128), // Taghazout, Maroc
  MapLatLng(6.1407, 80.1028), // Hikkaduwa, Sri Lanka
  MapLatLng(-35.8182, 137.1566), // Kangaroo Island, Australie
  MapLatLng(42.2711, -70.8618), // Nantasket Beach, USA
  MapLatLng(45.6498, 13.753), // Trieste, Italie
  MapLatLng(54.2467, -0.3656), // Cayton Bay, Angleterre
  MapLatLng(-36.9556, 174.4694), // Piha, Nouvelle-Zélande
  MapLatLng(-12.2617, -76.7289), // Punta Hermosa, Pérou
  MapLatLng(1.3156, 103.9673), // East Coast Park, Singapour
  MapLatLng(19.871548, -71.41122), // Puerto Salina, Republique Dominicaine
  MapLatLng(9.6156, -84.6281), // Jaco, Costa Rica
  MapLatLng(-8.7278, 115.1730), // Kuta, Indonésie
  MapLatLng(39.3568, -9.3787), // Peniche, Portugal
  MapLatLng(-38.5079, 145.0216), // Woolamai, Australie
  MapLatLng(-42.9895, 147.5236), // Clifton Beach, Tasmanie
  MapLatLng(35.8898, 140.6645), // Shonan, Japon
  MapLatLng(-34.0511, 151.1532), // Cronulla, Australie
  MapLatLng(-9.6521, 120.2636), // Sumba, Indonésie
  MapLatLng(14.6706, -92.3729), // Playa Linda, Mexique
  MapLatLng(25.2528, 55.3644), // Dubai, EAU
  MapLatLng(36.8790, 10.3276), // La Marsa, Tunisie
  MapLatLng(-34.3851, -72.0046), // Pichilemu, Chili
  MapLatLng(44.1441, -1.2130), // Lacanau, France
  MapLatLng(48.4600, -4.8013), // La Torche, France
  MapLatLng(45.1964, -1.1534), // Le Porge, France
  MapLatLng(43.7377, -1.4214), // Vieux-Boucau, France
  MapLatLng(-33.3319, 17.2047), // Jeffrey's Bay, Afrique du Sud
  MapLatLng(-32.9333, 17.2833), // Dungeons, Afrique du Sud
  MapLatLng(-23.658057, 43.6468581), // Anakao, Madagascar
  MapLatLng(14.4857105, -17.0756047), // Somone, Sénégal
  MapLatLng(21.3482, -157.9465), // Honolulu, Hawaï
  MapLatLng(21.2812, -157.8358), // Waikiki Beach, Hawaï
  MapLatLng(9.9713, 125.9402), // Siargao, Philippines
  MapLatLng(6.8683, 81.8292), // Arugam Bay, Sri Lanka
  MapLatLng(28.9541, -13.5492), // Lanzarote, Spain (Canary Islands)
  MapLatLng(41.1753, -8.6852), // Matosinhos, Portugal (Porto)
  MapLatLng(50.4189, -5.0843), // Fistral Beach, England (Cornwall)
  MapLatLng(-33.8914, 151.2767), // Bondi Beach, Australia (Sydney)
  MapLatLng(50.1189, -5.2667), // Praa Sands, England (Cornwall)
  MapLatLng(-38.3786, 144.2721), // Bells Beach, Australia (Victoria)
  MapLatLng(28.2167, -13.8583)  // Fuerteventura, Spain
];

final List<String> locations = [
  'Saint-Leu, La Réunion',
  'Biarritz, France',
  'Nazaré, Portugal',
  'Puerto Escondido, Mexico',
  'Uluwatu, Bali',
  'Gold Coast, Australia',
  'Acapulco, Mexico',
  'Bathsheba, Barbados',
  'Oahu, Hawaii',
  'Santa Cruz, California',
  'Hossegor, France',
  'Ericeira, Portugal',
  'Tahiti',
  'Sennen Cove, England',
  'Capo Mannu, Italy',
  'Bundoran, Ireland',
  'Mundaka, Spain',
  'Batz-sur-mer, France',
  'Tenby, Wales',
  'Popoyo, Nicaragua',
  'Margaret River, Australia',
  'Ubatuba, Brazil',
  'Cable Beach, Australia',
  'Hienghène, New Caledonia',
  'Tortola, Virgin Islands',
  'Playa Avellanas, Costa Rica',
  'Talofofo Bay, Guam',
  'Monterey Bay, California',
  'Phillip Island, Australia',
  'Muizenberg, South Africa',
  'Taghazout, Morocco',
  'Hikkaduwa, Sri Lanka',
  'Kangaroo Island, Australia',
  'Nantasket Beach, USA',
  'Trieste, Italy',
  'Cayton Bay, England',
  'Piha, New Zealand',
  'Punta Hermosa, Peru',
  'East Coast Park, Singapore',
  'Puerto Salina, Republica Dominicana',
  'Jaco, Costa Rica',
  'Kuta, Indonesia',
  'Peniche, Portugal',
  'Woolamai, Australia',
  'Clifton Beach, Tasmania',
  'Shonan, Japan',
  'Cronulla, Australia',
  'Sumba, Indonesia',
  'Playa Linda, Mexico',
  'Dubai, UAE',
  'La Marsa, Tunisia',
  'Pichilemu, Chile',
  'Lacanau, France',
  'La Torche, France',
  'Le Porge, France',
  'Vieux-Boucau, France',
  'Jeffrey\'s Bay, South Africa',
  'Dungeons, South Africa',
  'Anakao, Madagascar',
  'Somone, Senegal',
  'Honolulu, Hawaii',
  'Waikiki Beach, Hawaii',
  'Siargao, Philippines',
  'Arugam Bay, Sri Lanka',
  'Lanzarote, Spain',
  'Matosinhos, Portugal',
  'Fistral Beach, England',
  'Bondi Beach, Australia',
  'Praa Sands, England',
  'Bells Beach, Australia',
  'Fuerteventura, Spain'
];


final List<MapLatLng> markerPositions2 = [
  MapLatLng(-21.1706, 55.2882)]; // La Réunion