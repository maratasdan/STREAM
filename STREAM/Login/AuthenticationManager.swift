//
//  AuthenticationManager.swift
//  STREAM
//
//  Created by Danxd on 8/7/26.
//

import Foundation
import MSAL

final class AuthenticationManager {

    static let shared = AuthenticationManager()

    private let clientId = "6eeaa4e9-a734-471e-9d1f-efb744dd6904"
    private let tenantId = "c203ec90-7ea9-4efb-9564-75987ac32638"

    private let redirectUri = "msauth.dan.sccpayroll.STREAM://auth"

    lazy var application: MSALPublicClientApplication? = {

        do {

            let authority = try MSALAADAuthority(
                url: URL(string:
                    "https://login.microsoftonline.com/\(tenantId)"
                )!
            )

            let config = MSALPublicClientApplicationConfig(
                clientId: clientId,
                redirectUri: redirectUri,
                authority: authority
            )

            return try MSALPublicClientApplication(configuration: config)

        } catch {

            print(error)

            return nil

        }

    }()
    
    func signIn(from viewController: UIViewController,
                completion: @escaping (Result<MSALResult, Error>) -> Void) {

        guard let application = application else {
            return
        }

        let webParameters = MSALWebviewParameters(authPresentationViewController: viewController)

        let parameters = MSALInteractiveTokenParameters(
            scopes: ["User.Read"],
            webviewParameters: webParameters
        )

        parameters.promptType = MSALPromptType.selectAccount

        application.acquireToken(with: parameters) { result, error in

            if let error = error {
                completion(.failure(error))
                return
            }

            guard let result = result else {
                return
            }

            completion(.success(result))
        }
    }
    
    func signOut() {

        guard let application = application else {
            return
        }

        do {

            let accounts = try application.allAccounts()

            print("Accounts:", accounts.count)

            if let account = accounts.first {

                try application.remove(account)
                print("Logout Success")

            } else {

                print("No Account")

            }

        } catch {

            print(error)

        }

    }

}
