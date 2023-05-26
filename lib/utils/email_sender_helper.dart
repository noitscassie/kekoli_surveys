import 'package:kekoldi_surveys/models/biodiversity_survey.dart';
import 'package:kekoldi_surveys/models/bird_survey.dart';
import 'package:kekoldi_surveys/utils/time_utils.dart';

class EmailSenderHelper {
  static final emailRegex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  static bool isEmailValid(String emailAddress) =>
      emailRegex.hasMatch(emailAddress);

  static String biodiversityBody({required BiodiversitySurvey survey}) =>
      'The ${survey.trail} survey on ${DateFormats.ddmmyyyy(survey.startAt!)} started at ${TimeFormats.timeHoursAndMinutes(survey.startAt!)} and ended at ${TimeFormats.timeHoursAndMinutes(survey.endAt!)}, lasting ${TimeFormats.hmFromMinutes(survey.lengthInMinutes())}.\n\nThere were ${survey.allParticipants.length} participants: ${survey.allParticipants.join(', ')}\n\nThere were ${survey.totalObservations} observations in total, ${survey.uniqueSpecies} unique species, and a total abundance of ${survey.totalAbundance}.\n\nThe weather was ${survey.weather!.toLowerCase()}';

  static String birdSurveyBody(BirdSurvey survey) =>
      'Bird ${survey.type.title} ${survey.trail} on ${DateFormats.ddmmyyyy(survey.startAt!)}.\n\nThere were ${survey.allParticipants.length} participants: ${survey.allParticipants.join(', ')}\n\nThere were ${survey.totalObservations} observations in total, with ${survey.uniqueSpecies} unique species.\n\nThe weather was ${survey.weather!.toLowerCase()}';
}
