import 'package:kekoldi_surveys/models/csv_column.dart';

const speciesString = 'Species';

final List<CsvColumn> defaultBiodiversityCsvColumns = [
  CsvColumn(
    header: 'Species',
    field: speciesString,
  ),
  CsvColumn(
    header: 'scientific name',
    field: null,
  ),
  CsvColumn(
    header: 'family',
    field: null,
  ),
  CsvColumn(
    header: 'order',
    field: null,
  ),
  CsvColumn(
    header: 'class',
    field: null,
  ),
  CsvColumn(
    header: 'IUCN status',
    field: null,
  ),
  CsvColumn(
    header: 'Migratory',
    field: null,
  ),
  CsvColumn(
    header: 'Habitat Preferred',
    field: null,
  ),
  CsvColumn(
    header: '#',
    field: 'Quantity',
  ),
  CsvColumn(
    header: 'Height',
    field: 'Height',
  ),
  CsvColumn(
    header: 'Substrate',
    field: 'Substrate',
  ),
  CsvColumn(
    header: 'Sex',
    field: 'Sex',
  ),
  CsvColumn(
    header: 'Adult/Juvenile',
    field: 'Age',
  ),
  CsvColumn(
    header: 'Type of Obs',
    field: 'Type Of Observation',
  ),
];

final List<CsvColumn> defaultBirdTransectColumns = [
  CsvColumn(
    header: 'Transect Number',
  ),
  CsvColumn(
    header: 'Transect Start time',
    field: null,
  ),
  CsvColumn(
    header: 'Species',
    field: null,
  ),
  CsvColumn(
    header: 'scientific name',
    field: null,
  ),
  CsvColumn(
    header: 'family',
    field: null,
  ),
  CsvColumn(
    header: 'order',
    field: null,
  ),
  CsvColumn(
    header: 'class',
    field: null,
  ),
  CsvColumn(
    header: 'IUCN status',
    field: null,
  ),
  CsvColumn(
    header: 'Migratory',
    field: null,
  ),
  CsvColumn(
    header: 'Preferred Habitat',
    field: null,
  ),
  CsvColumn(
    header: 'Category',
    field: null,
  ),
  CsvColumn(
    header: 'Less than 30',
    field: null,
  ),
  CsvColumn(
    header: 'More than 30',
    field: null,
  ),
  CsvColumn(
    header: 'Flyover',
    field: null,
  ),
];

final List<CsvColumn> defaultBirdPointCountColumns = [
  CsvColumn(
    header: 'Point Number',
    field: null,
  ),
  CsvColumn(
    header: 'Point Start time',
    field: null,
  ),
  CsvColumn(
    header: 'Species',
    field: null,
  ),
  CsvColumn(
    header: 'scientific name',
    field: null,
  ),
  CsvColumn(
    header: 'family',
    field: null,
  ),
  CsvColumn(
    header: 'order',
    field: null,
  ),
  CsvColumn(
    header: 'class',
    field: null,
  ),
  CsvColumn(
    header: 'IUCN status',
    field: null,
  ),
  CsvColumn(
    header: 'Migratory',
    field: null,
  ),
  CsvColumn(
    header: 'Preferred Habitat',
    field: null,
  ),
  CsvColumn(
    header: 'Category',
    field: null,
  ),
  CsvColumn(
    header: '0-3 Mins Less than 30',
    field: null,
  ),
  CsvColumn(
    header: '0-3 Mins More than30',
    field: null,
  ),
  CsvColumn(
    header: '0-3 Mins Flyover',
    field: null,
  ),
  CsvColumn(
    header: '3+ Mins Less than 30',
    field: null,
  ),
  CsvColumn(
    header: '3+ Mins more than 30',
  ),
  CsvColumn(
    header: '3+ Mins Flyover',
  ),
];
