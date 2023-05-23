import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:my_app/classes/court.dart';
import '../classes/address.dart';

class CourtProvider extends ChangeNotifier {
  Court? _selectedCourt;

  Court? get selectedCourt => _selectedCourt;

  set selectedCourt(Court? value) {
    _selectedCourt = value;
    notifyListeners();
  }

  Set<Court> _courts = <Court>{
    Court(
      position: const LatLng(59.41539988194249, 18.045802457670916),
      name: 'Utomhusplanen Danderyd',
      imageLink: 'assets/danderyd.jpeg',
      courtType: 'PVC tiles',
      address: Address(
        'Rinkebyvägen 4',
        'Danderyd',
        18236,
        59.41539988194249,
        18.045802457670916,
      ),
      numberOfHoops: 6,
    ),

    Court(
      position: const LatLng(59.31414212184781, 18.193681711645432),
      name: 'Ektorps Streetcourt',
      imageLink: 'assets/Ektorp-streetcourt.jpg',
      courtType: 'PVC tiles',
      address: Address('Edinsvägen 4', 'Nacka', 13145, 59.31414212184781,
          18.193681711645432),
      numberOfHoops: 6,
    ),

    Court(
      position: const LatLng(59.31182915015506, 18.074395203696394),
      name: 'Åsö - Södermalm',
      imageLink: 'assets/Aso_9.jpg',
      courtType: 'Asphalt',
      address: Address(
        'Blekingegatan 55',
        'Stockholm',
        11894,
        59.31182915015506,
        18.074395203696394,
      ),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.30782448316834, 17.994079119038222),
      name: 'Aspudden IP',
      imageLink: 'assets/3.-Aspudden-1-1200-1024x683-1.jpg',
      courtType: 'Synthetic rubber',
      address: Address('Hövdingsgatan 20', 'Hägersten', 12652,
          59.30782448316834, 17.994079119038222),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.29402145383548, 17.932262457670912),
      name: 'Parkleken Ängen',
      imageLink: 'assets/bredang.jpg',
      courtType: 'Synthetic rubber',
      address: Address(
        'Bredängsvägen 22',
        'Skärholmen',
        12732,
        59.29402145383548,
        17.932262457670912,
      ),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.39710830523342, 17.90629260229956),
      name: 'Elinsborgs Basketplan',
      imageLink: 'assets/COTW-elinsborgsskolan-1634164938.jpeg',
      courtType: 'Synthetic rubber',
      address: Address('Åvingegränd 29', 'Spånga', 16368, 59.39710830523342,
          17.90629260229956),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.21683912857965, 18.149234026943972),
      name: 'Skogåsskolan 3x3',
      imageLink: 'assets/skogas.jpg',
      courtType: 'PVC tiles',
      address: Address(
          'Lötbacken', 'Skogås', 14230, 59.21683912857965, 18.149234026943972),
      numberOfHoops: 1,
    ),

    Court(
      position: const LatLng(59.51779053942923, 17.640217411044326),
      name: 'Stjärnparken',
      imageLink: 'assets/rabyplanen.jpg',
      courtType: 'PVC tiles',
      address: Address('Idrottsstigen 15', 'Bro', 19731, 59.51779053942923,
          17.640217411044326),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.254592810710456, 18.031293796423572),
      name: 'Rågdalen',
      imageLink: 'assets/Ragsved.jpeg',
      courtType: 'Asphalt',
      address: Address('Bjursätragatan 50-52', 'Bandhagen', 12464,
          59.254592810710456, 18.031293796423572),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.37829473768301, 17.93254852514142),
      name: 'Rosa pantern',
      imageLink: 'assets/3.-Rissne-IP-1-1200-1024x683-1.jpg',
      courtType: 'Asphalt',
      address: Address('Mässvägen 1', 'Sundbyberg', 17459, 59.37829473768301,
          17.93254852514142),
      numberOfHoops: 4,
    ),

    Court(
      position: const LatLng(59.361336758932545, 17.880385460974416),
      name: 'Parkleken Ådalen',
      imageLink: 'assets/vallingby.jpg',
      courtType: 'Asphalt',
      address: Address('Ångermannagatan 107', 'Vällingby', 16264,
          59.361336758932545, 17.880385460974416),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.33223538532373, 18.03662024059145),
      name: 'Kronobergsparken',
      imageLink: 'assets/3.-Kronobergsparken-1-1200-1024x683-1.jpg',
      courtType: 'Asphalt',
      address: Address('Parkgatan 6', 'Stockholm', 11230, 59.33223538532373,
          18.03662024059145),
      numberOfHoops: 2,
    ),

    Court(
      position: const LatLng(59.3177720380705, 18.13782764395781),
      name: 'Kvarnholmen 3x3',
      imageLink: 'assets/Kvarnholmen.jpg',
      courtType: 'PVC tiles',
      address: Address('Mjölnarvägen 16', 'Nacka', 13131, 59.3177720380705,
          18.13782764395781),
      numberOfHoops: 1,
    ),

    Court(
      position: const LatLng(59.32994118662108, 18.032987047205225),
      name: 'Kungsholmen Gymnasium',
      imageLink: 'assets/3.-Kungsholmen-1-1200-1024x683-1.jpg',
      courtType: 'Asphalt',
      address: Address('Hantverkargatan 67', 'Stockholm', 11238,
          59.32994118662108, 18.032987047205225),
      numberOfHoops: 2,
    ),
    Court(
      position: const LatLng(59.328892205905085, 18.02265152337728),
      name: 'Rålambshovsparken 2x2',
      imageLink: 'assets/Ralambshovsparken.jpg',
      courtType: 'Asphalt',
      address: Address('Marieberg', 'Stockholm', 11235, 59.328892205905085,
          18.02265152337728),
      numberOfHoops: 2,
    ),
    Court(
      position: const LatLng(59.323065057417715, 17.915055714487504),
      name: 'Kärsögården',
      imageLink: 'assets/karson.jpg',
      courtType: 'PVC tiles',
      address: Address('Brostugans väg', 'Drottningholm', 17893,
          59.323065057417715, 17.915055714487504),
      numberOfHoops: 4,
    ),
    // Add more court markers here
  };

  Set<Court> get courts => _courts;

  void setCourts(Set<Court> courts) {
    _courts = courts;
    notifyListeners();
  }

  void addCourt(Court court) {
    _courts.add(court);
    notifyListeners();
  }

  void remove(Court court) {
    _courts.remove(court);
    notifyListeners();
  }
}
