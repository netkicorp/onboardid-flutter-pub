package com.netki.netki_sdk

import com.netki.model.AdditionalDataField
import com.netki.model.BusinessConfiguration
import com.netki.model.IdCountry
import com.netki.model.IdType
import com.netki.model.OnBoardIdTheme
import com.netki.model.Picture
import com.netki.model.PictureType
import com.netki.model.RequestStatus
import com.netki.model.ResultInfo

object Mappers {

    // MARK: - ResultInfo

    fun resultInfoToMap(resultInfo: ResultInfo): Map<String, Any?> {
        return mapOf(
            "status" to if (resultInfo.status == RequestStatus.SUCCESS) "SUCCESS" else "ERROR",
            "extraData" to sanitizeExtraData(resultInfo.extraData),
            "errorType" to resultInfo.errorType?.name,
            "message" to resultInfo.message
        )
    }

    // Recursively sanitize extraData to ensure all values are Flutter-compatible
    private fun sanitizeExtraData(data: Any?): Any? {
        return when (data) {
            null -> null
            is String, is Number, is Boolean -> data
            is Map<*, *> -> data.mapValues { sanitizeExtraData(it.value) }
            is List<*> -> data.map { sanitizeExtraData(it) }
            is com.netki.model.Picture -> pictureToMap(data)
            is com.netki.model.Barcode -> barcodeToMap(data)
            is com.netki.model.Barcode.DriverLicense -> driverLicenseToMap(data)
            is com.netki.model.PassportContent -> passportContentToMap(data)
            is com.netki.model.EPassportContent -> ePassportContentToMap(data)
            is com.netki.model.AdditionalPersonalData -> additionalPersonalDataToMap(data)
            is com.netki.model.LivenessInformation -> livenessInformationToMap(data)
            is Enum<*> -> data.name
            else -> data.toString() // Fallback: convert to string
        }
    }

    // MARK: - IdCountry

    fun idCountryToMap(country: IdCountry): Map<String, Any?> {
        return mapOf(
            "name" to country.name,
            "alpha2" to country.alpha2,
            "alpha3" to country.alpha3,
            "countryCallingCode" to country.countryCallingCode,
            "hasBarcodeId" to country.hasBarcodeId,
            "flag" to country.flag,
            "isBanned" to country.isBanned,
            "hasNfcPassport" to country.hasNfcPassport
        )
    }

    fun mapToIdCountry(map: Map<String, Any?>): IdCountry {
        return IdCountry(
            name = map["name"] as? String ?: "",
            alpha2 = map["alpha2"] as? String ?: "",
            alpha3 = map["alpha3"] as? String ?: "",
            countryCallingCode = map["countryCallingCode"] as? String ?: "",
            hasBarcodeId = map["hasBarcodeId"] as? Boolean ?: false,
            flag = map["flag"] as? String,
            isBanned = map["isBanned"] as? Boolean ?: false,
            hasNfcPassport = map["hasNfcPassport"] as? Boolean ?: false
        )
    }

    // MARK: - AdditionalDataField

    fun mapToAdditionalDataFields(map: Map<String, String>): HashMap<AdditionalDataField, String> {
        val result = HashMap<AdditionalDataField, String>()
        for ((key, value) in map) {
            try {
                // Convert snake_case to SCREAMING_SNAKE_CASE for enum valueOf
                val enumName = key.uppercase()
                val field = AdditionalDataField.valueOf(enumName)
                result[field] = value
            } catch (e: IllegalArgumentException) {
                // Skip unknown fields
            }
        }
        return result
    }

    // MARK: - BusinessConfiguration

    fun businessConfigurationToMap(config: BusinessConfiguration): Map<String, Any?> {
        return mapOf(
            "name" to config.name,
            "identificationId" to config.identificationId,
            "welcomeMessage" to config.welcomeMessage,
            "logoLight" to config.logoLight,
            "minimumAppVersion" to config.minimumAppVersion,
            "phonePinTimeout" to config.phonePinTimeout,
            "phoneRetryAttemptLimit" to config.phoneRetryAttemptLimit,
            "phoneUseAutomaticBypass" to config.phoneUseAutomaticBypass,
            "clientGuid" to config.clientGuid,
            "redirectBackLink" to config.redirectBackLink,
            "completedMessage" to config.completedMessage,
            "isGeolocationEnabled" to config.isGeolocationEnabled
        )
    }

    // MARK: - Picture

    fun pictureToMap(picture: Picture): Map<String, Any?> {
        return mapOf(
            "path" to picture.path,
            "type" to picture.type?.type,
            "barcodes" to picture.barcodes?.map { barcodeToMap(it) },
            "passportContent" to picture.passportContent?.let { passportContentToMap(it) },
            "ePassportContent" to picture.ePassportContent?.let { ePassportContentToMap(it) },
            "livenessInformation" to picture.livenessInformation?.let { livenessInformationToMap(it) }
        )
    }

    // MARK: - Barcode

    private fun barcodeToMap(barcode: com.netki.model.Barcode): Map<String, Any?> {
        return mapOf(
            "rawValue" to barcode.rawValue,
            "displayValue" to barcode.displayValue,
            "valueFormat" to barcode.valueFormat,
            "driverLicense" to barcode.driverLicense?.let { driverLicenseToMap(it) }
        )
    }

    private fun driverLicenseToMap(dl: com.netki.model.Barcode.DriverLicense): Map<String, Any?> {
        return mapOf(
            "documentType" to dl.documentType,
            "documentDiscriminator" to dl.documentDiscriminator,
            "firstName" to dl.firstName,
            "middleName" to dl.middleName,
            "lastName" to dl.lastName,
            "gender" to dl.gender,
            "placeOfBirth" to dl.placeOfBirth,
            "addressStreet" to dl.addressStreet,
            "addressUnit" to dl.addressUnit,
            "addressCity" to dl.addressCity,
            "addressState" to dl.addressState,
            "addressZip" to dl.addressZip,
            "licenseNumber" to dl.licenseNumber,
            "issueDate" to dl.issueDate,
            "expiryDate" to dl.expiryDate,
            "birthDate" to dl.birthDate,
            "height" to dl.height,
            "eyeColor" to dl.eyeColor,
            "hairColor" to dl.hairColor,
            "weight" to dl.weight,
            "issuingCountry" to dl.issuingCountry
        )
    }

    fun picturesToList(pictures: List<Picture>): List<Map<String, Any?>> {
        return pictures.map { pictureToMap(it) }
    }

    // MARK: - PassportContent

    private fun passportContentToMap(content: com.netki.model.PassportContent): Map<String, Any?> {
        return mapOf(
            "text" to content.text,
            "passportType" to content.passportType,
            "countryCode" to content.countryCode,
            "lastName" to content.lastName,
            "firstName" to content.firstName,
            "passportNumber" to content.passportNumber,
            "passportNumberDigitCheck" to content.passportNumberDigitCheck,
            "nationality" to content.nationality,
            "birthDate" to content.birthDate,
            "birthDateDigitCheck" to content.birthDateDigitCheck,
            "gender" to content.gender,
            "expirationDate" to content.expirationDate,
            "expirationDateDigitCheck" to content.expirationDateDigitCheck,
            "personalNumber" to content.personalNumber,
            "personalNumberDigitCheck" to content.personalNumberDigitCheck,
            "stringDigitCheck" to content.stringDigitCheck,
            "digitCheck" to content.digitCheck,
            "isValid" to content.isValid,
            "confidence" to content.confidence
        )
    }

    // MARK: - EPassportContent

    private fun ePassportContentToMap(content: com.netki.model.EPassportContent): Map<String, Any?> {
        return mapOf(
            "isValid" to content.isValid,
            "documentCode" to content.documentCode,
            "issuingState" to content.issuingState,
            "primaryIdentifier" to content.primaryIdentifier,
            "secondaryIdentifier" to content.secondaryIdentifier,
            "nationality" to content.nationality,
            "documentNumber" to content.documentNumber,
            "dateOfBirth" to content.dateOfBirth,
            "gender" to content.gender?.name,
            "dateOfExpiry" to content.dateOfExpiry,
            "optionalData1" to content.optionalData1,
            "optionalData2" to content.optionalData2,
            "faceImagePath" to content.faceImagePath,
            "additionalPersonalData" to content.additionalPersonalData?.let { additionalPersonalDataToMap(it) }
        )
    }

    // MARK: - AdditionalPersonalData

    private fun additionalPersonalDataToMap(data: com.netki.model.AdditionalPersonalData): Map<String, Any?> {
        return mapOf(
            "nameOfHolder" to data.nameOfHolder,
            "custodyInformation" to data.custodyInformation,
            "otherValidTDNumbers" to data.otherValidTDNumbers,
            "permanentAddress" to data.permanentAddress,
            "personalNumber" to data.personalNumber,
            "placeOfBirth" to data.placeOfBirth,
            "telephone" to data.telephone,
            "profession" to data.profession,
            "title" to data.title,
            "personalSummary" to data.personalSummary,
            "proofOfCitizenship" to data.proofOfCitizenship,
            "tdNumbers" to data.tdNumbers
        )
    }

    // MARK: - LivenessInformation

    private fun livenessInformationToMap(info: com.netki.model.LivenessInformation): Map<String, Any?> {
        return mapOf(
            "isLive" to info.isLive,
            "livenessScore" to info.livenessScore,
            "livenessActionAttempts" to info.livenessActionAttempts
        )
    }

    // MARK: - OnBoardIdTheme

    fun mapToOnBoardIdTheme(map: Map<String, Any?>): OnBoardIdTheme {
        @Suppress("UNCHECKED_CAST")
        val buttonsMap = map["buttons"] as? Map<String, Any?> ?: emptyMap()
        @Suppress("UNCHECKED_CAST")
        val contentMap = map["content"] as? Map<String, Any?> ?: emptyMap()
        @Suppress("UNCHECKED_CAST")
        val instructionsList = map["instructions"] as? List<Map<String, Any?>> ?: emptyList()

        return OnBoardIdTheme(
            buttons = mapToButtonColors(buttonsMap),
            content = mapToContentColors(contentMap),
            instructions = instructionsList.map { mapToInstructionContent(it) }
        )
    }

    private fun mapToButtonColors(map: Map<String, Any?>): OnBoardIdTheme.ButtonColors {
        return OnBoardIdTheme.ButtonColors(
            primaryBackground = map["primaryBackground"] as? String,
            primaryText = map["primaryText"] as? String,
            secondaryBackground = map["secondaryBackground"] as? String,
            secondaryText = map["secondaryText"] as? String,
            cornerRadiusDp = (map["cornerRadiusDp"] as? Number)?.toFloat()
        )
    }

    private fun mapToContentColors(map: Map<String, Any?>): OnBoardIdTheme.ContentColors {
        return OnBoardIdTheme.ContentColors(
            background = map["background"] as? String,
            surface = map["surface"] as? String,
            border = map["border"] as? String,
            titleText = map["titleText"] as? String,
            subtitleText = map["subtitleText"] as? String,
            bodyText = map["bodyText"] as? String
        )
    }

    private fun mapToInstructionContent(map: Map<String, Any?>): OnBoardIdTheme.InstructionContent {
        val idTypeStr = map["idType"] as? String ?: ""
        val pictureTypeStr = map["pictureType"] as? String ?: ""

        @Suppress("UNCHECKED_CAST")
        val stepsList = map["steps"] as? List<Map<String, Any?>>

        return OnBoardIdTheme.InstructionContent(
            idType = IdType.entries.firstOrNull { it.type == idTypeStr } ?: IdType.GOVERNMENT_ID,
            pictureType = PictureType.entries.firstOrNull { it.type == pictureTypeStr } ?: PictureType.FRONT,
            title = map["title"] as? String,
            subtitle = map["subtitle"] as? String,
            body = map["body"] as? String,
            steps = stepsList?.map { mapToInstructionItem(it) },
            imageUrl = map["imageUrl"] as? String,
            videoPath = map["videoPath"] as? String
        )
    }

    private fun mapToInstructionItem(map: Map<String, Any?>): OnBoardIdTheme.InstructionItem {
        return OnBoardIdTheme.InstructionItem(
            text = map["text"] as? String ?: "",
            iconUrl = map["iconUrl"] as? String,
            isWarning = map["isWarning"] as? Boolean ?: false
        )
    }
}
