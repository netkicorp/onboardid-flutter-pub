import NetkiSDK

struct Mappers {

    // MARK: - ResultInfo

    static func resultInfoToMap(_ resultInfo: ResultInfo) -> [String: Any?] {
        return [
            "status": resultInfo.status == .SUCCESS ? "SUCCESS" : "ERROR",
            "extraData": sanitizeForFlutter(resultInfo.extraData),
            "errorType": resultInfo.errorType?.rawValue,
            "message": resultInfo.message
        ]
    }

    // MARK: - Sanitize for Flutter

    /// Recursively sanitize data to ensure all values are Flutter-compatible
    static func sanitizeForFlutter(_ value: Any?) -> Any? {
        guard let value = value else { return nil }

        switch value {
        case let string as String:
            return string
        case let number as NSNumber:
            return number
        case let bool as Bool:
            return bool
        case let array as [Any]:
            return array.map { sanitizeForFlutter($0) }
        case let dict as [String: Any]:
            return dict.mapValues { sanitizeForFlutter($0) }
        case let picture as Picture:
            return pictureToMap(picture)
        default:
            // For any other type, convert to string representation
            return String(describing: value)
        }
    }

    // MARK: - Picture

    static func pictureToMap(_ picture: Picture) -> [String: Any?] {
        return [
            "path": picture.path,
            "type": picture.type.rawValue,
            "barcodes": picture.barcodes?.map { barcodeToMap($0) },
            "passportContent": picture.passportContent.map { passportContentToMap($0) },
            "ePassportContent": picture.ePassportContent.map { ePassportContentToMap($0) },
            "livenessInformation": picture.livenessInformation.map { livenessInformationToMap($0) }
        ]
    }

    private static func barcodeToMap(_ barcode: Barcode) -> [String: Any?] {
        return [
            "rawValue": barcode.rawValue,
            "displayValue": barcode.displayValue,
            "valueFormat": barcode.valueFormat,
            "driverLicense": barcode.driverLicense.map { driverLicenseToMap($0) }
        ]
    }

    private static func driverLicenseToMap(_ dl: DriverLicense) -> [String: Any?] {
        return [
            "documentType": dl.documentType,
            "documentDiscriminator": dl.documentDiscriminator,
            "firstName": dl.firstName,
            "middleName": dl.middleName,
            "lastName": dl.lastName,
            "gender": dl.gender,
            "placeOfBirth": dl.placeOfBirth,
            "addressStreet": dl.addressStreet,
            "addressUnit": dl.addressUnit,
            "addressCity": dl.addressCity,
            "addressState": dl.addressState,
            "addressZip": dl.addressZip,
            "licenseNumber": dl.licenseNumber,
            "issueDate": dl.issueDate,
            "expiryDate": dl.expiryDate,
            "birthDate": dl.birthDate,
            "height": dl.height,
            "eyeColor": dl.eyeColor,
            "hairColor": dl.hairColor,
            "weight": dl.weight,
            "issuingCountry": dl.issuingCountry
        ]
    }

    private static func passportContentToMap(_ content: PassportContent) -> [String: Any?] {
        return [
            "text": content.text,
            "passportType": content.passportType,
            "countryCode": content.countryCode,
            "lastName": content.lastName,
            "firstName": content.firstName,
            "passportNumber": content.passportNumber,
            "passportNumberDigitCheck": content.passportNumberDigitCheck,
            "nationality": content.nationality,
            "birthDate": content.birthDate,
            "birthDateDigitCheck": content.birthDateDigitCheck,
            "gender": content.gender,
            "expirationDate": content.expirationDate,
            "expirationDateDigitCheck": content.expirationDateDigitCheck,
            "personalNumber": content.personalNumber,
            "personalNumberDigitCheck": content.personalNumberDigitCheck,
            "stringDigitCheck": content.stringDigitCheck,
            "digitCheck": content.digitCheck,
            "isValid": content.isValid,
            "confidence": content.confidence
        ]
    }

    private static func ePassportContentToMap(_ content: EPassportContent) -> [String: Any?] {
        return [
            "isValid": content.isValid,
            "documentCode": content.documentCode,
            "issuingState": content.issuingState,
            "primaryIdentifier": content.primaryIdentifier,
            "secondaryIdentifier": content.secondaryIdentifier,
            "nationality": content.nationality,
            "documentNumber": content.documentNumber,
            "dateOfBirth": content.dateOfBirth,
            "gender": content.gender?.rawValue,
            "dateOfExpiry": content.dateOfExpiry,
            "optionalData1": content.optionalData1,
            "optionalData2": content.optionalData2,
            "faceImagePath": content.faceImagePath,
            "additionalPersonalData": content.additionalPersonalData.map { additionalPersonalDataToMap($0) }
        ]
    }

    private static func additionalPersonalDataToMap(_ data: AdditionalPersonalData) -> [String: Any?] {
        return [
            "nameOfHolder": data.nameOfHolder,
            "custodyInformation": data.custodyInformation,
            "otherValidTDNumbers": data.otherValidTDNumbers,
            "permanentAddress": data.permanentAddress,
            "personalNumber": data.personalNumber,
            "placeOfBirth": data.placeOfBirth,
            "telephone": data.telephone,
            "profession": data.profession,
            "title": data.title,
            "personalSummary": data.personalSummary,
            "proofOfCitizenship": data.proofOfCitizenship,
            "tdNumbers": data.tdNumbers
        ]
    }

    private static func livenessInformationToMap(_ info: LivenessInformation) -> [String: Any?] {
        return [
            "isLive": info.isLive,
            "livenessScore": info.livenessScore,
            "livenessActionAttempts": info.livenessActionAttempts
        ]
    }

    // MARK: - IdCountry

    static func idCountryToMap(_ country: IdCountry) -> [String: Any?] {
        return [
            "name": country.name,
            "alpha2": country.alpha2,
            "alpha3": country.alpha3,
            "countryCallingCode": country.countryCallingCode,
            "hasBarcodeId": country.hasBarcodeId,
            "flag": country.flag,
            "isBanned": country.isBanned,
            "hasNfcPassport": country.hasNfcPassport
        ]
    }

    static func mapToIdCountry(_ map: [String: Any]) -> IdCountry {
        return IdCountry(
            name: map["name"] as? String ?? "",
            alpha2: map["alpha2"] as? String ?? "",
            alpha3: map["alpha3"] as? String ?? "",
            countryCallingCode: map["countryCallingCode"] as? String ?? "",
            hasBarcodeId: map["hasBarcodeId"] as? Bool ?? false,
            flag: map["flag"] as? String,
            isBanned: map["isBanned"] as? Bool ?? false,
            hasNfcPassport: map["hasNfcPassport"] as? Bool ?? false
        )
    }

    // MARK: - AdditionalDataField

    static func mapToAdditionalDataFields(_ map: [String: String]) -> [AdditionalDataField: String] {
        var result: [AdditionalDataField: String] = [:]
        for (key, value) in map {
            if let field = AdditionalDataField(rawValue: key) {
                result[field] = value
            }
        }
        return result
    }

    // MARK: - BusinessConfiguration

    static func businessConfigurationToMap(_ config: BusinessConfiguration) -> [String: Any?] {
        return [
            "name": config.name,
            "identificationId": config.identificationId,
            "welcomeMessage": config.welcomeMessage,
            "logoLight": config.logoLight,
            "minimumAppVersion": config.minimumAppVersion,
            "phonePinTimeout": config.phonePinTimeout,
            "phoneRetryAttemptLimit": config.phoneRetryAttemptLimit,
            "phoneUseAutomaticBypass": config.phoneUseAutomaticBypass,
            "clientGuid": config.clientGuid,
            "redirectBackLink": config.redirectBackLink,
            "completedMessage": config.completedMessage,
            "isGeolocationEnabled": config.isGeolocationEnabled
        ]
    }

    // MARK: - OnBoardIdTheme

    static func mapToOnBoardIdTheme(_ map: [String: Any]) -> OnBoardIdTheme {
        let buttonsMap = map["buttons"] as? [String: Any] ?? [:]
        let contentMap = map["content"] as? [String: Any] ?? [:]
        let instructionsList = map["instructions"] as? [[String: Any]] ?? []

        return OnBoardIdTheme(
            buttons: mapToButtonColors(buttonsMap),
            content: mapToContentColors(contentMap),
            instructions: instructionsList.map { mapToInstructionContent($0) }
        )
    }

    private static func mapToButtonColors(_ map: [String: Any]) -> OnBoardIdTheme.ButtonColors {
        return OnBoardIdTheme.ButtonColors(
            primaryBackground: map["primaryBackground"] as? String,
            primaryText: map["primaryText"] as? String,
            secondaryBackground: map["secondaryBackground"] as? String,
            secondaryText: map["secondaryText"] as? String,
            cornerRadiusDp: (map["cornerRadiusDp"] as? NSNumber).map { CGFloat($0.doubleValue) }
        )
    }

    private static func mapToContentColors(_ map: [String: Any]) -> OnBoardIdTheme.ContentColors {
        return OnBoardIdTheme.ContentColors(
            background: map["background"] as? String,
            surface: map["surface"] as? String,
            border: map["border"] as? String,
            titleText: map["titleText"] as? String,
            subtitleText: map["subtitleText"] as? String,
            bodyText: map["bodyText"] as? String
        )
    }

    private static func mapToInstructionContent(_ map: [String: Any]) -> OnBoardIdTheme.InstructionContent {
        let idTypeStr = map["idType"] as? String ?? ""
        let pictureTypeStr = map["pictureType"] as? String ?? ""
        let stepsList = map["steps"] as? [[String: Any]]

        return OnBoardIdTheme.InstructionContent(
            idType: IdType(rawValue: idTypeStr) ?? .GOVERNMENT_ID,
            pictureType: PictureType(rawValue: pictureTypeStr) ?? .FRONT,
            title: map["title"] as? String,
            subtitle: map["subtitle"] as? String,
            body: map["body"] as? String,
            steps: stepsList?.map { mapToInstructionItem($0) },
            imageUrl: map["imageUrl"] as? String,
            videoPath: map["videoPath"] as? String
        )
    }

    private static func mapToInstructionItem(_ map: [String: Any]) -> OnBoardIdTheme.InstructionItem {
        return OnBoardIdTheme.InstructionItem(
            text: map["text"] as? String ?? "",
            iconUrl: map["iconUrl"] as? String,
            isWarning: map["isWarning"] as? Bool ?? false
        )
    }
}
