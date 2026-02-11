    //
    //  SignInView.swift
    //  Calendar
    //
    //  Created by Caleb Mace on 1/28/26.
    //
import SwiftUI

struct SignInView: View {
    @State var viewModel: SignInViewModel = SignInViewModel()
    @Environment(DataFetcher.self) var dataFetcher
    
    var body: some View {
        NavigationStack {
            ZStack {
                VStack {
                    HStack {
                        Text("Email:")
                            .font(.custom("system", size: 17))
                            .padding(.trailing, 15)
                        TextField("Email", text: $viewModel.email)
                            .textInputAutocapitalization(.never)
                            .textFieldStyle(.roundedBorder)
                            .frame(width: 265)
                    }
                    HStack {
                        Text("Password:")
                            .font(.custom("system", size: 17))
                            .padding(.trailing, 15)
                        Group {
                            if viewModel.isPasswordHidden {
                                SecureField("Password", text: $viewModel.password)
                                    .textInputAutocapitalization(.never)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 225)
                            } else {
                                TextField("Password", text: $viewModel.password)
                                    .textInputAutocapitalization(.never)
                                    .textFieldStyle(.roundedBorder)
                                    .frame(width: 225)
                            }
                        }
                        Button {
                            viewModel.isPasswordHidden.toggle()
                        } label: {
                            Image(systemName: viewModel.isPasswordHidden ? "eye" : "eye.slash")
                        }
                    }
                    Button {
                        viewModel.isLoading = true
                        Task {
                            do {
                                viewModel.user = try await dataFetcher.dataProvider.login(email: viewModel.email, password: viewModel.password)
                                viewModel.isLoading = false
                            } catch {
                                viewModel.error = error
                                viewModel.isLoading = false
                            }
                        }
                    } label: {
                        Text("Sign In")
                    }
                    .disabled(Bool(viewModel.email.isEmpty || viewModel.password.isEmpty))
                    .buttonStyle(.glassProminent)
                    .padding(.vertical, 30)
                }
                .padding()
                if viewModel.isLoading {
                    RoundedRectangle(cornerRadius: 20)
                        .ignoresSafeArea()
                        .foregroundStyle(.ultraThinMaterial)
                    ProgressView("Logging you in...")
                        .progressViewStyle(.circular)
                }
                if viewModel.user != nil || viewModel.error != nil {
                    RoundedRectangle(cornerRadius: 20)
                        .ignoresSafeArea()
                        .foregroundStyle(.ultraThinMaterial)
                    VStack {
                        Image(systemName: "\(viewModel.user != nil ? "lock.open.fill" : "lock.fill")")
                            .resizable()
                            .frame(width: viewModel.user != nil ? 130 : 100, height: viewModel.user != nil ? 130 : 140)
                            .foregroundStyle(viewModel.user != nil ? .green : .red)
                            .task {
                                await viewModel.triggerNextScreen()
                                dataFetcher.dataProvider.user = viewModel.user
                            }
                        Text(viewModel.user != nil ? "Signed in!" : "Sign in failed")
                            .font(.largeTitle)
                            .foregroundStyle(viewModel.user != nil ? .green : .red)
                    }
                }
            }
            .navigationTitle("Sign In")
            .navigationBarBackButtonHidden()
        }
    }
}

