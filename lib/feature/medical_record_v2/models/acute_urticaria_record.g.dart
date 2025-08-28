// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'acute_urticaria_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AcuteUrticariaRecord _$AcuteUrticariaRecordFromJson(
        Map<String, dynamic> json) =>
    AcuteUrticariaRecord()
      ..fullName = json['fullName'] as String?
      ..nationalId = json['nationalId'] as String?
      ..age = json['age'] as String?
      ..gender = json['gender'] as String?
      ..phoneNumber = json['phoneNumber'] as String?
      ..addressArea = json['addressArea'] as String?
      ..occupation = json['occupation'] as String?
      ..exposureHistory = json['exposureHistory'] as String?
      ..recordOpenDate = json['recordOpenDate'] as String?
      ..examinationDate = json['examinationDate'] as String?
      ..continuousOutbreak6Weeks = json['continuousOutbreak6Weeks'] as String?
      ..rashOrAngioedema = json['rashOrAngioedema'] as String?
      ..firstOutbreakSinceWeeks = json['firstOutbreakSinceWeeks'] as String?
      ..outbreakCount = json['outbreakCount'] as String?
      ..outbreak1StartMonth = json['outbreak1StartMonth'] as String?
      ..outbreak1StartYear = json['outbreak1StartYear'] as String?
      ..outbreak1EndMonth = json['outbreak1EndMonth'] as String?
      ..outbreak1EndYear = json['outbreak1EndYear'] as String?
      ..outbreak1TreatmentReceived =
          json['outbreak1TreatmentReceived'] as String?
      ..outbreak1DrugResponse = json['outbreak1DrugResponse'] as String?
      ..outbreak1DrugResponseSymptom =
          json['outbreak1DrugResponseSymptom'] as String?
      ..outbreak2StartMonth = json['outbreak2StartMonth'] as String?
      ..outbreak2StartYear = json['outbreak2StartYear'] as String?
      ..outbreak2EndMonth = json['outbreak2EndMonth'] as String?
      ..outbreak2EndYear = json['outbreak2EndYear'] as String?
      ..outbreak2TreatmentReceived =
          json['outbreak2TreatmentReceived'] as String?
      ..outbreak2DrugResponse = json['outbreak2DrugResponse'] as String?
      ..outbreak2DrugResponseSymptom =
          json['outbreak2DrugResponseSymptom'] as String?
      ..outbreak3StartMonth = json['outbreak3StartMonth'] as String?
      ..outbreak3StartYear = json['outbreak3StartYear'] as String?
      ..outbreak3EndMonth = json['outbreak3EndMonth'] as String?
      ..outbreak3EndYear = json['outbreak3EndYear'] as String?
      ..outbreak3TreatmentReceived =
          json['outbreak3TreatmentReceived'] as String?
      ..outbreak3DrugResponse = json['outbreak3DrugResponse'] as String?
      ..outbreak3DrugResponseSymptom =
          json['outbreak3DrugResponseSymptom'] as String?
      ..currentOutbreakStartMonth = json['currentOutbreakStartMonth'] as String?
      ..currentOutbreakStartYear = json['currentOutbreakStartYear'] as String?
      ..currentOutbreakEndMonth = json['currentOutbreakEndMonth'] as String?
      ..currentOutbreakEndYear = json['currentOutbreakEndYear'] as String?
      ..currentOutbreakWeeks = json['currentOutbreakWeeks'] as String?
      ..currentTreatmentReceived = json['currentTreatmentReceived'] as String?
      ..currentDrugResponse = json['currentDrugResponse'] as String?
      ..currentDrugResponseSymptom =
          json['currentDrugResponseSymptom'] as String?
      ..drugName = json['drugName'] as String?
      ..drugDuration = json['drugDuration'] as String?
      ..drugDosage = json['drugDosage'] as String?
      ..rashAppearanceTime = json['rashAppearanceTime'] as String?
      ..rashTriggerFactors = (json['rashTriggerFactors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..rashWorseningFactors = (json['rashWorseningFactors'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..rashFoodTriggerDetail = json['rashFoodTriggerDetail'] as String?
      ..rashDrugTriggerDetail = json['rashDrugTriggerDetail'] as String?
      ..rashLocation = (json['rashLocation'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..rashLocationImages =
          (json['rashLocationImages'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      )
      ..rashSizeOnTreatment = json['rashSizeOnTreatment'] as String?
      ..rashSizeNoTreatment = json['rashSizeNoTreatment'] as String?
      ..rashBorder = json['rashBorder'] as String?
      ..rashShape = json['rashShape'] as String?
      ..rashColor = json['rashColor'] as String?
      ..rashDurationOnTreatment = json['rashDurationOnTreatment'] as String?
      ..rashDurationNoTreatment = json['rashDurationNoTreatment'] as String?
      ..rashSurface = (json['rashSurface'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..rashTimeOfDay = json['rashTimeOfDay'] as String?
      ..rashCountPerDay = json['rashCountPerDay'] as String?
      ..rashSensation = json['rashSensation'] as String?
      ..angioedemaCount = json['angioedemaCount'] as String?
      ..angioedemaLocation = (json['angioedemaLocation'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..angioedemaLocationImages =
          (json['angioedemaLocationImages'] as Map<String, dynamic>?)?.map(
        (k, e) =>
            MapEntry(k, (e as List<dynamic>).map((e) => e as String).toList()),
      )
      ..angioedemaSurface = (json['angioedemaSurface'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..angioedemaDurationOnTreatment =
          json['angioedemaDurationOnTreatment'] as String?
      ..angioedemaDurationNoTreatment =
          json['angioedemaDurationNoTreatment'] as String?
      ..angioedemaTimeOfDay = json['angioedemaTimeOfDay'] as String?
      ..angioedemaSensation = json['angioedemaSensation'] as String?
      ..triggerInfection = json['triggerInfection'] as String?
      ..triggerFood = json['triggerFood'] as String?
      ..triggerDrug = json['triggerDrug'] as String?
      ..triggerInsectBite = json['triggerInsectBite'] as String?
      ..triggerOther = json['triggerOther'] as String?
      ..personalAllergyHistory = json['personalAllergyHistory'] as String?
      ..personalDrugHistory = json['personalDrugHistory'] as String?
      ..personalUrticariaHistory = json['personalUrticariaHistory'] as String?
      ..personalOtherHistory = json['personalOtherHistory'] as String?
      ..fever = json['fever'] as String?
      ..feverTemperature = json['feverTemperature'] as String?
      ..pulseRate = json['pulseRate'] as String?
      ..bloodPressure = json['bloodPressure'] as String?
      ..preliminaryDiagnosis = json['preliminaryDiagnosis'] as String?
      ..wbc = json['wbc'] as String?
      ..neu = json['neu'] as String?
      ..crp = json['crp'] as String?
      ..totalIgE = json['totalIgE'] as String?
      ..otherLabTests = json['otherLabTests'] as String?
      ..finalDiagnosis = json['finalDiagnosis'] as String?
      ..antihistamineH1 = json['antihistamineH1'] as String?
      ..corticosteroidSystemic = json['corticosteroidSystemic'] as String?
      ..hospitalization = json['hospitalization'] as String?
      ..followUpDate = json['followUpDate'] as String?;

Map<String, dynamic> _$AcuteUrticariaRecordToJson(
        AcuteUrticariaRecord instance) =>
    <String, dynamic>{
      'fullName': instance.fullName,
      'nationalId': instance.nationalId,
      'age': instance.age,
      'gender': instance.gender,
      'phoneNumber': instance.phoneNumber,
      'addressArea': instance.addressArea,
      'occupation': instance.occupation,
      'exposureHistory': instance.exposureHistory,
      'recordOpenDate': instance.recordOpenDate,
      'examinationDate': instance.examinationDate,
      'continuousOutbreak6Weeks': instance.continuousOutbreak6Weeks,
      'rashOrAngioedema': instance.rashOrAngioedema,
      'firstOutbreakSinceWeeks': instance.firstOutbreakSinceWeeks,
      'outbreakCount': instance.outbreakCount,
      'outbreak1StartMonth': instance.outbreak1StartMonth,
      'outbreak1StartYear': instance.outbreak1StartYear,
      'outbreak1EndMonth': instance.outbreak1EndMonth,
      'outbreak1EndYear': instance.outbreak1EndYear,
      'outbreak1TreatmentReceived': instance.outbreak1TreatmentReceived,
      'outbreak1DrugResponse': instance.outbreak1DrugResponse,
      'outbreak1DrugResponseSymptom': instance.outbreak1DrugResponseSymptom,
      'outbreak2StartMonth': instance.outbreak2StartMonth,
      'outbreak2StartYear': instance.outbreak2StartYear,
      'outbreak2EndMonth': instance.outbreak2EndMonth,
      'outbreak2EndYear': instance.outbreak2EndYear,
      'outbreak2TreatmentReceived': instance.outbreak2TreatmentReceived,
      'outbreak2DrugResponse': instance.outbreak2DrugResponse,
      'outbreak2DrugResponseSymptom': instance.outbreak2DrugResponseSymptom,
      'outbreak3StartMonth': instance.outbreak3StartMonth,
      'outbreak3StartYear': instance.outbreak3StartYear,
      'outbreak3EndMonth': instance.outbreak3EndMonth,
      'outbreak3EndYear': instance.outbreak3EndYear,
      'outbreak3TreatmentReceived': instance.outbreak3TreatmentReceived,
      'outbreak3DrugResponse': instance.outbreak3DrugResponse,
      'outbreak3DrugResponseSymptom': instance.outbreak3DrugResponseSymptom,
      'currentOutbreakStartMonth': instance.currentOutbreakStartMonth,
      'currentOutbreakStartYear': instance.currentOutbreakStartYear,
      'currentOutbreakEndMonth': instance.currentOutbreakEndMonth,
      'currentOutbreakEndYear': instance.currentOutbreakEndYear,
      'currentOutbreakWeeks': instance.currentOutbreakWeeks,
      'currentTreatmentReceived': instance.currentTreatmentReceived,
      'currentDrugResponse': instance.currentDrugResponse,
      'currentDrugResponseSymptom': instance.currentDrugResponseSymptom,
      'drugName': instance.drugName,
      'drugDuration': instance.drugDuration,
      'drugDosage': instance.drugDosage,
      'rashAppearanceTime': instance.rashAppearanceTime,
      'rashTriggerFactors': instance.rashTriggerFactors,
      'rashWorseningFactors': instance.rashWorseningFactors,
      'rashFoodTriggerDetail': instance.rashFoodTriggerDetail,
      'rashDrugTriggerDetail': instance.rashDrugTriggerDetail,
      'rashLocation': instance.rashLocation,
      'rashLocationImages': instance.rashLocationImages,
      'rashSizeOnTreatment': instance.rashSizeOnTreatment,
      'rashSizeNoTreatment': instance.rashSizeNoTreatment,
      'rashBorder': instance.rashBorder,
      'rashShape': instance.rashShape,
      'rashColor': instance.rashColor,
      'rashDurationOnTreatment': instance.rashDurationOnTreatment,
      'rashDurationNoTreatment': instance.rashDurationNoTreatment,
      'rashSurface': instance.rashSurface,
      'rashTimeOfDay': instance.rashTimeOfDay,
      'rashCountPerDay': instance.rashCountPerDay,
      'rashSensation': instance.rashSensation,
      'angioedemaCount': instance.angioedemaCount,
      'angioedemaLocation': instance.angioedemaLocation,
      'angioedemaLocationImages': instance.angioedemaLocationImages,
      'angioedemaSurface': instance.angioedemaSurface,
      'angioedemaDurationOnTreatment': instance.angioedemaDurationOnTreatment,
      'angioedemaDurationNoTreatment': instance.angioedemaDurationNoTreatment,
      'angioedemaTimeOfDay': instance.angioedemaTimeOfDay,
      'angioedemaSensation': instance.angioedemaSensation,
      'triggerInfection': instance.triggerInfection,
      'triggerFood': instance.triggerFood,
      'triggerDrug': instance.triggerDrug,
      'triggerInsectBite': instance.triggerInsectBite,
      'triggerOther': instance.triggerOther,
      'personalAllergyHistory': instance.personalAllergyHistory,
      'personalDrugHistory': instance.personalDrugHistory,
      'personalUrticariaHistory': instance.personalUrticariaHistory,
      'personalOtherHistory': instance.personalOtherHistory,
      'fever': instance.fever,
      'feverTemperature': instance.feverTemperature,
      'pulseRate': instance.pulseRate,
      'bloodPressure': instance.bloodPressure,
      'preliminaryDiagnosis': instance.preliminaryDiagnosis,
      'wbc': instance.wbc,
      'neu': instance.neu,
      'crp': instance.crp,
      'totalIgE': instance.totalIgE,
      'otherLabTests': instance.otherLabTests,
      'finalDiagnosis': instance.finalDiagnosis,
      'antihistamineH1': instance.antihistamineH1,
      'corticosteroidSystemic': instance.corticosteroidSystemic,
      'hospitalization': instance.hospitalization,
      'followUpDate': instance.followUpDate,
    };
