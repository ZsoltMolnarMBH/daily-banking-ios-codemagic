//
//  KycAssembly.swift
//  DailyBanking
//
//  Created by Szabó Zoltán on 2022. 03. 22..
//

import Foundation
import Resolver
import Network
import BankAPI

extension Resolver.Name {
    struct FaceKom { }
    static let faceKom = FaceKom()
}

class KycAssembly: Assembly {
    func assemble(container: Resolver) {

        container.registerInContext { container in
            container.resolve(AppConfig.self).kyc
        }
        .implements(KycConfig.self)

        container.registerInContext {
            CameraPermissionHandler()
        }

        container.registerInContext {
            MemoryKycDraftStore()
        }
        .implements((any KycDraftStore).self)
        .scope(container.cache)

        container.registerInContext {
            MemoryKycStepStore()
        }
        .implements((any KycStepStore).self)
        .scope(container.cache)

        container.registerInContext(ReadOnly<KycDraft>.self) { container in
            container.resolve((any KycDraftStore).self).state
        }

        container.registerInContext(ReadOnly<FaceKom.Step>.self) { container in
            container.resolve((any KycStepStore).self).state
        }

        container.registerInContext(Mapper<FaceKom.DataConfirmationFields, IndividualInput>.self) {
            IndividualInputMapper()
        }

        container.registerInContext(FaceKomAction.self) {
            FaceKomActionImpl()
        }
        .scope(container.cache)

        container.registerInContext {
            DefaultCameraPreviewProvider()
        }
        .implements(CameraPreviewProvider.self)

        container.registerInContext {
            KycStartScreenViewModel()
        }

        container.registerInContext(KycStartScreen<KycStartScreenViewModel>.self) { container in
            KycStartScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            FaceKomSelfServiceImpl()
        }
        .implements(FaceKomSelfService.self)
        .scope(container.cache)

        container.registerInContext {
            KycIDFrontScreenViewModel()
        }

        container.registerInContext(KycPhotoScreen<KycIDFrontScreenViewModel>.self) { container in
            KycPhotoScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            KycIDBackScreenViewModel()
        }

        container.registerInContext(KycPhotoScreen<KycIDBackScreenViewModel>.self) { container in
            KycPhotoScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            KycLivenessCheckScreenViewModel()
        }

        container.registerInContext(KycVideoScreen<KycLivenessCheckScreenViewModel>.self) { container in
            KycVideoScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            KycSelfiePhotoScreenViewModel()
        }

        container.registerInContext(KycPhotoScreen<KycSelfiePhotoScreenViewModel>.self) { container in
            KycPhotoScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            KycHologramScreenViewModel()
        }

        container.registerInContext(KycVideoScreen<KycHologramScreenViewModel>.self) { container in
            KycVideoScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            KycProofOfAddressScreenViewModel()
        }

        container.registerInContext(KycPhotoScreen<KycProofOfAddressScreenViewModel>.self) { container in
            KycPhotoScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            ElectronicIDReaderScreenViewModel()
        }

        container.registerInContext(ElectronicIDReaderScreen<ElectronicIDReaderScreenViewModel>.self) { container in
            ElectronicIDReaderScreen(viewModel: container.resolve())
        }

        container.registerInContext {
            PersonalDataStartScreenViewModel()
        }

        container.registerInContext {
            PersonalDataContactsScreenViewModel()
        }

        container.registerInContext {
            PersonalDataPersonalDataScreenViewModel()
        }

        container.registerInContext {
            PersonalDataAddressScreenViewModel()
        }

        container.registerInContext {
            PersonalDataDocumentsScreenViewModel()
        }

        container.registerInContext(PersonalDataStartScreen<PersonalDataStartScreenViewModel>.self) { container in
            PersonalDataStartScreen(viewModel: container.resolve())
        }

        container.registerInContext(PersonalDataContactsScreen<PersonalDataContactsScreenViewModel>.self) { container in
            PersonalDataContactsScreen(viewModel: container.resolve())
        }

        container.registerInContext(PersonalDataPersonalDataScreen<PersonalDataPersonalDataScreenViewModel>.self) { container in
            PersonalDataPersonalDataScreen(viewModel: container.resolve())
        }

        container.registerInContext(PersonalDataAddressScreen<PersonalDataAddressScreenViewModel>.self) { container in
            PersonalDataAddressScreen(viewModel: container.resolve())
        }

        container.registerInContext(PersonalDataDocumentsScreen<PersonalDataDocumentsScreenViewModel>.self) { container in
            PersonalDataDocumentsScreen(viewModel: container.resolve())
        }
    }
}
