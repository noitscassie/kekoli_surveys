import 'package:kekoldi_surveys/models/csv_column.dart';

const speciesString = 'Species';

final List<CsvColumn> defaultCsvColumns = [
  CsvColumn(header: 'Species', field: null),
  CsvColumn(header: 'scientific name', field: null),
  CsvColumn(header: 'family', field: null),
  CsvColumn(header: 'order', field: null),
  CsvColumn(header: 'class', field: null),
  CsvColumn(header: 'IUCN status', field: null),
  CsvColumn(header: 'Migratory', field: null),
  CsvColumn(header: 'Habitat Preferred', field: null),
  CsvColumn(header: '#', field: 'Quantity'),
  CsvColumn(header: 'Height', field: 'Height'),
  CsvColumn(header: 'Substrate', field: 'Substrate'),
  CsvColumn(header: 'Sex', field: 'Sex'),
  CsvColumn(header: 'Adult/Juvenile', field: 'Age'),
  CsvColumn(header: 'Type of Obs', field: 'Type Of Observation'),
];
