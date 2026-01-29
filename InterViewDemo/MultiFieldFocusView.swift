//
//  MultiFieldFocusView.swift
//  InterViewDemo
//
//  Created by Ibrahim Mo Gedami on 29/01/2026.
//

import SwiftUI
import Combine

enum FieldType: String, Codable {
    case text
    case secure
    case email
    case number
}

// MARK: - API Field Model (Stateful)

final class FormField: ObservableObject, Identifiable, Hashable {
    
    static func == (lhs: FormField, rhs: FormField) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    let id: String
    let placeholder: String
    let type: FieldType
    
    @Published var value: String = ""
    
    init(id: String, placeholder: String, type: FieldType) {
        self.id = id
        self.placeholder = placeholder
        self.type = type
    }
}

// MARK: - Mock API

struct MockAPI {
    static func fetchFields() -> [FormField] {
        return [
            FormField(id: "username", placeholder: "Username", type: .text),
            FormField(id: "email", placeholder: "Email", type: .email),
            FormField(id: "phone", placeholder: "Phone Number", type: .number),
            FormField(id: "firstName", placeholder: "First Name", type: .text),
            FormField(id: "lastName", placeholder: "Last Name", type: .text),
            FormField(id: "password", placeholder: "Password", type: .secure)
        ]
    }
}

// MARK: - ViewModel

final class MultiFieldViewModel: ObservableObject {
    @Published var fields: [FormField] = []
    
    func load() {
        self.fields = MockAPI.fetchFields()
    }
}

// MARK: - View

struct MultiFieldFocusView: View {
    
    @StateObject private var vm = MultiFieldViewModel()
    @FocusState private var focusedField: FormField?
    
    var body: some View {
        VStack(spacing: 16) {
            
            Text("Dynamic API Form")
                .font(.title2.bold())
                .padding(.bottom, 12)
            
            ForEach(vm.fields) { field in
                InputRow(
                    field: field,
                    focusedField: $focusedField,
                    onSubmit: {
                        focusNext(after: field)
                    }
                )
            }
            
            Button {
                focusedField = nil
            } label: {
                Text("Submit")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
            }
            .padding(.top, 24)
        }
        .padding()
        .onAppear {
            vm.load()
            if let first = vm.fields.first {
                focusedField = first
            }
        }
    }

    private func focusNext(after field: FormField) {
        guard let index = vm.fields.firstIndex(of: field) else {
            focusedField = nil
            return
        }
        
        let nextIndex = vm.fields.index(after: index)
        
        if nextIndex < vm.fields.count {
            focusedField = vm.fields[nextIndex]
        } else {
            focusedField = nil
        }
    }
}

struct InputRow: View {
    
    @ObservedObject var field: FormField
    @FocusState.Binding var focusedField: FormField?
    
    let onSubmit: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            icon
            inputField
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(focusedField == field ? Color.blue : Color.gray.opacity(0.4), lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.2), value: focusedField == field)
    }
    
    // MARK: - Input Field
    
    @ViewBuilder
    private var inputField: some View {
        switch field.type {
        case .secure:
            SecureField(field.placeholder, text: binding)
                .focused($focusedField, equals: field)
                .onSubmit(onSubmit)
            
        default:
            TextField(field.placeholder, text: binding)
                .keyboardType(keyboardType)
                .focused($focusedField, equals: field)
                .onSubmit(onSubmit)
        }
    }
    
    // MARK: - Binding
    
    private var binding: Binding<String> {
        Binding(
            get: { field.value },
            set: { field.value = $0 }
        )
    }
    
    // MARK: - Icon
    
    private var icon: some View {
        Image(systemName: iconName)
            .foregroundColor(focusedField == field ? .blue : .gray)
    }
    
    private var iconName: String {
        switch field.type {
        case .email: return "envelope"
        case .number: return "phone"
        case .secure: return "lock"
        default: return "person"
        }
    }
    
    // MARK: - Keyboard
    
    private var keyboardType: UIKeyboardType {
        switch field.type {
        case .email: return .emailAddress
        case .number: return .numberPad
        default: return .default
        }
    }
}


#Preview {
    MultiFieldFocusView()
}
