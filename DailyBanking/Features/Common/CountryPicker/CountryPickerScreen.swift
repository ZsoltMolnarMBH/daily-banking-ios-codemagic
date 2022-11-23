//
//  CountryPickerView.swift
//  DailyBanking
//
//  Created by Márk József Alexa on 2022. 01. 12..
//

import SwiftUI
import DesignKit

struct CountryCreationDescriptor {
    var title: String
    var defaultValue: Country
}

protocol CountryPickerScreenViewModelProtocol: ObservableObject {
    var countries: [Country] { get }
    var searchText: String { get set }
    var countryCreationDescriptor: CountryCreationDescriptor? { get }
    var countrySelectedAction: (Country) -> Void { get }
    var dismissAction: () -> Void { get }

    func isDisabled(country: Country) -> Bool
    func handle(event: CountryPickerScreenInput)
}

extension CountryPickerScreenViewModelProtocol {
    var isAddNewEnabled: Bool {
        countryCreationDescriptor != nil
    }
}

enum CountryPickerScreenInput {
    case select(country: Country)
}

struct CountryPickerScreen<ViewModel: CountryPickerScreenViewModelProtocol>: View {

    @ObservedObject var viewModel: ViewModel

    var body: some View {
        VStack(spacing: 0) {
            DesignTextField(
                prefixImage: Image(.search),
                text: $viewModel.searchText,
                prompt: Strings.Localizable.commonSearch,
                validationState: .normal)
            .padding(.horizontal)
            if viewModel.countries.isEmpty {
                emptyView
            } else {
                FullHeightScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(viewModel.countries, id: \.code) { country in
                            countryRow(country)
                        }
                    }
                    Spacer()
                }
            }
        }
        .animation(.default, value: viewModel.countries.count)
        .navigationBarItems(
            trailing: viewModel.isAddNewEnabled
            ? NavigationLink(destination: getCountryCretionScreen(with: viewModel.countryCreationDescriptor?.title ?? ""), label: {
                Image(.add).foregroundColor(.highlight.tertiary)
            })
            : nil
        )
    }

    var emptyView: some View {
        VStack(spacing: .l) {
            Image(.noSearchResult)
            getEmptyViewTitle()
                .textStyle(.body2)
                .foregroundColor(.text.secondary)
                .multilineTextAlignment(.center)
            Spacer()

        }
        .padding()
    }

    func countryRow(_ country: Country) -> some View {
        CardButton(
            title: country.name,
            image: Image(.flag),
            style: .primary,
            clearBackground: true,
            supplementaryImage: nil) {
                viewModel.handle(event: .select(country: country))
            }
            .disabled(viewModel.isDisabled(country: country))
    }

    private func getCountryCretionScreen(with title: String) -> some View {
        CountryCreationScreen(
            viewModel: CountryCreationScreenViewModel(
                countryCreationDescriptor: .init(
                    title: title,
                    defaultValue: viewModel.countryCreationDescriptor?.defaultValue ?? .empty),
                onCountrySelected: viewModel.countrySelectedAction,
                dismissAction: viewModel.dismissAction
            )
        )
        .navigationTitle(title)
    }

    private func getEmptyViewTitle() -> Text {
        viewModel.isAddNewEnabled
        ? Text(Strings.Localizable.countryPickerSearchCountryNotFoundTitleWhenUserCanAddNew)
        : Text(Strings.Localizable.commonSearchNoResult)
    }
}

struct CountryPickerScreen_Previews: PreviewProvider {
    @Binding var country: Country

    static var previews: some View {
        CountryPickerScreen(viewModel: MockCountryPickerScreenViewModel())
            .preferredColorScheme(.dark)
    }
}

private class MockCountryPickerScreenViewModel: CountryPickerScreenViewModelProtocol {
    var countryCreationDescriptor: CountryCreationDescriptor?
    var dismissAction: () -> Void = { }
    var countrySelectedAction: (Country) -> Void = { _ in }
    var searchText: String = ""
    var countries: [Country] = [
        .init(code: "hu", name: "Magyarország"),
        .init(code: "as", name: "Oroszország"),
        .init(code: "fd", name: "Németország"),
        .init(code: "hud", name: "Magyarország"),
        .init(code: "asd", name: "Oroszország"),
        .init(code: "fdv", name: "Németország"),
        .init(code: "hux", name: "Magyarország"),
        .init(code: "asa", name: "Oroszország"),
        .init(code: "fdd", name: "Németország"),
        .init(code: "ere", name: "Narnia")
    ]
    var canAddNew: Bool = false

    func isDisabled(country: Country) -> Bool { return false }
    func handle(event: CountryPickerScreenInput) {}
}
