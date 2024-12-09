import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_maps/maps.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'dart:math';
import 'package:flutter_svg/flutter_svg.dart';
import 'surf_spot.dart'; // Importez ici le fichier de données



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
  double zoomLevel = 2.4;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
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
  late List<MapLatLng> markerPositions2;
  late List<MapLatLng> displayedMarkers;
  late List<String> locations;
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
  displayedMarkers = markerPositions;
  _zoomPanBehavior = MapZoomPanBehavior(
    enableDoubleTapZooming: true,
    enablePanning: true,
    enablePinching: true,
    maxZoomLevel: 10,
    minZoomLevel: 2.4,
    zoomLevel: zoomLevel,
  );
  _tooltipBehavior = TooltipBehavior(enable: true);
}

  void _updateMarkers() {
    setState(() {
      if (_zoomPanBehavior.zoomLevel < 5) {
        displayedMarkers = markerPositions;
        locations = ['New York, USA', 'Los Angeles, USA'];
      } else {
        displayedMarkers = markerPositions2;
        locations = ['Paris, France', 'Tokyo, Japan'];
      }
    });
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

        //selectedTimeIndex = waveData.length - 1;
        selectedTimeIndex = 0;
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
              // En-tête avec un texte dynamique
              Container(
                height: 75,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                ),
                child: Center(
                  child: ListTile(
                    title: Text(
                      _selectedLocationIndex != null &&
                          _selectedLocationIndex! < locations.length
                          ? locations[_selectedLocationIndex!]
                          : 'No spot selected', // Texte par défaut si aucun point n'est sélectionné
                      //: '  ',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    subtitle: Text(
                      _selectedLocationIndex != null &&
                          _selectedLocationIndex! < locations.length
                          ? "Marine weather condition"
                          : ' Marine weather condition', // Si aucun point sélectionné, pas de sous-titre
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
              // Affichage conditionnel du DropdownButton
              if (_selectedLocationIndex != null &&
                  _selectedLocationIndex! < locations.length) ...[
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
              ],
              // Texte centré au bas du Drawer si aucun point n'est sélectionné
              if (_selectedLocationIndex == null || _selectedLocationIndex! >= locations.length) ...[
                Expanded(
                  child: Center(
                    child: Text(
                      'Please, select a surf point on the map to have information on its marine weather condition', // Le message centré
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
              // Espace entre le DropdownButton et le graphique
              SizedBox(height: 10), // Ajustez cette valeur pour augmenter l'espace entre le DropdownButton et le graphique
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
                        textStyle: TextStyle(fontSize: 7), // Réduction de la taille de la police des étiquettes de données
                      ),
                    ),
                  ],
                ),
              SizedBox(height: 9), // Espace graphique et boussole/temperature
              // Affichage de la température à gauche et de la boussole à droite
              if (_selectedLocationIndex != null && _selectedLocationIndex! < locations.length) ...[
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Affichage de la température
                      // Widget d'affichage de la température et icône météo
                      Container(
                        //padding: EdgeInsets.all(20),
                        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20), // Augmenté les marges à gauche et à droite à l'interieur du container
                        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10), // Marges au tour du container
                        width: 400, // 80% de la largeur de l'écran
                        height: 200, // Hauteur fixe (modifiable selon votre besoin)
                        decoration: BoxDecoration(
                          color: Colors.grey[800],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black),
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Température et icône météo
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Température avec icône météo
                                Column(
                                  children: [
                                    _getWeatherIcon(
                                      _selectedLocationIndex != null && weatherCodesData.isNotEmpty
                                          ? weatherCodesData[selectedTimeIndex]
                                          : null,
                                    ),
                                    SizedBox(height: 5),
                                    Text(
                                      'Température',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                    //SizedBox(height: 3),
                                    Text(
                                      '${_selectedLocationIndex != null && temperaturesData.isNotEmpty ? temperaturesData[selectedTimeIndex].toStringAsFixed(1) : 'N/A'} °C',
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.yellow,
                                      ),
                                    ),
                                  ],
                                ),
                                // Boussole et direction du vent
                                Column(
                                  children: [
                                    SizedBox(height: 20), // Abaisser la boussole
                                    CompassWidget(
                                      direction: _getWindWaveDirectionAtSelectedTime(),
                                    ),
                                    SizedBox(height: 25), // Entre boussole et texte
                                    Text(
                                      'Wind Direction: ${_getWindWaveDirectionAtSelectedTime().toStringAsFixed(1)}°',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                    //SizedBox(height: 5),
                                    Text(
                                      'Wind Speed: ${_selectedLocationIndex != null && windSpeeds.isNotEmpty ? windSpeeds[selectedTimeIndex].toStringAsFixed(1) : 'N/A'} km/h',
                                      style: TextStyle(color: Colors.white, fontSize: 12),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                //SizedBox(height: 1), // Espace entre boussole/temperature et slider
                // Déplacement du Slider en bas
                if (waveData.isNotEmpty) ...[
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: [
                        // Texte affichant la date sélectionnée par le curseur
                        Text(
                          DateFormat('dd MMM, HH:mm').format(waveData[selectedTimeIndex].time),
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.white,
                          ),
                        ),
                        SliderTheme(
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
                            max: (waveData.length - 1).toDouble(),
                            divisions: waveData.length - 1,
                            label: DateFormat('dd MMM, HH:mm').format(waveData[selectedTimeIndex].time),
                            onChanged: (double value) {
                              setState(() {
                                selectedTimeIndex = value.toInt();
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
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
                  'https://api.maptiler.com/maps/hybrid/{z}/{x}/{y}.jpg?key=0TxzvB62bau6O7bY1ukn',
              zoomPanBehavior: _zoomPanBehavior,
              initialMarkersCount: displayedMarkers.length,
              markerBuilder: (BuildContext context, int index) {
                return MapMarker(
                  latitude: displayedMarkers[index].latitude,
                  longitude: displayedMarkers[index].longitude,
                  child: MouseRegion(
                    onEnter: (_) {},
                    onExit: (_) {},
                    cursor: SystemMouseCursors.click,
                    child: Tooltip(
                      message: locations[index],
                      textStyle: TextStyle(color: Colors.white),
                      decoration: BoxDecoration(
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: IconButton(
                        onPressed: () {
                          _openSidePanel(index);
                        },
                        icon: Icon(Icons.place),
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                );
              },
              onWillZoom: (MapZoomDetails details) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  _updateMarkers();
                });
                return true;
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
          width: 100,
          height: 100,
        );
    }
    switch (weatherDescription) {
      case 'Clear sky':
        return SvgPicture.asset(
            'assets/weather_icons/clear-day.svg',
            width: 100,
            height: 100,
            fit: BoxFit.fill
        );
      case 'Mainly clear':
        return SvgPicture.asset(
          'assets/weather_icons/partly-cloudy-day.svg',
          width: 100,
          height: 100,
        );
      case 'Partly cloudy':
        return SvgPicture.asset(
          'assets/weather_icons/overcast-day.svg',
          width: 100,
          height: 100,
        );
      case 'Overcast':
        return SvgPicture.asset(
          'assets/weather_icons/overcast.svg',
          width: 100,
          height: 100,
        );
      case 'Fog':
        return SvgPicture.asset(
          'assets/weather_icons/fog-day.svg',
          width: 100,
          height: 100,
        );
      case 'Slight rain':
        return SvgPicture.asset(
          'assets/weather_icons/rain.svg',
          width: 100,
          height: 100,
        );
      case 'Depositing rime fog':
        return SvgPicture.asset(
          'assets/weather_icons/fog.svg',
          width: 100,
          height: 100,
        );
      case 'Light drizzle':
        return SvgPicture.asset(
          'assets/weather_icons/partly-cloudy-day-drizzle.svg',
          width: 100,
          height: 100,
        );
      case 'Moderate drizzle':
        return SvgPicture.asset(
          'assets/weather_icons/drizzle.svg',
          width: 100,
          height: 100,
        );
      case 'Dense drizzle':
        return SvgPicture.asset(
          'assets/weather_icons/rain.svg',
          width: 100,
          height: 100,
        );
      case 'Moderate rain':
        return SvgPicture.asset(
          'assets/weather_icons/rain.svg',
          width: 100,
          height: 100,
        );
      case 'Heavy rain':
        return SvgPicture.asset(
          'assets/weather_icons/thunderstorms-day-rain.svg',
          width: 100,
          height: 100,
        );
      case 'Slight snow':
        return SvgPicture.asset(
          'assets/weather_icons/snow.svg',
          width: 100,
          height: 100,
        );
      case 'Moderate snow':
        return SvgPicture.asset(
          'assets/weather_icons/snow.svg',
          width: 100,
          height: 100,
        );
      case 'Heavy snow':
        return SvgPicture.asset(
          'assets/weather_icons/thunderstorms-day-snow.svg',
          width: 100,
          height: 100,
        );
      default:
        return //Icon(Icons.help_outline, color: Colors.white, size: 100);
          SvgPicture.asset(
            'assets/weather_icons/partly-cloudy-day.svg',
            width: 100,
            height: 100,
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