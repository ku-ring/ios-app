//
//  LoginTermsAndConditions.swift
//  package-kuring
//
//  Created by Jung Hwan Park on 9/6/25.
//

import SwiftUI
import ColorSet
import SettingsFeatures

public struct LoginTermsAndConditionsView: View {
    @State private var didAgreeToTerms: Bool?
    
    public var body: some View {
        VStack {
            HeaderView(
                title: "개인정보 수집/이용 동의",
                subtitle: "회원 가입 전 하단 유의사항을 확인하고,\n개인정보 수집 및 이용에 동의해주세요."
            )
            
            termsAndConditions
            AgreementButton(didAgreeToTerms: $didAgreeToTerms)
            
            Spacer(minLength: 63)
            
            NavigationLink(state: SettingsAppFeature.Path.State.signup) {
                ActionButton(
                    title: "다음",
                    isActive: .constant((didAgreeToTerms ?? false))
                )
                .disabled(true)
            }
        }
        .padding(20)
        .background(Color.Kuring.bg)
    }
    
    private var termsAndConditions: some View {
        ScrollView {
            Text(TermsAndConditions.fullText)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.Kuring.caption1)
                .padding(18)
        }
        .background(
            Rectangle()
                .stroke(Color.Kuring.gray100, lineWidth: 2)
        )
        .padding(.top, 45)
    }
    
    public init() {}
}

private struct AgreementButton: View {
    @Binding var didAgreeToTerms: Bool?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("[필수] 개인정보 수집/이용에 동의하십니까?")
            
            radioButton(isSelected: didAgreeToTerms == true, title: "예") {
                self.didAgreeToTerms = true
            }
            
            radioButton(isSelected: didAgreeToTerms == false, title: "아니오") {
                self.didAgreeToTerms = false
            }
        }
        .font(.body)
        .padding(.top, 13)
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private func radioButton(isSelected: Bool, title: String, action: @escaping () -> Void) -> some View {
        HStack(spacing: 8) {
            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.Kuring.primary)
            } else {
                Circle()
                    .strokeBorder(Color.Kuring.gray300, lineWidth: 2)
                    .frame(width: 24, height: 24)
                    .onTapGesture {
                        action()
                    }
            }
            
            Text("\(title)")
        }
    }
}

private enum TermsAndConditions {
    static let fullText = """
        [ 개인정보 수집/이용 및 제공에 대한 안내 ]
        '쿠링'은 개인정보보호법에 의거 대학 구성원에게 대학의 공지사항을 제공하기 위해 필요한 개인정보를 수집하고 활용되며, 기관의 법적 의무준수를 위하여 수집 목적에 맞게 제3자에게 제공하거나 처리를 위탁합니다. 그 외 목적으로 활용될 경우 정보주체에게 사전 고지되며, 활용에 동의한 범위와 기간에 한해 안전하게 제공, 처리 및 삭제됩니다.
        
        1. 수집하는 개인정보의 항목
        가. 쿠링은 계정생성, 각종 서비스의 제공을 위해 최초 계정생성 당시 아래와 같은 최소한의 개인정보를 필수항목으로 수집하고 있습니다.
        - 학교 메일 아이디, 비밀번호
        나. 서비스 이용과정에서 아래와 같은 정보들이 자동으로 생성되어 수집 및 이용될 수 있습니다.
        - IP주소, 쿠키정보, 접속 일시, 이용 내역, 불량 이용 기록, 계정인증정보, 계정 사용자 정보 등
        다. '쿠링' 통합계정을 이용하는 서비스 이용과정에서 해당 서비스 이용자에 한해서만 개인정보 추가 수집이 발생할 수 있으며, 이러한 경우 별도의 동의를 받습니다.
        2. 개인정보의 수집 및 이용 목적
        가. 계정 생성
        - 통합계정 서비스 제공, 컨텐츠 제공, 본인인증
        나. 계정 관리
        - 개인식별, 부정 이용방지와 비인가 사용방지
        3. 개인정보의 보유 및 이용기간
        이용자의 개인정보는 원칙적으로 개인정보의 수집 및 이용목적이 달성되면 지체 없이 파기합니다. 단, 다음의 정보에 대해서는 아래의 이유로 명시한 기간 동안 보존합니다.
        가. 통합계정 서비스 이용
        - 보존이유: 통합계정을 통한 서비스 제공
        - 보존기간: 통합계정 서비스 지침에 따라 보존되며, 보존기간 만료 시 지체 없이 파기
        4. 거부 권리 및 서비스 이용 제한
        개인정보의 수집 및 이용 동의를 거부할 권리가 있으며, 동의 거부 시 서비스 이용이 제한됨.
        """
}

#Preview {
    LoginTermsAndConditionsView()
}
