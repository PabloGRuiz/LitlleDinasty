import 'dart:math';

const List<String> medievalMaleNames = [
  'Aldric',
  'Gareth',
  'Cedric',
  'Rowan',
  'Bram',
  'Edric',
  'Lukas',
  'Tristan',
  'Gideon',
  'Oswin',
  'Godfrey',
  'Henrik',
  'Tobias',
  'Alaric',
  'Dunstan',
  'Soren',
];

const List<String> medievalFemaleNames = [
  'Elara',
  'Mirella',
  'Isolde',
  'Freya',
  'Astrid',
  'Beatrix',
  'Rowena',
  'Lyra',
  'Clara',
  'Helena',
  'Aldith',
  'Sybil',
  'Matilda',
  'Ygraine',
  'Maeve',
  'Avelina',
];

const List<String> medievalSurnames = [
  'del Valle',
  'Piedrafuerte',
  'del Fresno',
  'Montegrís',
  'Bosqueverde',
  'Albar',
  'Vadoclaro',
  'Cuervo',
  'Robledo',
  'Brumablanca',
  'de la Colina',
  'Espino',
];

const List<String> remoteVillages = [
  'Vallebruma',
  'Piedralba',
  'Aldea del Brezo',
  'Otero Gris',
  'Vado del Fresno',
  'Loma del Cuervo',
  'Fuente Clara',
  'Bosquehondo',
];

String pickRandomMaleName(Random rng) =>
    medievalMaleNames[rng.nextInt(medievalMaleNames.length)];

String pickRandomFemaleName(Random rng) =>
    medievalFemaleNames[rng.nextInt(medievalFemaleNames.length)];

String pickRandomSurname(Random rng) =>
    medievalSurnames[rng.nextInt(medievalSurnames.length)];

String pickRandomVillage(Random rng) =>
    remoteVillages[rng.nextInt(remoteVillages.length)];

String pickRandomNpcName(Random rng) {
  final all = [...medievalMaleNames, ...medievalFemaleNames];
  return all[rng.nextInt(all.length)];
}

