import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Surf spots around the world',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.dark,
      ),
      home: MapScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  double zoomLevel = 2;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
    MapLatLng(30.5447, -9.709), // Taghazout, Maroc
    MapLatLng(6.1407, 80.1028), // Hikkaduwa, Sri Lanka
    MapLatLng(-35.8182, 137.1566), // Kangaroo Island, Australie
    MapLatLng(42.2711, -70.8618), // Nantasket Beach, USA
    MapLatLng(45.6498, 13.753), // Trieste, Italie
    MapLatLng(54.2467, -0.3656), // Cayton Bay, Angleterre
    MapLatLng(-36.9556, 174.4694), // Piha, Nouvelle-Zélande
    MapLatLng(-12.2617, -76.7289), // Punta Hermosa, Pérou
    MapLatLng(1.3156, 103.9673), // East Coast Park, Singapour
    MapLatLng(19.8715, -71.4112), // Puerto Salina, Mexique
    MapLatLng(9.6156, -84.6281), // Jaco, Costa Rica
    MapLatLng(-8.7278, 115.1730), // Kuta, Indonésie
    MapLatLng(39.3568, -9.3787), // Peniche, Portugal
    MapLatLng(-38.5079, 145.0216), // Woolamai, Australie
    MapLatLng(-42.9895, 147.5236), // Clifton Beach, Tasmanie
    MapLatLng(35.8898, 140.6645), // Shonan, Japon
    MapLatLng(-34.0511, 151.1532), // Cronulla, Australie
    MapLatLng(-9.6521, 120.2636), // Sumba, Indonésie
    MapLatLng(14.6706, -92.3729), // Playa Linda, Mexique
    MapLatLng(-27.4689, 153.02349), // Brisbane, Australie
    MapLatLng(25.2528, 55.3644), // Dubai, EAU
    MapLatLng(36.8790, 10.3276), // La Marsa, Tunisie
    MapLatLng(-34.3851, -72.0046), // Pichilemu, Chili

  ];

  final List<String> locations = [
    'Saint-Leu, La Réunion',
    'Biarritz, France',
    'Nazaré, Portugal',
    'Puerto Escondido, Mexique',
    'Uluwatu, Bali',
    'Gold Coast, Australie',
    'Acapulco, Mexique',
    'Bathsheba, Barbade',
    'Oahu, Hawaï',
    'Santa Cruz, Californie',
    'Hossegor, France',
    'Ericeira, Portugal',
    'Tahiti',
    'Sennen Cove, Angleterre',
    'Capo Mannu, Italie',
    'Bundoran, Irlande',
    'Mundaka, Espagne',
    'Batz-sur-mer, France',
    'Tenby, Pays de Galles',
    'Popoyo, Nicaragua',
    'Margaret River, Australie',
    'Ubatuba, Brésil',
    'Cable Beach, Australie',
    'Hienghène, Nouvelle-Calédonie',
    'Tortola, Îles Vierges',
    'Playa Avellanas, Costa Rica',
    'Talofofo Bay, Guam',
    'Monterey Bay, Californie',
    'Phillip Island, Australie',
    'Muizenberg, Afrique du Sud',
    'Taghazout, Maroc',
    'Hikkaduwa, Sri Lanka',
    'Kangaroo Island, Australie',
    'Nantasket Beach, USA',
    'Trieste, Italie',
    'Cayton Bay, Angleterre',
    'Piha, Nouvelle-Zélande',
    'Punta Hermosa, Pérou',
    'East Coast Park, Singapour',
    'Puerto Salina, Mexique',
    'Jaco, Costa Rica',
    'Kuta, Indonésie',
    'Peniche, Portugal',
    'Woolamai, Australie',
    'Clifton Beach, Tasmanie',
    'Shonan, Japon',
    'Cronulla, Australie',
    'Sumba, Indonésie',
    'Playa Linda, Mexique',
    'Brisbane, Australie',
    'Dubai, EAU',
    'La Marsa, Tunisie',
    'Pichilemu, Chili',
  ];

  Map<int, String> weatherCodeDescriptions = {
    0: 'Clear sky',
    1: 'Mainly clear',
    2: 'Partly cloudy',
    3: 'Overcast',
    45: 'Fog',
    48: 'Depositing rime fog',
    51: 'Light drizzle',
    53: 'Moderate drizzle',
    55: 'Dense drizzle',
    61: 'Slight rain',
    63: 'Moderate rain',
    65: 'Heavy rain',
    71: 'Slight snow',
    73: 'Moderate snow',
    75: 'Heavy snow',
    // Add more weather codes as needed
  };

  late MapZoomPanBehavior _zoomPanBehavior;
  int? _selectedLocationIndex;
  List<_WaveData> waveData = [];
  List<_WaveData> hourlyWindWaveDirectionData = [];
  List<_WaveData> hourlyWindWaveHeightData = [];
  List<_WaveData> hourlyWavePeriodData = [];
  List<DateTime> temperatureTimes = [];
  List<double> temperaturesData = [];
  List<String> weatherCodesData = []; // For storing human-readable weather descriptions
  List<double> windSpeeds = []; // For storing wind speeds in km/h
  List<String> weatherDescriptions = [];

  TooltipBehavior? _tooltipBehavior;

  String _selectedDataType = 'Wave Height'; // Choix par défaut


  final List<String> dataTypes = [
    'Wave Height',
    'Wave Period',
    'Wind Wave Height',
  ];

  int selectedTimeIndex = 0;
  double? currentTemperature;


  @override
  void initState() {
    super.initState();
    _zoomPanBehavior = MapZoomPanBehavior(
      enableDoubleTapZooming: true,
      enablePanning: true,
      maxZoomLevel: 10,
      minZoomLevel: 1,
      zoomLevel: zoomLevel,
    );
    _tooltipBehavior = TooltipBehavior(enable: true);
  }



  Future<void> _fetchWaveData(double latitude, double longitude) async {
    final url = Uri.https('marine-api.open-meteo.com', '/v1/marine', {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "current": "wave_height,wave_period,wind_wave_height,wind_wave_direction",
      "hourly": "wave_height,wave_period,wind_wave_height,wind_wave_direction",
      "timezone": "GMT"
    });

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);

      final List<dynamic> hourlyWaveData =
      jsonResponse['hourly']['wave_height'];
      final List<dynamic> hourlyPeriodData =
      jsonResponse['hourly']['wave_period'];
      final List<dynamic> hourlyWindHeightData =
      jsonResponse['hourly']['wind_wave_height'];
      final List<dynamic> hourlyWindDirectionData =
      jsonResponse['hourly']['wind_wave_direction'];
      final List<String> timeData =
      List<String>.from(jsonResponse['hourly']['time']);

      setState(() {
        waveData = List.generate(hourlyWaveData.length, (index) {
          return _WaveData(DateTime.parse(timeData[index]),
              hourlyWaveData[index].toDouble());
        });
        hourlyWavePeriodData = List.generate(hourlyPeriodData.length, (index) {
          return _WaveData(DateTime.parse(timeData[index]),
              hourlyPeriodData[index].toDouble());
        });
        hourlyWindWaveHeightData =
            List.generate(hourlyWindHeightData.length, (index) {
              return _WaveData(DateTime.parse(timeData[index]),
                  hourlyWindHeightData[index].toDouble());
            });
        hourlyWindWaveDirectionData =
            List.generate(hourlyWindDirectionData.length, (index) {
              return _WaveData(DateTime.parse(timeData[index]),
                  hourlyWindDirectionData[index].toDouble());
            });

        selectedTimeIndex = waveData.length - 1;
      });
    } else {
      throw Exception('Failed to load wave data');
    }
  }


  Future<void> fetchTemperatureData(double latitude, double longitude) async {
    final String url = 'https://api.open-meteo.com/v1/forecast';
    final Map<String, dynamic> params = {
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "current": 'temperature_2m,weather_code,wind_speed_10m',
      'hourly': 'temperature_2m,weather_code,wind_speed_10m',
      'timezone': 'GMT',
    };

    final response = await http.get(Uri.parse('$url?${Uri(queryParameters: params).query}'));

    if (response.statusCode == 200) {
      final jsonResponse = json.decode(response.body);
      print(jsonResponse); //
      final List<dynamic> timeData = jsonResponse['hourly']['time'];
      final List<dynamic> temperatureData = jsonResponse['hourly']['temperature_2m'];
      final List<dynamic> weatherCodeData = jsonResponse['hourly']['weather_code'];
      final List<dynamic> windSpeedData = jsonResponse['hourly']['wind_speed_10m'];

      setState(() {
        temperatureTimes = List<DateTime>.from(timeData.map((time) => DateTime.parse(time)));
        temperaturesData = List<double>.from(temperatureData.map((temp) => temp.toDouble()));

        print(weatherCodeData) ; ///
        // Utilisez les codes météo entiers et convertissez-les en descriptions
        weatherCodesData = List<String>.from(weatherCodeData.map((code) {
          return weatherCodeDescriptions[code] ?? 'Unknown'; // Utilisez le dictionnaire des descriptions
        }));
        windSpeeds = List<double>.from(windSpeedData.map((speed) => speed.toDouble()));
      });
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  void _openSidePanel(int index) {
    setState(() {
      _selectedLocationIndex = index;
    });
    final latLng = markerPositions[index];
    _fetchWaveData(latLng.latitude, latLng.longitude);
    fetchTemperatureData(latLng.latitude, latLng.longitude); // Ajoutez cet appel
    _scaffoldKey.currentState?.openEndDrawer();
  }

  double _getWindWaveDirectionAtSelectedTime() {
    if (hourlyWindWaveDirectionData.isNotEmpty) {
      return hourlyWindWaveDirectionData[selectedTimeIndex].height;
    } else {
      return 0.0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          'Surf spots around the world',
          style: TextStyle(
            fontSize: 24, // Augmenter la taille de la police
          ),
        ),
        centerTitle: true,
        leading: Container(),
        backgroundColor: Colors.black12, // Changer la couleur de fond en gris
      ),
      endDrawer: Container(
        width: 500,
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                ),
                child: Center(
                  child: ListTile(
                    title: Text(
                      _selectedLocationIndex != null &&
                          _selectedLocationIndex! < locations.length
                          ? locations[_selectedLocationIndex!]
                          : '',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      "Marine weather condition",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
              // Espace pour abaisser le DropdownButton
              SizedBox(height: 15), // Ajustez cette valeur pour abaisser le DropdownButton
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0), // Augmenter les marges à gauche et à droite
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 35,
                        decoration: BoxDecoration(
                          color: Colors.grey[700],
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: Colors.black),
                        ),
                        child: DropdownButton<String>(
                          padding: const EdgeInsets.only(left: 10.0),
                          hint: Text(
                            'Select Data Type',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12, // Taille réduite du texte
                            ),
                          ),
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.arrow_drop_down,
                              color: Colors.white,
                            ),
                          ),
                          isExpanded: true,
                          underline: Container(),
                          value: _selectedDataType,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedDataType = newValue!;
                            });
                          },
                          items: dataTypes
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(
                                value,
                                style: TextStyle(
                                  fontSize: 12, // Taille réduite du texte
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Espace entre le DropdownButton et le graphique
              SizedBox(height: 15), // Ajustez cette valeur pour augmenter l'espace entre le DropdownButton et le graphique
              // Graphique
              if (waveData.isNotEmpty)
                SfCartesianChart(
                  margin: EdgeInsets.symmetric(horizontal: 20), // Augmenter la marge à gauche et à droite
                  primaryXAxis: DateTimeAxis(
                    intervalType: DateTimeIntervalType.hours,
                    interval: 6,
                    dateFormat: DateFormat('dd MMM, HH:mm'),
                    labelRotation: -45,
                    labelStyle: TextStyle(fontSize: 10),
                  ),
                  primaryYAxis: NumericAxis(
                    labelStyle: TextStyle(fontSize: 11), // Réduction de la taille de la légende de l'axe des ordonnées
                  ),
                  title: ChartTitle(
                    text: '$_selectedDataType Over Time',
                    textStyle: TextStyle(
                      fontSize: 12,
                    ),
                  ),
                  tooltipBehavior: _tooltipBehavior,
                  zoomPanBehavior: ZoomPanBehavior(
                    enablePinching: true,
                    enablePanning: true,
                    enableMouseWheelZooming: true,
                  ),
                  series: <CartesianSeries<dynamic, dynamic>>[
                    LineSeries<_WaveData, DateTime>(
                      dataSource: _getSelectedData(),
                      xValueMapper: (_WaveData wave, _) => wave.time,
                      yValueMapper: (_WaveData wave, _) => wave.height,
                      color: Colors.yellow,
                      name: _selectedDataType,
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(fontSize: 10), // Réduction de la taille de la police des étiquettes de données
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 100), // Espace graphique et boussole/temperature
              // Affichage de la température à gauche et de la boussole à droite
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Affichage de la température
                    // Widget d'affichage de la température et icône météo
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.grey[700],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(color: Colors.black),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Ajout de l'icône météo
                          _getWeatherIcon(
                            _selectedLocationIndex != null &&
                                weatherCodesData.isNotEmpty
                                ? weatherCodesData[selectedTimeIndex]
                                : null,
                          ),
                          SizedBox(height: 5), // Espacement entre l'icône et la température
                          Text(
                            'Température',
                            style: TextStyle(color: Colors.white, fontSize: 12),
                          ),
                          SizedBox(height: 1),
                          Text(
                            '${_selectedLocationIndex != null && temperaturesData.isNotEmpty ? temperaturesData[selectedTimeIndex].toStringAsFixed(1) : 'N/A'} °C',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10), // Espace entre température et boussole
                    // Boussole
                    Column(
                      children: [
                        CompassWidget(
                          direction: _getWindWaveDirectionAtSelectedTime(),
                        ),
                        SizedBox(height: 10), // Espace entre la boussole et le titre
                        Text(
                          'Wind Wave Direction: ${_getWindWaveDirectionAtSelectedTime().toStringAsFixed(1)}°',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 5), // Espace entre le titre de la direction et la vitesse du vent
                        // Nouveau texte pour Wind Speed
                        Text(
                          'Wind Speed: ${_selectedLocationIndex != null && windSpeeds.isNotEmpty ? windSpeeds[selectedTimeIndex].toStringAsFixed(1) : 'N/A'} km/h',
                          style: TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10), // Espace entre boussole/temperature et slider
              // Déplacement du Slider en bas
              if (waveData.isNotEmpty) ...[
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.grey,
                      thumbColor: Colors.white,
                      thumbShape: RoundSliderThumbShape(
                        enabledThumbRadius: 8.0,
                      ),
                      trackHeight: 2.0,
                    ),
                    child: Slider(
                      value: selectedTimeIndex.toDouble(),
                      min: 0,
                      max: waveData.length - 1,
                      divisions: waveData.length - 1,
                      label: DateFormat('dd MMM, HH:mm')
                          .format(waveData[selectedTimeIndex].time),
                      onChanged: (double value) {
                        setState(() {
                          selectedTimeIndex = value.toInt();
                        });
                      },
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      body: Center(
        child: SfMaps(
          layers: [
            MapTileLayer(
              urlTemplate:
              //'https://{s}.basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}{r}.png',
              //'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}.png',
              //'https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png', // Tuiles en teintes de gris
              //'https://{s}.basemaps.cartocdn.com/light_nolabels/{z}/{x}/{y}.png',
              //'https://api.maptiler.com/maps/darkmatter/{z}/{x}/{y}.png?key=0TxzvB62bau6O7bY1ukn',
              'https://api.maptiler.com/maps/hybrid/{z}/{x}/{y}.jpg?key=0TxzvB62bau6O7bY1ukn',
              zoomPanBehavior: _zoomPanBehavior,
              initialMarkersCount: markerPositions.length,
              markerBuilder: (BuildContext context, int index) {
                return MapMarker(
                  latitude: markerPositions[index].latitude,
                  longitude: markerPositions[index].longitude,
                  child: GestureDetector(
                    onTap: () {
                      _openSidePanel(index);
                    },
                    child: Tooltip(
                      message: locations[index], // Affiche le nom de la ville et le pays
                      textStyle: TextStyle(color: Colors.white),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Icon(
                        Icons.place,
                        color: Colors.redAccent,
                        size: 30,
                      ),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  NumericAxis _getPrimaryYAxis() {
    // Modifie l'unité d'affichage en fonction du type de donnée sélectionnée
    String unit = _selectedDataType == 'Wave Period' ? 's' : 'm';
    return NumericAxis(
      labelFormat: '{value} $unit',
      title: AxisTitle(text: ''), // Titre vide pour masquer l'axe Y
    );
  }


  Widget _getWeatherIcon(String? weatherDescription) {
    if (weatherDescription == null) {
      return //Icon(Icons.help_outline, color: Colors.white, size: 100);
        SvgPicture.asset(
          'assets/weather_icons/partly-cloudy-day.svg',
          width: 150,
          height: 150,
        );
    }
    switch (weatherDescription) {
      case 'Clear sky':
        return SvgPicture.asset(
            'assets/weather_icons/clear-day.svg',
            width: 150,
            height: 150,
            fit: BoxFit.fill
        );
      case 'Mainly clear':
        return SvgPicture.asset(
          'assets/weather_icons/partly-cloudy-day.svg',
          width: 150,
          height: 150,
        );
      case 'Partly cloudy':
        return SvgPicture.asset(
          'assets/weather_icons/overcast-day.svg',
          width: 150,
          height: 150,
        );
      case 'Overcast':
        return SvgPicture.asset(
          'assets/weather_icons/overcast.svg',
          width: 150,
          height: 150,
        );
      case 'Fog':
        return SvgPicture.asset(
          'assets/weather_icons/fog-day.svg',
          width: 150,
          height: 150,
        );
      case 'Slight rain':
        return SvgPicture.asset(
          'assets/weather_icons/rain.svg',
          width: 150,
          height: 150,
        );
      case 'Depositing rime fog':
        return SvgPicture.asset(
          'assets/weather_icons/fog.svg',
          width: 150,
          height: 150,
        );
      case 'Light drizzle':
        return SvgPicture.asset(
          'assets/weather_icons/partly-cloudy-day-drizzle.svg',
          width: 150,
          height: 150,
        );
      case 'Moderate drizzle':
        return SvgPicture.asset(
          'assets/weather_icons/drizzle.svg',
          width: 150,
          height: 150,
        );
      case 'Dense drizzle':
        return SvgPicture.asset(
          'assets/weather_icons/rain.svg',
          width: 150,
          height: 150,
        );
      case 'Moderate rain':
        return SvgPicture.asset(
          'assets/weather_icons/rain.svg',
          width: 150,
          height: 150,
        );
      case 'Heavy rain':
        return SvgPicture.asset(
          'assets/weather_icons/thunderstorms-day-rain.svg',
          width: 150,
          height: 150,
        );
      case 'Slight snow':
        return SvgPicture.asset(
          'assets/weather_icons/snow.svg',
          width: 150,
          height: 150,
        );
      case 'Moderate snow':
        return SvgPicture.asset(
          'assets/weather_icons/snow.svg',
          width: 150,
          height: 150,
        );
      case 'Heavy snow':
        return SvgPicture.asset(
          'assets/weather_icons/thunderstorms-day-snow.svg',
          width: 150,
          height: 150,
        );
      default:
        return //Icon(Icons.help_outline, color: Colors.white, size: 100);
          SvgPicture.asset(
            'assets/weather_icons/partly-cloudy-day.svg',
            width: 150,
            height: 150,
          );
    }
  }


  List<_WaveData> _getSelectedData() {
    switch (_selectedDataType) {
      case 'Wave Period':
        return hourlyWavePeriodData;
      case 'Wind Wave Height':
        return hourlyWindWaveHeightData;
      default:
        return waveData;
    }
  }
}

class _WaveData {
  _WaveData(this.time, this.height);
  final DateTime time;
  final double height;
}

class CompassWidget extends StatelessWidget {
  final double direction;

  CompassWidget({required this.direction});

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: (direction * pi / 180),
      child: Icon(
        Icons.navigation,
        size: 50,
        color: Colors.white,
      ),
    );
  }
}